unit RoomController;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections,
  HttpClient.IndyFacade, BoardState, BoardPlayer, BoardPiece;

type
  EDeletedRoom = class(Exception);

  TRoomUpdateEvent = procedure of object;

  IRoom = interface
  ['{BECBB98B-2043-441F-9743-37E9443B7333}']
    function GetName: string;
    procedure SetName(const Value: string);
    function GetOwner: IBoardPlayer;
    procedure SetOwner(const Value: IBoardPlayer);
    function GetStatus: string;
    procedure SetStatus(const Value: string);
    function GetStarted: Boolean;
    procedure SetStarted(const Value: Boolean);
    function GetTime: Integer;
    procedure SetTime(const Value: Integer);
    function GetState: IBoardState;
    procedure SetState(const Value: IBoardState);
    function GetPlayers: TPlayerList;
    procedure SetPlayers(const Value: TPlayerList);
    function GetCurrentPlayerBlackPiece: Integer;
    procedure SetCurrentPlayerBlackPiece(const Value: Integer);
    function GetNextPlayersBlackPiece: TPlayerList;
    procedure SetNextPlayersBlackPiece(const Value: TPlayerList);
    property Name: string read GetName write SetName;
    property Owner: IBoardPlayer read GetOwner write SetOwner;
    property Status: string read GetStatus write SetStatus;
    property Started: Boolean read GetStarted write SetStarted;
    property Time: Integer read GetTime write SetTime;
    property Players: TPlayerList read GetPlayers write SetPlayers;
    property CurrentPlayerBlackPiece: Integer read GetCurrentPlayerBlackPiece write SetCurrentPlayerBlackPiece;
    property NextPlayersBlackPiece: TPlayerList read GetNextPlayersBlackPiece write SetNextPlayersBlackPiece;
    property State: IBoardState read GetState write SetState;
    procedure Pull;
    procedure Update;
    procedure RegisterObserver(const Event: TRoomUpdateEvent);
    function ToJSON: string;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TRoom = class(TInterfacedObject, IRoom)
  private
    FName: string;
    FOwner: IBoardPlayer;
    FStatus: string;
    FStarted: Boolean;
    FTime: Integer;
    FState: IBoardState;
    FPlayers: TPlayerList;
    FEvents: TList<TRoomUpdateEvent>;
    FCurrentPlayerBlackPiece: Integer;
    FNextPlayersBlackPiece: TPlayerList;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetOwner: IBoardPlayer;
    procedure SetOwner(const Value: IBoardPlayer);
    function GetStatus: string;
    procedure SetStatus(const Value: string);
    function GetStarted: Boolean;
    procedure SetStarted(const Value: Boolean);
    function GetTime: Integer;
    procedure SetTime(const Value: Integer);
    function GetState: IBoardState;
    procedure SetState(const Value: IBoardState);
    function GetPlayers: TPlayerList;
    procedure SetPlayers(const Value: TPlayerList);
    function GetNextPlayersBlackPiece: TPlayerList;
    procedure SetNextPlayersBlackPiece(const Value: TPlayerList);
    function GetCurrentPlayerBlackPiece: Integer;
    procedure SetCurrentPlayerBlackPiece(const Value: Integer);
    procedure NotifyAll;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Pull;
    procedure Update;
    procedure RegisterObserver(const Event: TRoomUpdateEvent);
    property Name: string read GetName write SetName;
    property Owner: IBoardPlayer read GetOwner write SetOwner;
    property Status: string read GetStatus write SetStatus;
    property Started: Boolean read GetStarted write SetStarted;
    property Time: Integer read GetTime write SetTime;
    property Players: TPlayerList read GetPlayers write SetPlayers;
    property CurrentPlayerBlackPiece: Integer read GetCurrentPlayerBlackPiece write SetCurrentPlayerBlackPiece;
    property NextPlayersBlackPiece: TPlayerList read GetNextPlayersBlackPiece write SetNextPlayersBlackPiece;
    property State: IBoardState read GetState write SetState;
    function ToJSON: string;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TRoomController = class
  private
    class var FHttpClient: IHttpClient;
    class var FCurrent: IRoom;
    class var FPlayer: IBoardPlayer;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Enter(const Player: IBoardPlayer; const RoomName: string); static;
    class procedure CreateRoom(const Name: string; Time: Integer; Owner: IBoardPlayer); static;
    class function GetRoom(const Name: string): IRoom; static;
    class procedure DeleteRoom(const Name: string); static;
    class procedure GetRooms(out RoomsList: TStringList); static;
    class procedure UpdateState(const Room: IRoom); static;
    class property Current: IRoom read FCurrent write FCurrent;
    class property Player: IBoardPlayer read FPlayer write FPlayer;
  end;

implementation

const
  SERVER_ENDPOINT = 'http://localhost:3000';

{ TRoom }

constructor TRoom.Create;
begin
  FName := '';
  FStatus := '';
  FStarted := False;
  FOwner := TBoardPlayer.Create('', 0);
  FCurrentPlayerBlackPiece := -1;
  FPlayers := TPlayerList.Create();
  FEvents := TList<TRoomUpdateEvent>.Create();
  FNextPlayersBlackPiece := TPlayerList.Create();
  FState := TBoardState.Create();
end;

