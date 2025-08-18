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
  FTimerPlayer1 := TBoardTimer.Create(TIME, lblPlayerTimer);
  FTimerPlayer2 := TBoardTimer.Create(TIME, lblOpponentTimer);

  BoardBuilder := TBoardBuilder.Create();

  FBoard := BoardBuilder
              .SetBoardPanel(pnlBoard)
              .SetState(TRoomController.Current.State)
              .Build();

  TRoomController.Current.RegisterObserver(UpdateBoard);

  FBoard.Render();

  FTimerPlayer1.Play();
  FTimerPlayer2.Play();

  FServerController := TServerController.Create(TRoomController.Current);
  FServerController.Start();
end;

procedure TBoardView.UpdateBoard;
begin
  FBoard.Render();
end;

end.
