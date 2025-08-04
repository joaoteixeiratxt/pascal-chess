unit ChessBoardView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Board, BoardState, BoardBuilder,
  Vcl.StdCtrls, System.Threading, BoardPiece, System.JSON, BoardTimer;

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
  private
    FBoard: IBoard;
    FHashState: string;
    FTimerPlayer1: TBoardTimer;
    FTimerPlayer2: TBoardTimer;
    procedure UpdateBoard;
    function ValidateHashState: Boolean;
  end;

var
  BoardView: TBoardView;

implementation

{$R *.dfm}

procedure TBoardView.FormCreate(Sender: TObject);
const
  TIME = 1 * 60;
var
  BoardBuilder: IBoardBuilder;
begin
  FTimerPlayer1 := TBoardTimer.Create(TIME, lblPlayerTimer);
  FTimerPlayer2 := TBoardTimer.Create(TIME, lblOpponentTimer);

  TBoardStateController.LoadJSONState();

  BoardBuilder := TBoardBuilder.Create();

  FBoard := BoardBuilder
              .SetBoardPanel(pnlBoard)
              .SetState(TBoardState.State)
              .Build();

  TBoardState.State.RegisterObserver(UpdateBoard);

  FBoard.Render();

  FTimerPlayer1.Play();
  FTimerPlayer2.Play();

  TThread.CreateAnonymousThread(procedure
  begin
    while True do
    begin
      Sleep(1000);

      TBoardStateController.LoadJSONState();

      if ValidateHashState then
      begin
        FHashState := TBoardState.State.ToJSON.ToString();
        TThread.Synchronize(nil, procedure
        begin
          FBoard.Render();
        end);
      end;
    end;
  end).Start();
end;

procedure TBoardView.UpdateBoard;
begin
  FBoard.Render();
end;

function TBoardView.ValidateHashState: Boolean;
var
  StateJSON: TJSONObject;
begin
  StateJSON := TBoardState.State.ToJSON();
  try
    Result := FHashState <> StateJSON.ToString();
  finally
    StateJSON.Free;
  end
end;

end.
