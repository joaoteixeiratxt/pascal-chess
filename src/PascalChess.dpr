program PascalChess;

uses
  Vcl.Forms,
  Board in 'Board.pas' {BoardView},
  BoardState in 'Board\BoardState.pas',
  BoardBuilder in 'Board\BoardBuilder.pas',
  BoardPiece in 'Board\BoardPiece.pas',
  Pawn in 'Pieces\Pawn.pas',
  Bishop in 'Pieces\Bishop.pas',
  Queen in 'Pieces\Queen.pas',
  King in 'Pieces\King.pas',
  Rook in 'Pieces\Rook.pas',
  Knight in 'Pieces\Knight.pas',
  ImageLoader in 'Images\ImageLoader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBoardView, BoardView);
  Application.Run;
end.
