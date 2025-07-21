unit Queen;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TQueen = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TQueenStrategy = class(TInterfacedObject, IStrategy)
  private
    FCoordinates: TPoint;
  public
    procedure SetCoordinates(const Value: TPoint);
    function GetLegalMoves: TLegalMoves;
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

procedure TQueenStrategy.SetCoordinates(const Value: TPoint);
begin
  FCoordinates := Value;
end;

function TQueenStrategy.GetLegalMoves: TLegalMoves;
var
  BishopStrategy, RookStrategy: IStrategy;
begin
  BishopStrategy := TBishopStrategy.Create();
  BishopStrategy.SetCoordinates(FCoordinates);

  RookStrategy := TRookStrategy.Create();
  RookStrategy.SetCoordinates(FCoordinates);

  Result := Result + BishopStrategy.GetLegalMoves();
  Result := Result + RookStrategy.GetLegalMoves();
end;

end.
