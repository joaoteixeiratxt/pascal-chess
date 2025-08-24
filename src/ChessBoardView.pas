unit ChessBoardView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Board, BoardState, BoardBuilder,
  Vcl.StdCtrls, System.Threading, BoardPiece, System.JSON, BoardTimer, RoomController, ServerController, ImageLoader,
  BoardPlayer, CheckMateView;

type
  TBoardView = class(TForm)
    pnlOpponent: TPanel;
    pnlBoard: TPanel;
    pnlPlayer: TPanel;
    pnlOpponentTime: TPanel;
    pnlOpponentName: TPanel;
    pnlOpponentAvatar: TPanel;
    pnlPlayerName: TPanel;
    pnlPlayerAvatar: TPanel;
    pnlPlayerTime: TPanel;
    pnlControls: TPanel;
    imgOpponentAvatar: TImage;
    imgPlayerAvatar: TImage;
    pnlNext: TPanel;
    pnlExit: TPanel;
    pnlMessages: TPanel;
    pnlPrevious: TPanel;
    lblOpponentName: TLabel;
    lblPlayerName: TLabel;
    imgNext: TImage;
    imgPrevious: TImage;
    imgMessages: TImage;
    imgExit: TImage;
    lblPlayerTimer: TLabel;
    lblOpponentTimer: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgExitClick(Sender: TObject);
  private
    FBoard: IBoard;
    FRoom: IRoom;
    FTimerPlayer1: TBoardTimer;
    FTimerPlayer2: TBoardTimer;
    FServerController: IServerController;
    procedure SetPlayer;
    procedure SetCurrentPlayerBlackPiece;
    procedure UpdateBoard;
    procedure UpdateTimers;
    procedure UpdatePlayers;
    procedure ValidateCheckMate;
    procedure OnError(E: ExceptClass);
    procedure OnPlayer1TimeExpired;
    procedure OnPlayer2TimeExpired;
  public
    class procedure StartGame; static;
  end;

var
  BoardView: TBoardView;

implementation

{$R *.dfm}

class procedure TBoardView.StartGame;
var
  BoardView: TBoardView;
begin
  BoardView := TBoardView.Create(nil);
  try
    BoardView.ShowModal();
  finally
    BoardView.Free;
  end;
end;

procedure TBoardView.FormDestroy(Sender: TObject);
begin
  FServerController.Finalize();

  FreeAndNil(FTimerPlayer1);
  FreeAndNil(FTimerPlayer2);
  FBoard := nil;
end;

procedure TBoardView.FormCreate(Sender: TObject);
var
  BoardBuilder: IBoardBuilder;
begin
  FRoom := TRoomController.Current;

  SetPlayer();

  FTimerPlayer1 := TBoardTimer.Create(FRoom.Time, lblPlayerTimer, OnPlayer1TimeExpired);
  FTimerPlayer2 := TBoardTimer.Create(FRoom.Time, lblOpponentTimer, OnPlayer2TimeExpired);

  BoardBuilder := TBoardBuilder.Create();

  FBoard := BoardBuilder
              .SetBoardPanel(pnlBoard)
              .SetState(FRoom.State)
              .Build();

  FRoom.RegisterObserver(UpdateBoard);
  FRoom.RegisterObserver(ValidateCheckMate);

  FBoard.Render();

  FServerController := TServerController.Create(FRoom, OnError);
  FServerController.Start();

  UpdateTimers();
end;

procedure TBoardView.imgExitClick(Sender: TObject);
begin
  TRoomController.Leave();
  Self.Close();
end;

procedure TBoardView.SetPlayer;
var
  ImageName: string;
begin
  if FRoom.State.CurrentPlayerColor = pcBlack then
  begin
    ImageName := 'a' + FRoom.Owner.IconIndex.ToString;

    TImageLoader.Load(ImageName, imgOpponentAvatar);
    lblOpponentName.Caption := FRoom.Owner.Name;

    SetCurrentPlayerBlackPiece();
    Exit;
  end;

  ImageName := 'a' + TRoomController.Player.IconIndex.ToString;

  TImageLoader.Load(ImageName, imgPlayerAvatar);
  lblPlayerName.Caption := TRoomController.Player.Name;

  SetCurrentPlayerBlackPiece();
end;

procedure TBoardView.SetCurrentPlayerBlackPiece;
var
  ImageName: string;
  CurrentPlayerBlackPiece: IBoardPlayer;
begin
  CurrentPlayerBlackPiece := FRoom.NextPlayersBlackPiece[FRoom.CurrentPlayerBlackPiece];

  ImageName := 'a' + CurrentPlayerBlackPiece.IconIndex.ToString;

  if FRoom.State.CurrentPlayerColor = pcBlack then
  begin
    TImageLoader.Load(ImageName, imgPlayerAvatar);
    lblPlayerName.Caption := CurrentPlayerBlackPiece.Name;
  end
  else
  begin
    TImageLoader.Load(ImageName, imgOpponentAvatar);
    lblOpponentName.Caption := CurrentPlayerBlackPiece.Name;
  end;
end;

procedure TBoardView.UpdateBoard;
begin
  FBoard.Render();
  UpdateTimers();
  UpdatePlayers();
end;

procedure TBoardView.UpdateTimers;
var
  State: IBoardState;
begin
  State := FRoom.State;
  if State.CurrentTurnColor = State.CurrentPlayerColor then
  begin
    FTimerPlayer1.Play();
    FTimerPlayer2.Pause();
  end
  else
  begin
    FTimerPlayer1.Pause();
    FTimerPlayer2.Play();
  end;
end;

procedure TBoardView.ValidateCheckMate;
begin
  if FRoom.State.IsCheckMate(FRoom.State.CurrentPlayerColor) then
  begin
    TCheckMateView.ShowView(FRoom.State.OpponentColor);
    Self.Close();
    Abort;
  end;

  if FRoom.State.IsCheckMate(FRoom.State.OpponentColor) then
  begin
    TCheckMateView.ShowView(FRoom.State.CurrentPlayerColor);
    Self.Close();
    Abort;
  end;

  if (FRoom.Players.Count = 1) then
  begin
    TCheckMateView.ShowView(FRoom.State.CurrentPlayerColor);
    Self.Close();
    Abort;
  end;
end;

procedure TBoardView.OnError(E: ExceptClass);
begin
  if E = EDeletedRoom then
    TCheckMateView.ShowView(FRoom.State.CurrentTurnColor);

  Self.Close();
  Abort;
end;


procedure TBoardView.UpdatePlayers;
begin
  SetCurrentPlayerBlackPiece();
end;

procedure TBoardView.OnPlayer1TimeExpired;
begin
  FTimerPlayer1.Pause();
  FTimerPlayer2.Pause();

  TCheckMateView.ShowView(FRoom.State.OpponentColor);

  Self.Close();
end;

procedure TBoardView.OnPlayer2TimeExpired;
begin
  FTimerPlayer1.Pause();
  FTimerPlayer2.Pause();

  TCheckMateView.ShowView(FRoom.State.CurrentPlayerColor);

  Self.Close();
end;

end.
