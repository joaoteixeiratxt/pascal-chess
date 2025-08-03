unit ChessBoardView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Board, BoardState, BoardBuilder,
  Vcl.StdCtrls, BoardPiece;

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
    procedure FormCreate(Sender: TObject);
  private
    FBoard: IBoard;
    procedure UpdateBoard;
  end;

var
  BoardView: TBoardView;

implementation

{$R *.dfm}

procedure TBoardView.FormCreate(Sender: TObject);
var
  BoardBuilder: IBoardBuilder;
begin
  TBoardState.State.CurrentPlayerColor := pcWhite;
  TBoardState.State.Initialize();

  BoardBuilder := TBoardBuilder.Create();

  FBoard := BoardBuilder
              .SetBoardPanel(pnlBoard)
              .SetState(TBoardState.State)
              .Build();

  TBoardState.State.RegisterObserver(UpdateBoard);

  FBoard.Render();
end;

procedure TBoardView.UpdateBoard;
begin
  FBoard.Render();
end;

end.
