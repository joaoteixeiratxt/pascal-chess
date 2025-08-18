unit ChessBoardView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Board, BoardState, BoardBuilder,
  Vcl.StdCtrls, System.Threading, BoardPiece, System.JSON, BoardTimer, RoomController, ServerController;

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
  private
    FBoard: IBoard;
    FTimerPlayer1: TBoardTimer;
    FTimerPlayer2: TBoardTimer;
    FServerController: IServerController;
    procedure UpdateBoard;
    procedure UpdateTimers;
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
const
  TIME = 1 * 60;
var
  BoardBuilder: IBoardBuilder;
begin
  FTimerPlayer1 := TBoardTimer.Create(TIME, lblPlayerTimer, OnPlayer1TimeExpired);
  FTimerPlayer2 := TBoardTimer.Create(TIME, lblOpponentTimer, OnPlayer2TimeExpired);

  BoardBuilder := TBoardBuilder.Create();

  FBoard := BoardBuilder
              .SetBoardPanel(pnlBoard)
              .SetState(TRoomController.Current.State)
              .Build();

  TRoomController.Current.RegisterObserver(UpdateBoard);

  FBoard.Render();

  FServerController := TServerController.Create(TRoomController.Current);
  FServerController.Start();

  UpdateTimers();
end;

procedure TBoardView.UpdateBoard;
begin
  FBoard.Render();
  UpdateTimers();
end;

procedure TBoardView.UpdateTimers;
var
  State: IBoardState;
begin
  State := TRoomController.Current.State;
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

procedure TBoardView.OnPlayer1TimeExpired;
begin
  FTimerPlayer1.Pause();
  FTimerPlayer2.Pause();
  ShowMessage('Time''s up! You lost.');
end;

procedure TBoardView.OnPlayer2TimeExpired;
begin
  FTimerPlayer1.Pause();
  FTimerPlayer2.Pause();
  ShowMessage('Time''s up! You win.');
end;

end.
