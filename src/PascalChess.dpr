program PascalChess;

uses
  Vcl.Forms,
  Pawn in 'Pieces\Pawn.pas',
  Bishop in 'Pieces\Bishop.pas',
  Queen in 'Pieces\Queen.pas',
  King in 'Pieces\King.pas',
  Rook in 'Pieces\Rook.pas',
  Knight in 'Pieces\Knight.pas',
  PC.Color.Utils in 'Utils\PC.Color.Utils.pas',
  PieceBase in 'Pieces\PieceBase.pas',
  PC.Board in 'Board\PC.Board.pas',
  PC.BoardBuilder in 'Board\PC.BoardBuilder.pas',
  PC.Piece in 'Board\PC.Piece.pas',
  PC.Player in 'Board\PC.Player.pas',
  PC.State in 'Board\PC.State.pas',
  PC.Timer in 'Board\PC.Timer.pas',
  PC.Room.Controller in 'Controllers\PC.Room.Controller.pas',
  PC.Admin.Lobby.View in 'Views\PC.Admin.Lobby.View.pas' {frmAdminLobbyView},
  PC.CheckMate.View in 'Views\PC.CheckMate.View.pas' {frmCheckMateView},
  PC.Chessboard.View in 'Views\PC.Chessboard.View.pas' {BoardView},
  PC.Player.Lobby.View in 'Views\PC.Player.Lobby.View.pas' {frmPlayerLobbyView},
  PC.WaitingPlayers.View in 'Views\PC.WaitingPlayers.View.pas' {frmWaitingPlayersView},
  PC.WaitingRoom.View in 'Views\PC.WaitingRoom.View.pas' {frmWaitingRoomView},
  PC.Main.View in 'PC.Main.View.pas' {frmLobbyView},
  PC.Image.Loader in 'Images\PC.Image.Loader.pas',
  PC.Indy.Facade in 'Server\PC.Indy.Facade.pas',
  PC.Server.Service in 'Server\PC.Server.Service.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLobbyView, frmLobbyView);
  Application.Run;
end.
