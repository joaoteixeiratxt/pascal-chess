unit BoardState;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TPieceMatrix = array[0..7, 0..7] of IPiece;

  IBoardState = interface
  ['{984AB04C-D208-47A0-8A1C-71634201AB3B}']
    procedure Initialize;
    function GetPieceMatrix: TPieceMatrix;
    function GetPieceAt(const Row, Col: Integer): IPiece;
    procedure SetPieceAt(const Row, Col: Integer; const Value: IPiece);
    procedure MovePiece(const FromRow, FromCol, ToRow, ToCol: Integer);
  end;

  TBoardState = class(TInterfacedObject, IBoardState)
  private
    FBoardMatrix: TPieceMatrix;
  public
    procedure Initialize;
    function GetPieceMatrix: TPieceMatrix;
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
      FBoardMatrix[Row, Column] := nil;

  FBoardMatrix[7, 0] := TPieceFactory.New(ptRook);
  FBoardMatrix[7, 1] := TPieceFactory.New(ptKnight);
  FBoardMatrix[7, 2] := TPieceFactory.New(ptBishop);
  FBoardMatrix[7, 3] := TPieceFactory.New(ptQueen);
  FBoardMatrix[7, 4] := TPieceFactory.New(ptKing);
  FBoardMatrix[7, 5] := TPieceFactory.New(ptBishop);
  FBoardMatrix[7, 6] := TPieceFactory.New(ptKnight);
  FBoardMatrix[7, 7] := TPieceFactory.New(ptRook);

  for Column := 0 to 7 do
    FBoardMatrix[6, Column] := TPieceFactory.New(ptPawn);

  FBoardMatrix[0, 0] := TPieceFactory.New(ptRook);
  FBoardMatrix[0, 1] := TPieceFactory.New(ptKnight);
  FBoardMatrix[0, 2] := TPieceFactory.New(ptBishop);
  FBoardMatrix[0, 3] := TPieceFactory.New(ptQueen);
  FBoardMatrix[0, 4] := TPieceFactory.New(ptKing);
  FBoardMatrix[0, 5] := TPieceFactory.New(ptBishop);
  FBoardMatrix[0, 6] := TPieceFactory.New(ptKnight);
  FBoardMatrix[0, 7] := TPieceFactory.New(ptRook);

  for Column := 0 to 7 do
    FBoardMatrix[1, Column] := TPieceFactory.New(ptPawn);
end;

function TBoardState.GetPieceMatrix: TPieceMatrix;
begin
  Result := FBoardMatrix;
end;

function TBoardState.GetPieceAt(const Row, Col: Integer): IPiece;
begin
  Result := FBoardMatrix[Row, Col];
end;

procedure TBoardState.SetPieceAt(const Row, Col: Integer; const Value: IPiece);
begin
  FBoardMatrix[Row, Col] := Value;
end;

procedure TBoardState.MovePiece(const FromRow, FromCol, ToRow, ToCol: Integer);
begin
  FBoardMatrix[ToRow, ToCol] := FBoardMatrix[FromRow, FromCol];
  FBoardMatrix[FromRow, FromCol] := nil;
end;

end.

