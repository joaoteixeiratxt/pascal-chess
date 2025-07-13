unit Pawn;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TPawn = class(TPieceBase)
  public
    constructor Create;
  end;

implementation

{ TPawn }

constructor TPawn.Create;
begin
  FPieceType := ptPawn;
end;

end.
