unit Pawn;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TPawn = class(TInterfacedObject, IPiece)
  private
    FPieceType: TPieceType;
    function GetPieceType: TPieceType;
  public
    constructor Create;
    property PieceType: TPieceType read GetPieceType;
  end;

implementation

{ TPawn }

constructor TPawn.Create;
begin
  FPieceType := ptPawn;
end;

function TPawn.GetPieceType: TPieceType;
begin
  Result := FPieceType;
end;

end.
