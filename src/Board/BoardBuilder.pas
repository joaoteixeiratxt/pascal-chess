unit BoardBuilder;

interface

uses
  System.Classes, System.Types, System.SysUtils, Vcl.ExtCtrls, Winapi.Windows,
  Vcl.Controls, Vcl.Graphics, Board, BoardState, BoardPiece, ImageLoader, ColorUtils;

type
  TRowBuilder = class
  public
    class function Build(const BoardPanel: TPanel): TPanel; static;
  end;

  TSquareBuilder = class
  public
    class var Toggle: Boolean;
    class function Build(const RowPanel: TPanel): TPanel; static;
  end;

  TSquareImageBuilder = class
  public
    class procedure Build(const SquarePanel: TPanel); static;
  end;

  IBoardBuilder = interface
  ['{C15DF4E4-4B03-4C73-B7DD-560151028BC9}']
    function Board(const BoardPanel: TPanel): IBoardBuilder;
    function Build(State: IBoardState): IBoard;
  end;

  TBoardBuilder = class(TInterfacedObject, IBoardBuilder)
  private
    FBoardPanel: TPanel;
  public
    function Board(const BoardPanel: TPanel): IBoardBuilder;
    function Build(State: IBoardState): IBoard;
  end;

implementation

{ TRowBuilder }

class function TRowBuilder.Build(const BoardPanel: TPanel): TPanel;
begin
  Result := TPanel.Create(BoardPanel);
  Result.Parent := BoardPanel;
  Result.Align := alTop;
  Result.Width := BoardPanel.Width;
  Result.Height := Trunc(BoardPanel.Height / BOARD_ROWS);
  Result.BevelOuter := bvNone;
end;

{ TSquareBuilder }

class function TSquareBuilder.Build(const RowPanel: TPanel): TPanel;
begin
  Result := TPanel.Create(RowPanel);
  Result.Parent := RowPanel;
  Result.Align := alLeft;
  Result.Width := Trunc(RowPanel.Width / BOARD_COLUMNS);
  Result.ParentBackground := False;
  Result.ParentColor := False;
  Result.BevelOuter := bvNone;

  if Toggle then
    Result.Color := TColorUtils.HexToColor('EBECD0')
  else
    Result.Color := TColorUtils.HexToColor('739552');

  TSquareImageBuilder.Build(Result);

  Toggle := not Toggle;
end;

{ TSquareImageBuilder }

class procedure TSquareImageBuilder.Build(const SquarePanel: TPanel);
var
  SquareImage: TImage;
begin
  SquareImage := TImage.Create(SquarePanel);
  SquareImage.Parent := SquarePanel;
  SquareImage.Align := alClient;
  SquareImage.Cursor := crHandPoint;
  SquareImage.Proportional := True;
  SquareImage.Transparent := True;
end;

{ TBoardBuilder }

function TBoardBuilder.Board(const BoardPanel: TPanel): IBoardBuilder;
begin
  FBoardPanel := BoardPanel;
  Result := Self;
end;

function TBoardBuilder.Build(State: IBoardState): IBoard;
var
  Row, Col: Integer;
  RowPanel: TPanel;
  BoardMatrix: TBoardMatrix;
begin
  Result := TBoard.Create();

  for Row := 0 to Pred(BOARD_ROWS) do
  begin
    TSquareBuilder.Toggle := not TSquareBuilder.Toggle;
    RowPanel := TRowBuilder.Build(FBoardPanel);

    for Col := 0 to Pred(BOARD_COLUMNS) do
      BoardMatrix[Row, Col]:= TSquareBuilder.Build(RowPanel);
  end;

  Result.SetState(State);
  Result.SetBoardPanel(FBoardPanel);
  Result.SetBoardMatrix(BoardMatrix);
end;

end.
