unit PC.Room;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections,
  PC.Indy.Facade, PC.State, PC.Player, PC.Piece;

type
  EDeletedRoom = class(Exception);

  TRoomUpdateEvent = procedure of object;

  IRoom = interface
  ['{BECBB98B-2043-441F-9743-37E9443B7333}']
    function GetName: string;
    procedure SetName(const Value: string);
    function GetOwner: IPlayer;
    procedure SetOwner(const Value: IPlayer);
    function GetStatus: string;
    procedure SetStatus(const Value: string);
    function GetStarted: Boolean;
    procedure SetStarted(const Value: Boolean);
    function GetTime: Integer;
    procedure SetTime(const Value: Integer);
    function GetState: IState;
    procedure SetState(const Value: IState);
    function GetPlayers: TPlayerList;
    procedure SetPlayers(const Value: TPlayerList);
    function GetCurrentPlayerBlackPiece: Integer;
    procedure SetCurrentPlayerBlackPiece(const Value: Integer);
    function GetNextPlayersBlackPiece: TPlayerList;
    procedure SetNextPlayersBlackPiece(const Value: TPlayerList);
    property Name: string read GetName write SetName;
    property Owner: IPlayer read GetOwner write SetOwner;
    property Status: string read GetStatus write SetStatus;
    property Started: Boolean read GetStarted write SetStarted;
    property Time: Integer read GetTime write SetTime;
    property Players: TPlayerList read GetPlayers write SetPlayers;
    property CurrentPlayerBlackPiece: Integer read GetCurrentPlayerBlackPiece write SetCurrentPlayerBlackPiece;
    property NextPlayersBlackPiece: TPlayerList read GetNextPlayersBlackPiece write SetNextPlayersBlackPiece;
    property State: IState read GetState write SetState;
    procedure Pull;
    procedure Push;
    procedure Update;
    procedure RegisterObserver(const Event: TRoomUpdateEvent);
    function ToJSON: string;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TRoom = class(TInterfacedObject, IRoom)
  private
    FName: string;
    FOwner: IPlayer;
    FStatus: string;
    FStarted: Boolean;
    FTime: Integer;
    FState: IState;
    FPlayers: TPlayerList;
    FEvents: TList<TRoomUpdateEvent>;
    FCurrentPlayerBlackPiece: Integer;
    FNextPlayersBlackPiece: TPlayerList;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetOwner: IPlayer;
    procedure SetOwner(const Value: IPlayer);
    function GetStatus: string;
    procedure SetStatus(const Value: string);
    function GetStarted: Boolean;
    procedure SetStarted(const Value: Boolean);
    function GetTime: Integer;
    procedure SetTime(const Value: Integer);
    function GetState: IState;
    procedure SetState(const Value: IState);
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
    procedure Push;
    procedure Update;
    procedure RegisterObserver(const Event: TRoomUpdateEvent);
    property Name: string read GetName write SetName;
    property Owner: IPlayer read GetOwner write SetOwner;
    property Status: string read GetStatus write SetStatus;
    property Started: Boolean read GetStarted write SetStarted;
    property Time: Integer read GetTime write SetTime;
    property Players: TPlayerList read GetPlayers write SetPlayers;
    property CurrentPlayerBlackPiece: Integer read GetCurrentPlayerBlackPiece write SetCurrentPlayerBlackPiece;
    property NextPlayersBlackPiece: TPlayerList read GetNextPlayersBlackPiece write SetNextPlayersBlackPiece;
    property State: IState read GetState write SetState;
    function ToJSON: string;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

implementation

uses
  PC.Room.Controller;

{ TRoom }

constructor TRoom.Create;
begin
  FName := '';
  FStatus := '';
  FStarted := False;
  FOwner := TPlayer.Create('', 0);
  FCurrentPlayerBlackPiece := -1;
  FPlayers := TPlayerList.Create();
  FEvents := TList<TRoomUpdateEvent>.Create();
  FNextPlayersBlackPiece := TPlayerList.Create();
  FState := TState.Create();
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

procedure TRoom.Push;
var
  URL: string;
  HttpClient: IHttpClient;
begin
  URL := Format('%s/rooms/%s', [SERVER_ENDPOINT, Self.Name]);

  HttpClient := NewIndyHttpClient();
  HttpClient.Post(URL, Self.ToJSON());
end;

procedure TRoom.Update;
begin
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

function TRoom.GetOwner: IPlayer;
begin
  Result := FOwner;
end;

procedure TRoom.SetOwner(const Value: IPlayer);
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

function TRoom.GetState: IState;
begin
  Result := FState;
end;

procedure TRoom.SetState(const Value: IState);
begin
  FState := Value;
end;

end.
