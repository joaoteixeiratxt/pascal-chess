unit BoardPiece;

interface

uses
  System.TypInfo, System.SysUtils, System.Types, System.JSON;

type
  TPieceColor = (pcBlack = 0, pcWhite = 1, pcNull = 2);

  TPieceType = (
    ptNone = 0,
    ptPawn = 1,
    ptRook = 2,
    ptKnight = 3,
    ptBishop = 4,
    ptQueen = 5,
    ptKing = 6
  );

  TLegalMoves = array of TPoint;

  TPieceColorHelper = record helper for TPieceColor
    function GetName: string;
  end;

  TPieceTypeHelper = record helper for TPieceType
    function GetName: string;
  end;

  IStrategy = interface
  ['{F8ABC721-210D-49B1-A889-5FB08D1C21D2}']
    procedure SetCoordinates(const Value: TPoint);
    function GetLegalMoves: TLegalMoves;
  end;

  IPiece = interface(IStrategy)
  ['{04894C92-B55A-499E-BEC9-828C029975CC}']
    function GetColor: TPieceColor;
    procedure SetColor(const Value: TPieceColor);
    function GetPieceType: TPieceType;
    function GetImageName: string;
    function GetCoordinates: TPoint;
    function GetHasMoved: Boolean;
    procedure SetHasMoved(const Value: Boolean);
    property Color: TPieceColor read GetColor;
    property PieceType: TPieceType read GetPieceType;
    property ImageName: string read GetImageName;
    property Coordinates: TPoint read GetCoordinates write SetCoordinates;
    property HasMoved: Boolean read GetHasMoved write SetHasMoved;
    procedure SetStrategy(const Strategy: IStrategy);
    function ToJSON: TJSONObject;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TPieceFactory = class
  public
    class function New(PieceType: TPieceType; Color: TPieceColor): IPiece; static;
  end;

implementation

uses
  Pawn, Rook, Knight, Bishop, Queen, King;

{ TPieceFactory }

class function TPieceFactory.New(PieceType: TPieceType; Color: TPieceColor): IPiece;
begin
  case PieceType of
    ptNone: Result := nil;
    ptPawn: Result := TPawn.Create(Color);
    ptRook: Result := TRook.Create(Color);
    ptKnight: Result := TKnight.Create(Color);
    ptBishop: Result := TBishop.Create(Color);
    ptQueen: Result := TQueen.Create(Color);
    ptKing: Result := TKing.Create(Color);
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
