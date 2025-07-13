unit Knight;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TKnight = class(TPieceBase)
  public
    constructor Create;
  end;

implementation

{ TKnight }

constructor TKnight.Create;
begin
  FPieceType := ptKnight;
end;

end.
