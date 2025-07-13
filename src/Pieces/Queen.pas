unit Queen;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TQueen = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

implementation

{ TQueen }

constructor TQueen.Create;
begin
  inherited Create(Color);
  FPieceType := ptQueen;
end;

end.
