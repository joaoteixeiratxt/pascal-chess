unit BoardPiece;

interface

type
  TPieceColor = (pcBlack, pcWhite);

  TPieceType = (
    ptNone,
    ptPawn,
    ptRook,
    ptKnight,
    ptBishop,
    ptQueen,
    ptKing
  );

  IPiece = interface
  ['{04894C92-B55A-499E-BEC9-828C029975CC}']
    function GetPieceType: TPieceType;
    property PieceType: TPieceType read GetPieceType;
  end;

  TPieceFactory = class
  public
    class function New(PieceType: TPieceType): IPiece; static;
  end;

implementation

uses
  Pawn, Rook, Knight, Bishop, Queen, King;

{ TPieceFactory }

class function TPieceFactory.New(PieceType: TPieceType): IPiece;
begin
  case PieceType of
    ptNone: Result := nil;
    ptPawn: Result := TPawn.Create();
    ptRook: Result := TRook.Create();
    ptKnight: Result := TKnight.Create();
    ptBishop: Result := TBishop.Create();
    ptQueen: Result := TQueen.Create();
    ptKing: Result := TKing.Create();
  end;
end;

end.
