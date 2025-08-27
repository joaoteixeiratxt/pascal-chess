unit PC.Room.Controller;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections,
  PC.Indy.Facade, PC.State, PC.Player, PC.Piece, PC.Room;

const
  SERVER_ENDPOINT = 'https://pascal-chess.onrender.com';

type
  TRoomController = class
  private
    class var FHttpClient: IHttpClient;
    class var FCurrent: IRoom;
    class var FPlayer: IPlayer;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Enter(const Player: IPlayer; const RoomName: string); static;
    class procedure CreateRoom(const Name: string; Time: Integer; Owner: IPlayer); static;
    class function GetRoom(const Name: string): IRoom; static;
    class procedure DeleteRoom(const Name: string); static;
    class procedure GetRooms(out RoomsList: TStringList); static;
    class procedure UpdateState(const Room: IRoom); static;
    class procedure Leave; static;
    class property Current: IRoom read FCurrent write FCurrent;
    class property Player: IPlayer read FPlayer write FPlayer;
  end;

implementation

{ TRoomController }

class constructor TRoomController.Create;
begin
  FHttpClient := NewIndyHttpClient();
end;

class destructor TRoomController.Destroy;
begin
  FHttpClient := nil;
end;

class procedure TRoomController.Enter(const Player: IPlayer; const RoomName: string);
begin
  FPlayer := Player;

  FCurrent.State.CurrentPlayerColor := pcBlack;
  FCurrent.State.OpponentColor := pcWhite;

  FCurrent := GetRoom(RoomName);
  FCurrent.Players.Add(Player);
  FCurrent.NextPlayersBlackPiece.Add(Player);
  FCurrent.Push();
end;

class procedure TRoomController.CreateRoom(const Name: string; Time: Integer; Owner: IPlayer);
var
  URL: string;
  JSON: TJSONObject;
  Response: IHttpResponse;
  DefaultPlayerList: TPlayerList;
begin
  FPlayer := Owner;
  FCurrent := TRoom.Create();
  FCurrent.State.Initialize();

  JSON := TJSONObject.Create();
  try
    JSON.AddPair('name', Name);
    JSON.AddPair('owner', Owner.ToJSON());
    JSON.AddPair('status', 'on');
    JSON.AddPair('started', TJSONBool.Create(False));
    JSON.AddPair('time', TJSONNumber.Create(Time));
    JSON.AddPair('currentPlayerBlackPiece', TJSONNumber.Create(0));

    DefaultPlayerList := TPlayerList.Create();
    try
      DefaultPlayerList.Add(Owner);
      JSON.AddPair('players', DefaultPlayerList.ToJSON);

      DefaultPlayerList.Clear();
      JSON.AddPair('nextPlayersBlackPiece', DefaultPlayerList.ToJSON);
    finally
      DefaultPlayerList.Free;
    end;

    JSON.AddPair('state', FCurrent.State.ToJSON());

    URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, Name]);
    Response := FHttpClient.Post(URL, JSON.ToJSON());

    if (Response.StatusCode = 201) then
      FCurrent.LoadFromJSON(JSON);
  finally
    JSON.Free;
  end;
end;

class function TRoomController.GetRoom(const Name: string): IRoom;
var
  URL: string;
  JSON: TJSONObject;
  Response: IHttpResponse;
begin
  Result := nil;

  URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, Name]);
  Response := FHttpClient.Get(URL);

  if (Response.StatusCode <> 200) or Response.BodyAsString.IsEmpty then
    Exit;

  JSON := TJSONObject(TJSONObject.ParseJSONValue(Response.BodyAsString));
  try
    Result := TRoom.Create();

    Result.State.CurrentPlayerColor := FCurrent.State.CurrentPlayerColor;
    Result.State.OpponentColor := FCurrent.State.OpponentColor;

    Result.State.Initialize();
    Result.LoadFromJSON(JSON);
  finally
    if Assigned(JSON) then
      JSON.Free;
  end;
end;

class procedure TRoomController.DeleteRoom(const Name: string);
var
  URL: string;
begin
  URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, Name]);
  FHttpClient.Delete(URL);
end;

class procedure TRoomController.GetRooms(out RoomsList: TStringList);
var
  I: Integer;
  URL: string;
  Response: IHttpResponse;
  RoomsArray: TJSONArray;
begin
  URL := Format('%s/rooms', [SERVER_ENDPOINT]);

  Response := FHttpClient.Get(URL);
  RoomsArray := TJSONArray(TJSONObject.ParseJSONValue(Response.BodyAsString));
  try
    if not Assigned(RoomsArray) then
      Exit;

    for I := 0 to Pred(RoomsArray.Count) do
      RoomsList.Add(TJSONString(RoomsArray.Items[I]).Value);
  finally
    if Assigned(RoomsArray) then
      RoomsArray.Free;
  end;
end;

class procedure TRoomController.Leave;
begin
  FCurrent.State.CurrentPlayerColor := pcBlack;
  FCurrent.State.OpponentColor := pcWhite;

  FCurrent := GetRoom(FCurrent.Name);
  FCurrent.Players.DeleteById(FPlayer.Id);
  FCurrent.NextPlayersBlackPiece.DeleteById(FPlayer.Id);
  FCurrent.Push();

  TRoomController.Current.Update();
end;

class procedure TRoomController.UpdateState(const Room: IRoom);
var
  JSON: TJSONObject;
  Response: IHttpResponse;
  URL, CurrentState, NewState: string;
begin
  URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, Room.Name]);
  Response := FHttpClient.Get(URL);

  if (Response.StatusCode <> 200) or Response.BodyAsString.IsEmpty then
    Exit;

  CurrentState := Room.ToJSON();
  NewState := Response.BodyAsString;

  if (CurrentState = NewState) then
    Exit;

  JSON := TJSONObject(TJSONObject.ParseJSONValue(Response.BodyAsString));
  try
    Room.LoadFromJSON(JSON);
  finally
    if Assigned(JSON) then
      JSON.Free;
  end;
end;

initialization
  TRoomController.Current := TRoom.Create();
  TRoomController.Current.State.Initialize();

end.
