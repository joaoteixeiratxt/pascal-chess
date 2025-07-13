unit Knight;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TKnight = class(TInterfacedObject, IPiece)
  private
    FPieceType: TPieceType;
    function GetPieceType: TPieceType;
  public
    constructor Create;
    property PieceType: TPieceType read GetPieceType;
  end;

implementation

{ TKnight }

constructor TKnight.Create;
begin
  FPieceType := ptKnight;
end;

function TKnight.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

end.
