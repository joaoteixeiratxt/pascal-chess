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
    function GetId: Integer;
    procedure SetId(const Value: Integer);
    property Id: Integer read GetId write SetId;
    property Name: string read GetName write SetName;
    property IconIndex: Integer read GetIconIndex write SetIconIndex;
    function ToJSON: TJSONObject;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TPlayerList = TList<IBoardPlayer>;

  TBoardPlayer = class(TInterfacedObject, IBoardPlayer)
  private
    FId: Integer;
    FName: string;
    FIconIndex: Integer;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetIconIndex: Integer;
    procedure SetIconIndex(const Value: Integer);
    function GetId: Integer;
    procedure SetId(const Value: Integer);
  public
    property Id: Integer read GetId write SetId;
    property Name: string read GetName write SetName;
    property IconIndex: Integer read GetIconIndex write SetIconIndex;
    function ToJSON: TJSONObject;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

   TPlayerListHelper = class helper for TPlayerList
   public
    function FindById(const Id: Integer): IBoardPlayer;
    function FindByName(const Name: string): IBoardPlayer;
    function ToJSON: TJSONArray;
    procedure LoadFromJSON(const JSON: TJSONArray);
   end;

implementation

{ TBoardPlayer }

function TBoardPlayer.GetId: Integer;
begin
  Result := FId;
end;

procedure TBoardPlayer.SetId(const Value: Integer);
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
  Result.AddPair('id', TJSONNumber.Create(FId));
  Result.AddPair('name', FName);
  Result.AddPair('iconIndex', TJSONNumber.Create(FIconIndex));
end;

procedure TBoardPlayer.LoadFromJSON(const JSON: TJSONObject);
begin
  FId := JSON.GetValue<Integer>('id');
  FName := JSON.GetValue<string>('name');
  FIconIndex := JSON.GetValue<Integer>('iconIndex');
end;

{ TPlayerListHelper }

function TPlayerListHelper.FindById(const Id: Integer): IBoardPlayer;
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

  for I := 0 to JSON.Count do
  begin
    Player := TBoardPlayer.Create();
    Player.LoadFromJSON(TJSONObject(JSON.Items[I]));
    Self.Add(Player);
  end;
end;


end.
