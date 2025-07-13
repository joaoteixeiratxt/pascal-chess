unit Bishop;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TBishop = class(TPieceBase)
  public
    constructor Create;
  end;

implementation

{ TBishop }

constructor TBishop.Create;
begin
  FPieceType := ptBishop;
end;

end.
