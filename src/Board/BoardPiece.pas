unit BoardPiece;

interface

uses
  System.TypInfo, System.SysUtils, System.Types;

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
    property Color: TPieceColor read GetColor;
    property PieceType: TPieceType read GetPieceType;
    property ImageName: string read GetImageName;
    property Coordinates: TPoint read GetCoordinates write SetCoordinates;
    procedure SetStrategy(const Strategy: IStrategy);
  end;

  TPieceBase = class(TInterfacedObject, IPiece, IStrategy)
  protected
    FColor: TPieceColor;
    FPieceType: TPieceType;
    FCoordinates: TPoint;
    FStrategy: IStrategy;
  private
    function GetColor: TPieceColor;
    procedure SetColor(const Value: TPieceColor);
    function GetPieceType: TPieceType;
    function GetImageName: string;
    function GetCoordinates: TPoint;
    procedure SetCoordinates(const Value: TPoint);
  public
    constructor Create(Color: TPieceColor); virtual;
    property Color: TPieceColor read GetColor;
    property PieceType: TPieceType read GetPieceType;
    property ImageName: string read GetImageName;
    property Coordinates: TPoint read GetCoordinates write SetCoordinates;
    procedure SetStrategy(const Strategy: IStrategy);
    function GetLegalMoves: TLegalMoves;
  end;

  TPieceFactory = class
  public
    class function New(PieceType: TPieceType; Color: TPieceColor): IPiece; static;
  end;

implementation

uses
  Pawn, Rook, Knight, Bishop, Queen, King;

{ TPieceBase }

constructor TPieceBase.Create(Color: TPieceColor);
begin
  FColor := Color;
end;

function TPieceBase.GetColor: TPieceColor;
begin
  Result := FColor;
end;

procedure TPieceBase.SetColor(const Value: TPieceColor);
begin
  FColor := Value;
end;

function TPieceBase.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

function TPieceBase.GetImageName: string;
begin
  Result := FColor.GetName() + FPieceType.GetName();
end;

procedure TPieceBase.SetCoordinates(const Value: TPoint);
begin
  FCoordinates := Value;
end;

function TPieceBase.GetCoordinates: TPoint;
begin
  Result := FCoordinates;
end;

procedure TPieceBase.SetStrategy(const Strategy: IStrategy);
begin
  FStrategy := Strategy;
end;

function TPieceBase.GetLegalMoves: TLegalMoves;
begin
  FStrategy.SetCoordinates(FCoordinates);
  Result := FStrategy.GetLegalMoves();
end;

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
