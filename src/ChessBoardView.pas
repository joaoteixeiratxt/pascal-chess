unit ChessBoardView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

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
    procedure FormCreate(Sender: TObject);
  end;

var
  BoardView: TBoardView;

implementation

uses
  Board, BoardState, BoardBuilder;

{$R *.dfm}

procedure TBoardView.FormCreate(Sender: TObject);
var
  Board: IBoard;
  BoardState: IBoardState;
  BoardBuilder: IBoardBuilder;
begin
  BoardState := TBoardState.Create();
  BoardState.Initialize();

  BoardBuilder := TBoardBuilder.Create();

  Board := BoardBuilder
              .SetBoardPanel(pnlBoard)
              .SetState(BoardState)
              .Build();

  Board.Render();
end;

end.
