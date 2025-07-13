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
    function GetColor: TPieceColor;
    procedure SetColor(const Value: TPieceColor);
    function GetPieceType: TPieceType;
    function GetImageName: string;
    property Color: TPieceColor read GetColor;
    property PieceType: TPieceType read GetPieceType;
    property ImageName: string read GetImageName;
  end;

  TPieceBase = class(TInterfacedObject, IPiece)
  protected
    FColor: TPieceColor;
    FPieceType: TPieceType;
  private
    function GetColor: TPieceColor;
    procedure SetColor(const Value: TPieceColor);
    function GetPieceType: TPieceType;
    function GetImageName: string;
  public
    constructor Create(Color: TPieceColor); virtual;
    property Color: TPieceColor read GetColor;
    property PieceType: TPieceType read GetPieceType;
    property ImageName: string read GetImageName;
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
