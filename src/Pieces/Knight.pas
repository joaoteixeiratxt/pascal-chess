unit Knight;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TKnight = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TKnightStrategy = class(TInterfacedObject, IStrategy)
  private
    FCoordinates: TPoint;
  public
    procedure SetCoordinates(const Value: TPoint);
    function GetLegalMoves: TLegalMoves;
  end;

implementation

{ TKnight }

constructor TKnight.Create;
begin
  inherited Create(Color);

  FPieceType := ptKnight;
  SetStrategy(TKnightStrategy.Create());
end;

{ TKnightStrategy }

procedure TKnightStrategy.SetCoordinates(const Value: TPoint);
begin
  FCoordinates := Value;
end;

function TKnightStrategy.GetLegalMoves: TLegalMoves;
const
  MOV_X: array[0..7] of Integer = ( 2, 1, -1, -2, -2, -1, 1, 2 );
  MOV_Y: array[0..7] of Integer = ( 1, 2, 2, 1, -1, -2, -2, -1 );
var
  I, Indice, X, Y: Integer;
begin
  for I := 0 to 7 do
  begin
    X := FCoordinates.X + MOV_X[I];
    Y := FCoordinates.Y + MOV_Y[I];

    if (X >= 0) and (X <= 7) and (Y >= 0) and (Y <= 7) then
    begin
      Indice := Length(Result);
      SetLength(Result, Indice + 1);

      Result[Indice] := TPoint.Create(X, Y);
    end;
  end;
end;

end.
