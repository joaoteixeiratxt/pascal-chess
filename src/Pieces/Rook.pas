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
  Indice, X, Y: Integer;
begin
  inherited;

  X := FCoordinates.X;
  Y := FCoordinates.Y + 1;
  while (Y <= 7) do
  begin
    if Assigned(FMatrix[X, Y]) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);
    Inc(Y);
  end;

  X := FCoordinates.X;
  Y := FCoordinates.Y - 1;
  while (Y >= 0) do
  begin
    if Assigned(FMatrix[X, Y]) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);
    Dec(Y);
  end;

  X := FCoordinates.X + 1;
  Y := FCoordinates.Y;
  while (X <= 7) do
  begin
    if Assigned(FMatrix[X, Y]) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);
    Inc(X);
  end;

  X := FCoordinates.X - 1;
  Y := FCoordinates.Y;
  while (X >= 0) do
  begin
    if Assigned(FMatrix[X, Y]) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);
    Dec(X);
  end;
end;


end.
