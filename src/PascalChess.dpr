program PascalChess;

uses
  Vcl.Forms,
  ChessBoardView in 'ChessBoardView.pas' {BoardView},
  BoardState in 'Board\BoardState.pas',
  BoardBuilder in 'Board\BoardBuilder.pas',
  BoardPiece in 'Board\BoardPiece.pas',
  Pawn in 'Pieces\Pawn.pas',
  Bishop in 'Pieces\Bishop.pas',
  Queen in 'Pieces\Queen.pas',
  King in 'Pieces\King.pas',
  Rook in 'Pieces\Rook.pas',
  Knight in 'Pieces\Knight.pas',
  ImageLoader in 'Images\ImageLoader.pas',
  ColorUtils in 'Utils\ColorUtils.pas',
  Board in 'Board\Board.pas',
  PieceBase in 'Pieces\PieceBase.pas',
  BoardTimer in 'Board\BoardTimer.pas',
  LobbyView in 'LobbyView.pas' {frmLobbyView},
  RoomController in 'RoomController.pas',
  HttpClient.IndyFacade in 'Utils\HttpClient.IndyFacade.pas',
  ServerController in 'ServerController.pas',
  BoardPlayer in 'Board\BoardPlayer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLobbyView, frmLobbyView);
  Application.Run;
end.
