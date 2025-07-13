unit King;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TKing = class(TInterfacedObject, IPiece)
  private
    FPieceType: TPieceType;
    function GetPieceType: TPieceType;
  public
    constructor Create;
    property PieceType: TPieceType read GetPieceType;
  end;

implementation

{ TKing }

constructor TKing.Create;
begin
  FPieceType := ptKing;
end;

function TKing.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

end.
