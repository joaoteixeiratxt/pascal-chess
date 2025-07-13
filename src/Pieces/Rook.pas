unit Rook;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TRook = class(TPieceBase)
  public
    constructor Create;
  end;

implementation

{ TRook }

constructor TRook.Create;
begin
  FPieceType := ptRook;
end;

end.
