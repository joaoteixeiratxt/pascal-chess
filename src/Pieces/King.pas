unit King;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TKing = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

implementation

{ TKing }

constructor TKing.Create;
begin
  inherited Create(Color);
  FPieceType := ptKing;
end;

end.
