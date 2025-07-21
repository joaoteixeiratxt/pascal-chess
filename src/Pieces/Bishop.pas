unit Bishop;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TBishop = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TBishopStrategy = class(TInterfacedObject, IStrategy)
  private
    FCoordinates: TPoint;
  public
    procedure SetCoordinates(const Value: TPoint);
    function GetLegalMoves: TLegalMoves;
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

procedure TBishopStrategy.SetCoordinates(const Value: TPoint);
begin
  FCoordinates := Value;
end;

function TBishopStrategy.GetLegalMoves: TLegalMoves;
var
  Indice, X, Y: Integer;
begin
  X := FCoordinates.X + 1;
  Y := FCoordinates.Y + 1;
  while (X <= 7) and (Y <= 7) do
  begin
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
    Indice := Length(Result);
    SetLength(Result, Indice + 1);
    Result[Indice] := TPoint.Create(X, Y);

    Dec(X);
    Dec(Y);
  end;
end;

end.
