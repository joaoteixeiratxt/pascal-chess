unit Knight;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TKnight = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

implementation

{ TKnight }

constructor TKnight.Create;
begin
  inherited Create(Color);
  FPieceType := ptKnight;
end;

end.
