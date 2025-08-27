unit PieceBase;

interface

uses
  System.Classes, System.Types, System.JSON, PC.Piece,
  PC.State, RoomController;

type
  TPieceBase = class(TInterfacedObject, IPiece, IStrategy)
  protected
    FState: IBoardState;
    FColor: TPieceColor;
    FPieceType: TPieceType;
    FCoordinates: TPoint;
    FHasMoved: Boolean;
    FStrategy: IStrategy;
  private
    function GetColor: TPieceColor;
    procedure SetColor(const Value: TPieceColor);
    function GetPieceType: TPieceType;
    function GetImageName: string;
    function GetCoordinates: TPoint;
    procedure SetCoordinates(const Value: TPoint);
    function GetHasMoved: Boolean;
    procedure SetHasMoved(const Value: Boolean);
  public
    constructor Create(Color: TPieceColor); virtual;
    property Color: TPieceColor read GetColor;
    property PieceType: TPieceType read GetPieceType;
    property ImageName: string read GetImageName;
    property Coordinates: TPoint read GetCoordinates write SetCoordinates;
    property HasMoved: Boolean read GetHasMoved write SetHasMoved;
    procedure SetStrategy(const Strategy: IStrategy);
    function GetPseudoLegalMoves: TLegalMoves;
    function GetLegalMoves: TLegalMoves;
    function ToJSON: TJSONObject;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TStrategyBase = class(TInterfacedObject, IStrategy)
  protected
    FCoordinates: TPoint;
    FState: IBoardState;
    FMatrix: TPieceMatrix;
    FCurrentPlayerColor: TPieceColor;
  public
    procedure SetCoordinates(const Value: TPoint);
    function GetLegalMoves: TLegalMoves; virtual;
  end;

implementation

{ TPieceBase }

constructor TPieceBase.Create(Color: TPieceColor);
begin
  FColor := Color;
end;

function TPieceBase.GetColor: TPieceColor;
begin
  Result := FColor;
end;

procedure TPieceBase.SetColor(const Value: TPieceColor);
begin
  FColor := Value;
end;

function TPieceBase.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

function TPieceBase.GetImageName: string;
begin
  Result := FColor.GetName() + FPieceType.GetName();
end;

procedure TPieceBase.SetCoordinates(const Value: TPoint);
begin
  FCoordinates := Value;
end;

function TPieceBase.GetCoordinates: TPoint;
begin
  Result := FCoordinates;
end;

procedure TPieceBase.SetHasMoved(const Value: Boolean);
begin
  FHasMoved := Value;
end;

function TPieceBase.GetHasMoved: Boolean;
begin
  Result := FHasMoved;
end;

procedure TPieceBase.SetStrategy(const Strategy: IStrategy);
begin
  FStrategy := Strategy;
end;

function TPieceBase.GetPseudoLegalMoves: TLegalMoves;
begin
  FStrategy.SetCoordinates(FCoordinates);
  Result := FStrategy.GetLegalMoves();
end;

function TPieceBase.GetLegalMoves: TLegalMoves;
var
  Move: TPoint;
  Indice: Integer;
  State: IBoardState;
  Moves: TLegalMoves;
begin
  State := TRoomController.Current.State;
  Moves := GetPseudoLegalMoves();

  Indice := 0;
  for Move in Moves do
  begin
    if not State.MoveLeavesKingInCheck(FCoordinates, Move, FColor) then
    begin
      SetLength(Result, Indice + 1);
      Result[Indice] := Move;
      Inc(Indice);
    end;
  end;
end;

function TPieceBase.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create();
  Result.AddPair('type', TJSONNumber.Create(Integer(Self.PieceType)));
  Result.AddPair('color', TJSONNumber.Create(Integer(Self.Color)));
  Result.AddPair('hasMoved', TJSONBool.Create(Self.HasMoved));

  if TRoomController.Current.State.CurrentPlayerColor = pcBlack then
  begin
    Result.AddPair('x', TJSONNumber.Create(7 - Self.Coordinates.X));
    Result.AddPair('y', TJSONNumber.Create(7 - Self.Coordinates.Y));
  end
  else
  begin
    Result.AddPair('x', TJSONNumber.Create(Self.Coordinates.X));
    Result.AddPair('y', TJSONNumber.Create(Self.Coordinates.Y));
  end;
end;

procedure TPieceBase.LoadFromJSON(const JSON: TJSONObject);
begin
  FPieceType := TPieceType(JSON.GetValue<Integer>('type'));
  FColor := TPieceColor(JSON.GetValue<Integer>('color'));
  FHasMoved := JSON.GetValue<Boolean>('hasMoved');
  FCoordinates.X := JSON.GetValue<Integer>('x');
  FCoordinates.Y := JSON.GetValue<Integer>('y');

  if TRoomController.Current.State.CurrentPlayerColor = pcBlack then
  begin
    FCoordinates.X := 7 - FCoordinates.X;
    FCoordinates.Y := 7 - FCoordinates.Y;
  end;
end;

{ TStrategyBase }

procedure TStrategyBase.SetCoordinates(const Value: TPoint);
begin
  FCoordinates := Value;
end;

function TStrategyBase.GetLegalMoves: TLegalMoves;
begin
  FState := TRoomController.Current.State;
  FMatrix := FState.GetPieceMatrix();
  FCurrentPlayerColor := FState.CurrentPlayerColor;
end;

end.
