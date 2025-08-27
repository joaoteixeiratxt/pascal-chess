unit PC.Player;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Generics.Collections;

type
  IPlayer = interface
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

  TPlayerList = TList<IPlayer>;

  TPlayer = class(TInterfacedObject, IPlayer)
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
    function AddNewPlayer(const Name: string; const IconIndex: Integer): IPlayer;
    function FindById(const Id: string): IPlayer;
    function FindByName(const Name: string): IPlayer;
    procedure DeleteById(const Id: string);
    function ToJSON: TJSONArray;
    procedure LoadFromJSON(const JSON: TJSONArray);
   end;

implementation

{ TPlayer }

constructor TPlayer.Create(const Name: string; const IconIndex: Integer);
begin
  FName := Name;
  FIconIndex := IconIndex;
  FId := GUIDToString(TGUID.NewGuid);
end;

function TPlayer.GetId: string;
begin
  Result := FId;
end;

procedure TPlayer.SetId(const Value: string);
begin
  FId := Value;
end;

function TPlayer.GetName: string;
begin
  Result := FName;
end;

procedure TPlayer.SetName(const Value: string);
begin
  FName := Value;
end;

function TPlayer.GetIconIndex: Integer;
begin
  Result := FIconIndex;
end;

procedure TPlayer.SetIconIndex(const Value: Integer);
begin
  FIconIndex := Value;
end;

function TPlayer.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create();
  Result.AddPair('id', FId);
  Result.AddPair('name', FName);
  Result.AddPair('iconIndex', TJSONNumber.Create(FIconIndex));
end;

procedure TPlayer.LoadFromJSON(const JSON: TJSONObject);
begin
  FId := JSON.GetValue<string>('id');
  FName := JSON.GetValue<string>('name');
  FIconIndex := JSON.GetValue<Integer>('iconIndex');
end;

{ TPlayerListHelper }

function TPlayerListHelper.AddNewPlayer(const Name: string; const IconIndex: Integer): IPlayer;
begin
  Result := TPlayer.Create(Name, IconIndex);
  Self.Add(Result);
end;

function TPlayerListHelper.FindById(const Id: string): IPlayer;
var
  Player: IPlayer;
begin
  Result := nil;

  for Player in Self do
    if (Player.Id = Id) then
      Exit(Player);
end;

function TPlayerListHelper.FindByName(const Name: string): IPlayer;
var
  Player: IPlayer;
begin
  Result := nil;

  for Player in Self do
    if (Player.Name = Name) then
      Exit(Player);
end;

procedure TPlayerListHelper.DeleteById(const Id: string);
var
  I: Integer;
  Player: IPlayer;
begin
  for I := 0 to Pred(Self.Count) do
  begin
    Player := Self[I];

    if (Player.Id = Id) then
    begin
      Self.Delete(I);
      Exit;
    end;
  end;
end;

function TPlayerListHelper.ToJSON: TJSONArray;
var
  Player: IPlayer;
begin
  Result := TJSONArray.Create();

  for Player in Self do
    Result.Add(Player.ToJSON());
end;

procedure TPlayerListHelper.LoadFromJSON(const JSON: TJSONArray);
var
  I: Integer;
  Player: IPlayer;
begin
  Self.Clear();

  for I := 0 to Pred(JSON.Count) do
  begin
    Player := TPlayer.Create();
    Player.LoadFromJSON(TJSONObject(JSON.Items[I]));
    Self.Add(Player);
  end;
end;


end.
