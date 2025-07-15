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
    class function Build(const RowPanel: TPanel): TPanel; static;
  end;

  TSquareImageBuilder = class
  public
    class procedure Build(const SquarePanel: TPanel); static;
  end;

  IBoardBuilder = interface
  ['{C15DF4E4-4B03-4C73-B7DD-560151028BC9}']
    function SetBoardPanel(const BoardPanel: TPanel): IBoardBuilder;
    function SetState(const State: IBoardState): IBoardBuilder;
    function Build: IBoard;
  end;

  TBoardBuilder = class(TInterfacedObject, IBoardBuilder)
  private
    FBoardPanel: TPanel;
    FState: IBoardState;
  public
    function SetBoardPanel(const BoardPanel: TPanel): IBoardBuilder;
    function SetState(const State: IBoardState): IBoardBuilder;
    function Build: IBoard;
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

  if TColorUtils.ToggleColor() then
    Result.Color := TColorUtils.HexToColor(PRIMARY_SQUARE_COLOR)
  else
    Result.Color := TColorUtils.HexToColor(SECONDARY_SQUARE_COLOR);

  TSquareImageBuilder.Build(Result);
end;

{ TSquareImageBuilder }

class procedure TSquareImageBuilder.Build(const SquarePanel: TPanel);
var
  SquareImage: TImage;
begin
  SquareImage := TImage.Create(SquarePanel);
  SquareImage.Parent := SquarePanel;
  SquareImage.Align := alClient;
  SquareImage.Proportional := True;
  SquareImage.Transparent := True;
end;

{ TBoardBuilder }

function TBoardBuilder.SetBoardPanel(const BoardPanel: TPanel): IBoardBuilder;
begin
  FBoardPanel := BoardPanel;
  Result := Self;
end;

function TBoardBuilder.SetState(const State: IBoardState): IBoardBuilder;
begin
  FState := State;
  Result := Self;
end;

function TBoardBuilder.Build: IBoard;
var
  Row, Col: Integer;
  RowPanel: TPanel;
  BoardMatrix: TBoardMatrix;
begin
  Result := TBoard.Create();

  for Row := 0 to Pred(BOARD_ROWS) do
  begin
    TColorUtils.ToggleColor();
    RowPanel := TRowBuilder.Build(FBoardPanel);

    for Col := 0 to Pred(BOARD_COLUMNS) do
      BoardMatrix[Row, Col]:= TSquareBuilder.Build(RowPanel);
  end;

  Result.SetState(FState);
  Result.SetBoardPanel(FBoardPanel);
  Result.SetBoardMatrix(BoardMatrix);
end;

end.
