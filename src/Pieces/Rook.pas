unit Rook;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TRook = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

implementation

{ TRook }

constructor TRook.Create;
begin
  inherited Create(Color);
  FPieceType := ptRook;
end;

end.
