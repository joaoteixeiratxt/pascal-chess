unit BoardPlayer;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections;

type
  IBoardPlayer = interface
  ['{4CF51BD8-4692-4125-B15E-A0958BB9FD31}']
    function GetName: string;
    procedure SetName(const Value: string);
    function GetIconIndex: Integer;
    procedure SetIconIndex(const Value: Integer);
    function GetId: string;
    procedure SetId(const Value: string);
    property Id: string read GetId write SetId;
    property Name: string read GetName write SetName;
    property IconIndex: Integer read GetIconIndex write SetIconIndex;
    function ToJSON: TJSONObject;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TPlayerList = TList<IBoardPlayer>;

  TBoardPlayer = class(TInterfacedObject, IBoardPlayer)
  private
    FId: string;
    FName: string;
    FIconIndex: Integer;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetIconIndex: Integer;
    procedure SetIconIndex(const Value: Integer);
    function GetId: string;
    procedure SetId(const Value: string);
  public
    constructor Create(const Name: string = ''; const IconIndex: Integer = -1);
    property Id: string read GetId write SetId;
    property Name: string read GetName write SetName;
    property IconIndex: Integer read GetIconIndex write SetIconIndex;
    function ToJSON: TJSONObject;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

   TPlayerListHelper = class helper for TPlayerList
   public
    function AddNewPlayer(const Name: string; const IconIndex: Integer): IBoardPlayer;
    function FindById(const Id: string): IBoardPlayer;
    function FindByName(const Name: string): IBoardPlayer;
    function ToJSON: TJSONArray;
    procedure LoadFromJSON(const JSON: TJSONArray);
   end;

implementation

{ TBoardPlayer }

constructor TBoardPlayer.Create(const Name: string; const IconIndex: Integer);
begin
  FName := Name;
  FIconIndex := IconIndex;
  FId := GUIDToString(TGUID.NewGuid);
end;

function TBoardPlayer.GetId: string;
begin
  Result := FId;
end;

procedure TBoardPlayer.SetId(const Value: string);
begin
  FId := Value;
end;

function TBoardPlayer.GetName: string;
begin
  Result := FName;
end;

procedure TBoardPlayer.SetName(const Value: string);
begin
  FName := Value;
end;

function TBoardPlayer.GetIconIndex: Integer;
begin
  Result := FIconIndex;
end;

procedure TBoardPlayer.SetIconIndex(const Value: Integer);
begin
  FIconIndex := Value;
end;

function TBoardPlayer.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create();
  Result.AddPair('id', FId);
  Result.AddPair('name', FName);
  Result.AddPair('iconIndex', TJSONNumber.Create(FIconIndex));
end;

procedure TBoardPlayer.LoadFromJSON(const JSON: TJSONObject);
begin
  FId := JSON.GetValue<string>('id');
  FName := JSON.GetValue<string>('name');
  FIconIndex := JSON.GetValue<Integer>('iconIndex');
end;

{ TPlayerListHelper }

function TPlayerListHelper.AddNewPlayer(const Name: string; const IconIndex: Integer): IBoardPlayer;
begin
  Result := TBoardPlayer.Create(Name, IconIndex);
  Self.Add(Result);
end;

function TPlayerListHelper.FindById(const Id: string): IBoardPlayer;
var
  Player: IBoardPlayer;
begin
  Result := nil;

  for Player in Self do
    if (Player.Id = Id) then
      Exit(Player);
end;

function TPlayerListHelper.FindByName(const Name: string): IBoardPlayer;
var
  Player: IBoardPlayer;
begin
  Result := nil;

  for Player in Self do
    if (Player.Name = Name) then
      Exit(Player);
end;

function TPlayerListHelper.ToJSON: TJSONArray;
var
  Player: IBoardPlayer;
begin
  Result := TJSONArray.Create();

  for Player in Self do
    Result.Add(Player.ToJSON());
end;

procedure TPlayerListHelper.LoadFromJSON(const JSON: TJSONArray);
var
  I: Integer;
  Player: IBoardPlayer;
begin
  Self.Clear();

  for I := 0 to Pred(JSON.Count) do
  begin
    Player := TBoardPlayer.Create();
    Player.LoadFromJSON(TJSONObject(JSON.Items[I]));
    Self.Add(Player);
  end;
end;


end.
