unit Queen;

interface

uses
  System.Classes, System.Types, PC.Piece, PieceBase;

type
  TQueen = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TQueenStrategy = class(TStrategyBase)
  public
    function GetLegalMoves: TLegalMoves; override;
  end;

implementation

uses
  Bishop, Rook;

{ TQueen }

constructor TQueen.Create;
begin
  inherited Create(Color);

  FPieceType := ptQueen;
  SetStrategy(TQueenStrategy.Create());
end;

{ TQueenStrategy }

function TQueenStrategy.GetLegalMoves: TLegalMoves;
var
  BishopStrategy, RookStrategy: IStrategy;
begin
  inherited;

  BishopStrategy := TBishopStrategy.Create();
  BishopStrategy.SetCoordinates(FCoordinates);

  RookStrategy := TRookStrategy.Create();
  RookStrategy.SetCoordinates(FCoordinates);

  Result := Result + BishopStrategy.GetLegalMoves();
  Result := Result + RookStrategy.GetLegalMoves();
end;

end.
