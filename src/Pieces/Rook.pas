unit Rook;

interface

uses
  System.Classes, System.Types, BoardPiece, BoardState, PieceBase;

type
  TRook = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TRookStrategy = class(TStrategyBase)
  public
    function GetLegalMoves: TLegalMoves; override;
  end;

implementation

{ TRook }

constructor TRook.Create;
begin
  inherited Create(Color);

  FPieceType := ptRook;
  SetStrategy(TRookStrategy.Create());
end;

{ TRookStrategy }

function TRookStrategy.GetLegalMoves: TLegalMoves;
var
  Point: TPoint;
  Piece: IPiece;
  Indice, X, Y: Integer;
begin
  inherited;

  X := FCoordinates.X;
  Y := FCoordinates.Y + 1;
  while (Y <= 7) do
  begin
    Point := TPoint.Create(X, Y);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := Point;
    Inc(Y);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
      Break;
  end;

  X := FCoordinates.X;
  Y := FCoordinates.Y - 1;
  while (Y >= 0) do
  begin
    Point := TPoint.Create(X, Y);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := Point;
    Dec(Y);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
      Break;
  end;

  X := FCoordinates.X + 1;
  Y := FCoordinates.Y;
  while (X <= 7) do
  begin
    Point := TPoint.Create(X, Y);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := Point;
    Inc(X);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
      Break;
  end;

  X := FCoordinates.X - 1;
  Y := FCoordinates.Y;
  while (X >= 0) do
  begin
    Point := TPoint.Create(X, Y);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := Point;
    Dec(X);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
      Break;
  end;
end;


end.
