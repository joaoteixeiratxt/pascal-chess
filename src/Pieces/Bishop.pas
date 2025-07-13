unit Bishop;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TBishop = class(TInterfacedObject, IPiece)
  private
    FPieceType: TPieceType;
    function GetPieceType: TPieceType;
  public
    constructor Create;
    property PieceType: TPieceType read GetPieceType;
  end;

implementation

{ TBishop }

constructor TBishop.Create;
begin
  FPieceType := ptBishop;
end;

function TBishop.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

end.
