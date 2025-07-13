unit BoardState;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  IBoardState = interface
  ['{984AB04C-D208-47A0-8A1C-71634201AB3B}']
    procedure Initialize;
    function GetPieceAt(const Row, Col: Integer): IPiece;
    procedure SetPieceAt(const Row, Col: Integer; const Value: IPiece);
    procedure MovePiece(const FromRow, FromCol, ToRow, ToCol: Integer);
  end;

  TBoardState = class(TInterfacedObject, IBoardState)
  private
    FState: array[0..7, 0..7] of IPiece;
  public
    procedure Initialize;
    function GetPieceAt(const Row, Col: Integer): IPiece;
    procedure SetPieceAt(const Row, Col: Integer; const Value: IPiece);
    procedure MovePiece(const FromRow, FromCol, ToRow, ToCol: Integer);
  end;

implementation

{ TBoardState }

procedure TBoardState.Initialize;
var
  Row, Column: Integer;
begin
  for Row := 0 to 7 do
    for Column := 0 to 7 do
      FState[Row, Column] := nil;

  FState[7, 0] := TPieceFactory.New(ptRook);
  FState[7, 1] := TPieceFactory.New(ptKnight);
  FState[7, 2] := TPieceFactory.New(ptBishop);
  FState[7, 3] := TPieceFactory.New(ptQueen);
  FState[7, 4] := TPieceFactory.New(ptKing);
  FState[7, 5] := TPieceFactory.New(ptBishop);
  FState[7, 6] := TPieceFactory.New(ptKnight);
  FState[7, 7] := TPieceFactory.New(ptRook);

  for Column := 0 to 7 do
    FState[6, Column] := TPieceFactory.New(ptPawn);

  FState[0, 0] := TPieceFactory.New(ptRook);
  FState[0, 1] := TPieceFactory.New(ptKnight);
  FState[0, 2] := TPieceFactory.New(ptBishop);
  FState[0, 3] := TPieceFactory.New(ptQueen);
  FState[0, 4] := TPieceFactory.New(ptKing);
  FState[0, 5] := TPieceFactory.New(ptBishop);
  FState[0, 6] := TPieceFactory.New(ptKnight);
  FState[0, 7] := TPieceFactory.New(ptRook);

  for Column := 0 to 7 do
    FState[1, Column] := TPieceFactory.New(ptPawn);
end;

function TBoardState.GetPieceAt(const Row, Col: Integer): IPiece;
begin
  Result := FState[Row, Col];
end;

procedure TBoardState.SetPieceAt(const Row, Col: Integer; const Value: IPiece);
begin
  FState[Row, Col] := Value;
end;

procedure TBoardState.MovePiece(const FromRow, FromCol, ToRow, ToCol: Integer);
begin
  FState[ToRow, ToCol] := FState[FromRow, FromCol];
  FState[FromRow, FromCol] := nil;
end;

end.

