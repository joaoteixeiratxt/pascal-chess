unit Rook;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TRook = class(TInterfacedObject, IPiece)
  private
    FPieceType: TPieceType;
    function GetPieceType: TPieceType;
  public
    constructor Create;
    property PieceType: TPieceType read GetPieceType;
  end;

implementation

{ TRook }

constructor TRook.Create;
begin
  FPieceType := ptRook;
end;

function TRook.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

end.
