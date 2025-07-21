unit King;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TKing = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TKingStrategy = class(TInterfacedObject, IStrategy)
  private
    FCoordinates: TPoint;
  public
    procedure SetCoordinates(const Value: TPoint);
    function GetLegalMoves: TLegalMoves;
  end;

implementation

{ TKing }

constructor TKing.Create;
begin
  inherited Create(Color);

  FPieceType := ptKing;
  SetStrategy(TKingStrategy.Create());
end;

{ TKingStrategy }

procedure TKingStrategy.SetCoordinates(const Value: TPoint);
begin
  FCoordinates := Value;
end;

function TKingStrategy.GetLegalMoves: TLegalMoves;
const
  MOV_X: array[0..7] of Integer = ( -1, 0, 1, -1, 1, -1, 0, 1 );
  MOV_Y: array[0..7] of Integer = ( -1, -1, -1, 0, 0, 1, 1, 1 );
var
  I, X, Y, Indice: Integer;
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
