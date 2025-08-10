unit RoomController;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections,
  HttpClient.IndyFacade, BoardState, BoardPlayer;

type
  IRoom = interface
  ['{BECBB98B-2043-441F-9743-37E9443B7333}']
    function GetName: string;
    procedure SetName(const Value: string);
    function GetOwner: string;
    procedure SetOwner(const Value: string);
    function GetStatus: string;
    procedure SetStatus(const Value: string);
    function GetStarted: Boolean;
    procedure SetStarted(const Value: Boolean);
    function GetHasChanged: Boolean;
    procedure SetHasChanged(const Value: Boolean);
    function GetState: IBoardState;
    procedure SetState(const Value: IBoardState);
    function GetPlayers: TList<IBoardPlayer>;
    procedure SetPlayers(const Value: TList<IBoardPlayer>);
    function GetCurrentPlayerBlackPiece: Integer;
    procedure SetCurrentPlayerBlackPiece(const Value: Integer);
    function GetNextPlayersBlackPiece: TList<IBoardPlayer>;
    procedure SetNextPlayersBlackPiece(const Value: TList<IBoardPlayer>);
    property Name: string read GetName write SetName;
    property Owner: string read GetOwner write SetOwner;
    property Status: string read GetStatus write SetStatus;
    property Started: Boolean read GetStarted write SetStarted;
    property HasChanged: Boolean read GetHasChanged write SetHasChanged;
    property Players: TList<IBoardPlayer> read GetPlayers write SetPlayers;
    property CurrentPlayerBlackPiece: Integer read GetCurrentPlayerBlackPiece write SetCurrentPlayerBlackPiece;
    property NextPlayersBlackPiece: TList<IBoardPlayer> read GetNextPlayersBlackPiece write SetNextPlayersBlackPiece;
    property State: IBoardState read GetState write SetState;
    procedure Update;
    function ToJSON: string;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TRoom = class(TInterfacedObject, IRoom)
  private
    FName: string;
    FOwner: string;
    FStatus: string;
    FStarted: Boolean;
    FHasChanged: Boolean;
    FState: IBoardState;
    FPlayers: TPlayerList;
    FCurrentPlayerBlackPiece: Integer;
    FNextPlayersBlackPiece: TPlayerList;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetOwner: string;
    procedure SetOwner(const Value: string);
    function GetStatus: string;
    procedure SetStatus(const Value: string);
    function GetStarted: Boolean;
    procedure SetStarted(const Value: Boolean);
    function GetHasChanged: Boolean;
    procedure SetHasChanged(const Value: Boolean);
    function GetState: IBoardState;
    procedure SetState(const Value: IBoardState);
    function GetPlayers: TPlayerList;
    procedure SetPlayers(const Value: TPlayerList);
    function GetNextPlayersBlackPiece: TPlayerList;
    procedure SetNextPlayersBlackPiece(const Value: TPlayerList);
    function GetCurrentPlayerBlackPiece: Integer;
    procedure SetCurrentPlayerBlackPiece(const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update;
    property Name: string read GetName write SetName;
    property Owner: string read GetOwner write SetOwner;
    property Status: string read GetStatus write SetStatus;
    property Started: Boolean read GetStarted write SetStarted;
    property HasChanged: Boolean read GetHasChanged write SetHasChanged;
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
  public
    class constructor Create;
    class destructor Destroy;
    class function CreateRoom(const Name, Owner: string): IRoom; static;
    class function GetRoom(const Name: string): IRoom; static;
    class procedure DeleteRoom(const Name: string); static;
    class procedure GetRooms(out RoomsList: TStringList); static;
    class procedure UpdateRoom(const Room: IRoom);
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
  FCurrentPlayerBlackPiece := -1;
  FPlayers := TPlayerList.Create();
  FNextPlayersBlackPiece := TPlayerList.Create();
  FState := TBoardState.Create();
end;

destructor TRoom.Destroy;
begin
  FreeAndNil(FPlayers);
  FreeAndNil(FNextPlayersBlackPiece);
  inherited;
end;

procedure TRoom.Update;
begin
  TRoomController.UpdateRoom(Self);
end;

function TRoom.ToJSON: string;
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create();
  try
    JSON.AddPair('name', FName);
    JSON.AddPair('status', FStatus);
    JSON.AddPair('started', FStarted);
    JSON.AddPair('hasChanged', FHasChanged);
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
var
  JSONRoom: TJSONObject;
  JSONPlayers: TJSONArray;
begin
  FName := JSON.GetValue<string>('name');
  FStatus := JSON.GetValue<string>('status');
  FStarted := JSON.GetValue<Boolean>('started');
  FHasChanged := JSON.GetValue<Boolean>('hasChanged');
  FCurrentPlayerBlackPiece := JSON.GetValue<Integer>('currentPlayerBlackPiece');

  JSONPlayers := JSON.GetValue<TJSONArray>('players');
  FPlayers.LoadFromJSON(JSONPlayers);

  JSONPlayers := JSON.GetValue<TJSONArray>('nextPlayersBlackPiece');
  FNextPlayersBlackPiece.LoadFromJSON(JSONPlayers);

  JSONRoom := JSON.GetValue<TJSONObject>('state');
  FState.LoadFromJSON(JSONRoom);
end;

function TRoom.GetName: string;
begin
  Result := FName;
end;

procedure TRoom.SetName(const Value: string);
begin
  FName := Value;
end;

function TRoom.GetOwner: string;
begin
  Result := FOwner;
end;

procedure TRoom.SetOwner(const Value: string);
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

function TRoom.GetHasChanged: Boolean;
begin
  Result := FHasChanged;
end;

procedure TRoom.SetHasChanged(const Value: Boolean);
begin
  FHasChanged := Value;
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

{ TServerController }

class constructor TRoomController.Create;
begin
  FHttpClient := NewIndyHttpClient();
end;

class destructor TRoomController.Destroy;
begin
  FHttpClient := nil;
end;

class function TRoomController.CreateRoom(const Name, Owner: string): IRoom;
var
  URL: string;
  Player: IBoardPlayer;
  Response: IHttpResponse;
  DefaultState: IBoardState;
  DefaultPlayerList: TPlayerList;
  JSON, JSONDefaultState: TJSONObject;
begin
  Result := nil;

  JSON := TJSONObject.Create();
  try
    DefaultState := TBoardState.Create();
    DefaultState.Initialize();
    JSONDefaultState := DefaultState.ToJSON();

    JSON.AddPair('name', Name);
    JSON.AddPair('owner', Owner);
    JSON.AddPair('status', 'on');
    JSON.AddPair('started', TJSONBool.Create(False));
    JSON.AddPair('hasChanged', TJSONBool.Create(True));
    JSON.AddPair('currentPlayerBlackPiece', TJSONNumber.Create(-1));

    DefaultPlayerList := TPlayerList.Create();
    try
      Player := TBoardPlayer.Create();
      Player.Id := 1;
      Player.Name := Owner;
      Player.IconIndex := 0;

      DefaultPlayerList.Add(Player);
      JSON.AddPair('players', DefaultPlayerList.ToJSON);

      DefaultPlayerList.Clear();
      JSON.AddPair('nextPlayersBlackPiece', DefaultPlayerList.ToJSON);
    finally
      DefaultPlayerList.Free;
    end;

    JSON.AddPair('state', JSONDefaultState);

    URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, Name]);
    Response := FHttpClient.Post(URL, JSON.ToJSON());

    if (Response.StatusCode = 201) then
    begin
      Result := TRoom.Create();
      Result.LoadFromJSON(JSON);
    end;
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

class procedure TRoomController.UpdateRoom(const Room: IRoom);
var
  URL: string;
begin
  if not Assigned(Room) then
    Exit;

  Room.HasChanged := True;
  try
    URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, Room.Name]);
    FHttpClient.Post(URL, Room.ToJSON());
  finally
    Room.HasChanged := False;
  end;
end;

end.