destructor TRoom.Destroy;
begin
  FreeAndNil(FEvents);
  FreeAndNil(FPlayers);
  FreeAndNil(FNextPlayersBlackPiece);
  inherited;
end;

procedure TRoom.Pull;
var
  NewRoom: IRoom;
  JSON: TJSONObject;
begin
  NewRoom := TRoomController.GetRoom(FName);

  if not Assigned(NewRoom) then
    raise EDeletedRoom.Create('The room was deleted');

  JSON := TJSONObject(TJSONObject.ParseJSONValue(NewRoom.ToJSON()));
  try
    Self.LoadFromJSON(JSON);
  finally
    if Assigned(JSON) then
      JSON.Free;
  end;
end;

procedure TRoom.Update;
var
  URL: string;
  HttpClient: IHttpClient;
begin
  URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, Self.Name]);

  HttpClient := NewIndyHttpClient();
  HttpClient.Post(URL, Self.ToJSON());

  NotifyAll();
end;

procedure TRoom.RegisterObserver(const Event: TRoomUpdateEvent);
begin
  FEvents.Add(Event);
end;

procedure TRoom.NotifyAll;
var
  Event: TRoomUpdateEvent;
begin
  for Event in FEvents do
    Event();
end;

function TRoom.ToJSON: string;
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create();
  try
    JSON.AddPair('name', FName);
    JSON.AddPair('owner', FOwner.ToJSON());
    JSON.AddPair('status', FStatus);
    JSON.AddPair('started', FStarted);
    JSON.AddPair('time', TJSONNumber.Create(FTime));
    JSON.AddPair('players', FPlayers.ToJSON());
    JSON.AddPair('nextPlayersBlackPiece', FNextPlayersBlackPiece.ToJSON());
    JSON.AddPair('currentPlayerBlackPiece', TJSONNumber.Create(FCurrentPlayerBlackPiece));
    JSON.AddPair('state', FState.ToJSON());

    Result := JSON.ToJSON();
  finally
    JSON.Free;
  end;
end;

procedure TRoom.LoadFromJSON(const JSON: TJSONObject);
begin
  FName := JSON.GetValue<string>('name');
  FStatus := JSON.GetValue<string>('status');
  FStarted := JSON.GetValue<Boolean>('started');
  FTime := JSON.GetValue<Integer>('time');
  FCurrentPlayerBlackPiece := JSON.GetValue<Integer>('currentPlayerBlackPiece');

  FOwner.LoadFromJSON(JSON.GetValue<TJSONObject>('owner'));
  FPlayers.LoadFromJSON(JSON.GetValue<TJSONArray>('players'));
  FNextPlayersBlackPiece.LoadFromJSON(JSON.GetValue<TJSONArray>('nextPlayersBlackPiece'));
  FState.LoadFromJSON(JSON.GetValue<TJSONObject>('state'));
end;

function TRoom.GetName: string;
begin
  Result := FName;
end;

procedure TRoom.SetName(const Value: string);
begin
  FName := Value;
end;

function TRoom.GetOwner: IBoardPlayer;
begin
  Result := FOwner;
end;

procedure TRoom.SetOwner(const Value: IBoardPlayer);
begin
  FOwner := Value;
end;

function TRoom.GetStatus: string;
begin
  Result := FStatus;
end;

procedure TRoom.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

function TRoom.GetStarted: Boolean;
begin
  Result := FStarted;
end;

procedure TRoom.SetStarted(const Value: Boolean);
begin
  FStarted := Value;
end;

function TRoom.GetTime: Integer;
begin
  Result := FTime;
end;

procedure TRoom.SetTime(const Value: Integer);
begin
  FTime := Value;
end;

function TRoom.GetPlayers: TPlayerList;
begin
  Result := FPlayers;
end;

procedure TRoom.SetPlayers(const Value: TPlayerList);
begin
  FPlayers := Value;
end;

function TRoom.GetCurrentPlayerBlackPiece: Integer;
begin
  Result := FCurrentPlayerBlackPiece;
end;

procedure TRoom.SetCurrentPlayerBlackPiece(const Value: Integer);
begin
  FCurrentPlayerBlackPiece := Value;
end;

function TRoom.GetNextPlayersBlackPiece: TPlayerList;
begin
  Result := FNextPlayersBlackPiece;
end;

procedure TRoom.SetNextPlayersBlackPiece(const Value: TPlayerList);
begin
  FNextPlayersBlackPiece := Value;
end;

function TRoom.GetState: IBoardState;
begin
  Result := FState;
end;

procedure TRoom.SetState(const Value: IBoardState);
begin
  FState := Value;
end;

{ TRoomController }

class constructor TRoomController.Create;
begin
  FHttpClient := NewIndyHttpClient();
end;

class destructor TRoomController.Destroy;
begin
  FHttpClient := nil;
end;

class procedure TRoomController.Enter(const Player: IBoardPlayer; const RoomName: string);
begin
  FPlayer := Player;

  FCurrent.State.CurrentPlayerColor := pcBlack;
  FCurrent.State.OpponentColor := pcWhite;

  FCurrent := GetRoom(RoomName);
  FCurrent.Players.Add(Player);
  FCurrent.NextPlayersBlackPiece.Add(Player);
  FCurrent.Update();
end;

class procedure TRoomController.CreateRoom(const Name: string; Time: Integer; Owner: IBoardPlayer);
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
