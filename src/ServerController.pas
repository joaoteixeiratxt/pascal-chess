unit ServerController;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections,
  HttpClient.IndyFacade, BoardState;

type
  TRoom = class
  private
    FName: string;
    FStatus: string;
    FStarted: Boolean;
    FJSONState: TJSONObject;
  public
    property Name: string read FName write FName;
    property Status: string read FStatus write FStatus;
    property Started: Boolean read FStarted write FStarted;
    property JSONState: TJSONObject read FJSONState write FJSONState;
    procedure GetPlayers(out PlayersList: TStringList);
    function GetCurrentPlayerBlackPiece: string;
    procedure GetNextPlayersBlackPiece(out PlayersList: TStringList);
    function ToJSON: string;
    procedure LoadFromJSON(const JSON: TJSONObject);
    constructor Create;
    destructor Destroy; override;
  end;

  TServerController = class
  private
    class var FHttpClient: IHttpClient;
  public
    class constructor Create;
    class destructor Destroy;
    class function CreateRoom(const Name: string): TRoom; static;
    class function GetRoom(const RoomName: string): TRoom; static;
  end;

implementation

const
  SERVER_ENDPOINT = 'localhost:3000';

{ TRoom }

constructor TRoom.Create;
begin
  FName := '';
  FStatus := '';
  FStarted := False;
  FJSONState := nil;
end;

destructor TRoom.Destroy;
begin
  if Assigned(FJSONState) then
    FreeAndNil(FJSONState);

  inherited;
end;

procedure TRoom.GetPlayers(out PlayersList: TStringList);
var
  I: Integer;
  Player: string;
  PlayerArray: TJSONArray;
begin
  if not Assigned(PlayersList) then
    Exit;

  PlayersList.Clear();
  PlayerArray := FJSONState.GetValue<TJSONArray>('players');

  for I := 0 to Pred(PlayerArray.Count) do
  begin
    Player := PlayerArray.Items[I].ToString();
    PlayersList.Add(Player);
  end;
end;

function TRoom.GetCurrentPlayerBlackPiece: string;
begin
  Result := FJSONState.GetValue<string>('currentPlayerBlackPiece');
end;

procedure TRoom.GetNextPlayersBlackPiece(out PlayersList: TStringList);
var
  I: Integer;
  Player: string;
  PlayerArray: TJSONArray;
begin
  if not Assigned(PlayersList) then
    Exit;

  PlayersList.Clear();
  PlayerArray := FJSONState.GetValue<TJSONArray>('nextPlayersBlackPiece');

  for I := 0 to Pred(PlayerArray.Count) do
  begin
    Player := PlayerArray.Items[I].ToString();
    PlayersList.Add(Player);
  end;
end;

function TRoom.ToJSON: string;
var
  JSON, CloneState: TJSONObject;
begin
  JSON := TJSONObject.Create();
  try
    CloneState := TJSONObject(TJSONObject.ParseJSONValue(FJSONState.ToJSON()));

    JSON.AddPair('roomName', FName);
    JSON.AddPair('status', FStatus);
    JSON.AddPair('started', FStarted);
    JSON.AddPair('state', CloneState);

    Result := JSON.ToJSON();
  finally
    JSON.Free;
  end;
end;

procedure TRoom.LoadFromJSON(const JSON: TJSONObject);
begin
  FName := JSON.GetValue<string>('roomName');
  FStatus := JSON.GetValue<string>('status');
  FStarted := JSON.GetValue<Boolean>('started');
  FJSONState := JSON.GetValue<TJSONObject>('state');
end;

{ TServerController }

class constructor TServerController.Create;
begin
  FHttpClient := NewIndyHttpClient();
end;

class destructor TServerController.Destroy;
begin
  FHttpClient := nil;
end;

class function TServerController.CreateRoom(const Name: string): TRoom;
var
  URL: string;
  DefaultState: IBoardState;
  JSON, JSONDefaultState: TJSONObject;
  Response: IHttpResponse;
begin
  Result := nil;

  JSON := TJSONObject.Create();
  try
    DefaultState := TBoardState.Create();
    DefaultState.Initialize();
    JSONDefaultState := DefaultState.ToJSON();

    JSONDefaultState.AddPair('players', TJSONArray.Create());
    JSONDefaultState.AddPair('nextPlayersBlackPiece', TJSONArray.Create());
    JSONDefaultState.AddPair('currentPlayerBlackPieceplayers', '');

    JSON.AddPair('roomName', Name);
    JSON.AddPair('status', 'on');
    JSON.AddPair('started', TJSONBool.Create(False));
    JSON.AddPair('state', JSONDefaultState);

    URL := Format('%s/rooms', [SERVER_ENDPOINT]);
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

class function TServerController.GetRoom(const RoomName: string): TRoom;
var
  URL: string;
  JSON: TJSONObject;
  Response: IHttpResponse;
begin
  Result := nil;

  URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, RoomName]);
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

end.
