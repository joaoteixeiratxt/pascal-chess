program PascalChess;

uses
  Vcl.Forms,
  Pawn in 'Pieces\Pawn.pas',
  Bishop in 'Pieces\Bishop.pas',
  Queen in 'Pieces\Queen.pas',
  King in 'Pieces\King.pas',
  Rook in 'Pieces\Rook.pas',
  Knight in 'Pieces\Knight.pas',
  ImageLoader in 'Images\ImageLoader.pas',
  ColorUtils in 'Utils\ColorUtils.pas',
  PieceBase in 'Pieces\PieceBase.pas',
  HttpClient.IndyFacade in 'Utils\HttpClient.IndyFacade.pas',
  PC.Server.Service in 'Controllers\PC.Server.Service.pas',
  PC.Admin.Lobby.View in 'PC.Admin.Lobby.View.pas' {frmAdminLobbyView},
  PC.CheckMate.View in 'PC.CheckMate.View.pas' {frmCheckMateView},
  PC.Chessboard.View in 'PC.Chessboard.View.pas' {BoardView},
  PC.Lobby.View in 'PC.Lobby.View.pas' {frmLobbyView},
  PC.Player.Lobby.View in 'PC.Player.Lobby.View.pas' {frmPlayerLobbyView},
  PC.WaitingPlayers.View in 'PC.WaitingPlayers.View.pas' {frmWaitingPlayersView},
  PC.WaitingRoom.View in 'PC.WaitingRoom.View.pas' {frmWaitingRoomView},
  PC.Board in 'Board\PC.Board.pas',
  PC.BoardBuilder in 'Board\PC.BoardBuilder.pas',
  PC.Piece in 'Board\PC.Piece.pas',
  PC.Player in 'Board\PC.Player.pas',
  PC.State in 'Board\PC.State.pas',
  PC.Timer in 'Board\PC.Timer.pas',
  PC.Room.Controller in 'Controllers\PC.Room.Controller.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLobbyView, frmLobbyView);
  Application.Run;
end.
