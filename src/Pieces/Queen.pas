unit Queen;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TQueen = class(TInterfacedObject, IPiece)
  private
    FPieceType: TPieceType;
    function GetPieceType: TPieceType;
  public
    constructor Create;
    property PieceType: TPieceType read GetPieceType;
  end;

implementation

{ TQueen }

constructor TQueen.Create;
begin
  FPieceType := ptQueen;
end;

function TQueen.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

end.
