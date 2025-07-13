unit Bishop;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TBishop = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

implementation

{ TBishop }

constructor TBishop.Create;
begin
  inherited Create(Color);
  FPieceType := ptBishop;
end;

end.
