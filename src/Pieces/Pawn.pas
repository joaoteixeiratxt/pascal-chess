unit Pawn;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TPawn = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

implementation

{ TPawn }

constructor TPawn.Create;
begin
  inherited Create(Color);
  FPieceType := ptPawn;
end;

end.
