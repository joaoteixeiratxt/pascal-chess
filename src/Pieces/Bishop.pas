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
  Indice, X, Y: Integer;
begin
  inherited;

  X := FCoordinates.X + 1;
  Y := FCoordinates.Y + 1;
  while (X <= 7) and (Y <= 7) do
  begin
    if Assigned(FMatrix[X, Y]) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);

    Inc(X);
    Inc(Y);
  end;

  X := FCoordinates.X - 1;
  Y := FCoordinates.Y + 1;
  while (X >= 0) and (Y <= 7) do
  begin
    if Assigned(FMatrix[X, Y]) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);

    Dec(X);
    Inc(Y);
  end;

  X := FCoordinates.X + 1;
  Y := FCoordinates.Y - 1;
  while (X <= 7) and (Y >= 0) do
  begin
    if Assigned(FMatrix[X, Y]) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);

    Inc(X);
    Dec(Y);
  end;

  X := FCoordinates.X - 1;
  Y := FCoordinates.Y - 1;
  while (X >= 0) and (Y >= 0) do
  begin
    if Assigned(FMatrix[X, Y]) then
      Break;

    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);

    Dec(X);
    Dec(Y);
  end;
end;

end.
