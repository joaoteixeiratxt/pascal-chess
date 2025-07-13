unit Queen;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TQueen = class(TPieceBase)
  public
    constructor Create;
  end;

implementation

{ TQueen }

constructor TQueen.Create;
begin
  FPieceType := ptQueen;
end;

end.
