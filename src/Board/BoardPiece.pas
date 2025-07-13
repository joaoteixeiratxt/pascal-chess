unit BoardPiece;

interface

uses
  System.TypInfo, System.SysUtils;

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

  TPieceColorHelper = record helper for TPieceColor
    function GetName: string;
  end;

  TPieceTypeHelper = record helper for TPieceType
    function GetName: string;
  end;

  IPiece = interface
  ['{04894C92-B55A-499E-BEC9-828C029975CC}']
    function GetPieceType: TPieceType;
    property PieceType: TPieceType read GetPieceType;
  end;

  TPieceBase = class(TInterfacedObject, IPiece)
  protected
    FPieceType: TPieceType;
  private
    function GetPieceType: TPieceType;
  public
    property PieceType: TPieceType read GetPieceType;
  end;

  TPieceFactory = class
  public
    class function New(PieceType: TPieceType): IPiece; static;
  end;

implementation

uses
  Pawn, Rook, Knight, Bishop, Queen, King;

{ TPieceBase }

function TPieceBase.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

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

{ TPieceColorHelper }

function TPieceColorHelper.GetName: string;
begin
  Result := GetEnumName(TypeInfo(TPieceColor), Ord(Self));
  Result := Result.Split(['pc'])[1];
end;

{ TPieceTypeHelper }

function TPieceTypeHelper.GetName: string;
begin
  Result := GetEnumName(TypeInfo(TPieceType), Ord(Self));
  Result := Result.Split(['pt'])[1];
end;

end.
