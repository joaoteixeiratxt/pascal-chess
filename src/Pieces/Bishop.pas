unit Bishop;

interface

uses
  System.Classes, System.Types, BoardPiece, PieceBase;

type
  TBishop = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TBishopStrategy = class(TStrategyBase)
  public
    function GetLegalMoves: TLegalMoves; override;
  end;

implementation

{ TBishop }

constructor TBishop.Create;
begin
  inherited Create(Color);

  FPieceType := ptBishop;
  SetStrategy(TBishopStrategy.Create());
end;

{ TBishopStrategy }

function TBishopStrategy.GetLegalMoves: TLegalMoves;
var
  Point: TPoint;
  Piece: IPiece;
  Indice, X, Y: Integer;
begin
  inherited;

  X := FCoordinates.X + 1;
  Y := FCoordinates.Y + 1;
  while (X <= 7) and (Y <= 7) do
  begin
    Point := TPoint.Create(X, Y);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := Point;

    Inc(X);
    Inc(Y);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
      Break;
  end;

  X := FCoordinates.X - 1;
  Y := FCoordinates.Y + 1;
  while (X >= 0) and (Y <= 7) do
  begin
    Point := TPoint.Create(X, Y);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := Point;

    Dec(X);
    Inc(Y);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
      Break;
  end;

  X := FCoordinates.X + 1;
  Y := FCoordinates.Y - 1;
  while (X <= 7) and (Y >= 0) do
  begin
    Point := TPoint.Create(X, Y);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := Point;

    Inc(X);
    Dec(Y);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
      Break;
  end;

  X := FCoordinates.X - 1;
  Y := FCoordinates.Y - 1;
  while (X >= 0) and (Y >= 0) do
  begin
    Point := TPoint.Create(X, Y);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := Point;

    Dec(X);
    Dec(Y);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
      Break;
  end;
end;

end.
