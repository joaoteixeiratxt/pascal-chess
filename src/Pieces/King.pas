unit King;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TKing = class(TPieceBase)
  public
    constructor Create;
  end;

implementation

{ TKing }

constructor TKing.Create;
begin
  FPieceType := ptKing;
end;

end.
