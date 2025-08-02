unit Knight;

interface

uses
  System.Classes, System.Types, BoardPiece, BoardState, PieceBase;

type
  TKnight = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TKnightStrategy = class(TStrategyBase)
  public
    function GetLegalMoves: TLegalMoves; override;
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

function TKnightStrategy.GetLegalMoves: TLegalMoves;
const
  MOV_X: array[0..7] of Integer = ( 2, 1, -1, -2, -2, -1, 1, 2 );
  MOV_Y: array[0..7] of Integer = ( 1, 2, 2, 1, -1, -2, -2, -1 );
var
  Point: TPoint;
  Piece: IPiece;
  I, Indice, X, Y: Integer;
begin
  inherited;

  for I := 0 to 7 do
  begin
    X := FCoordinates.X + MOV_X[I];
    Y := FCoordinates.Y + MOV_Y[I];

    if (X >= 0) and (X <= 7) and (Y >= 0) and (Y <= 7) then
    begin
      Point := TPoint.Create(X, Y);
      Piece := FState.GetPieceAt(Point);

      if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
        Continue;

      Indice := Length(Result);
      SetLength(Result, Indice + 1);

      Result[Indice] := Point;
    end;
  end;
end;

end.
