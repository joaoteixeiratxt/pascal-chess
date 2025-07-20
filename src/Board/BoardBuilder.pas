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
    class function Build(const RowPanel: TPanel; const ImageTag: Integer): TPanel; static;
  end;

  TSquareImageBuilder = class
  public
    class procedure Build(const ImageName: string; SquarePanel: TPanel; const Tag: Integer); static;
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

class function TSquareBuilder.Build(const RowPanel: TPanel; const ImageTag: Integer): TPanel;
begin
  Result := TPanel.Create(RowPanel);
  Result.Parent := RowPanel;
  Result.Align := alLeft;
  Result.Width := Trunc(RowPanel.Width / BOARD_COLUMNS);
  Result.ParentBackground := False;
  Result.ParentColor := False;
  Result.BevelOuter := bvNone;
  Result.ShowCaption := False;

  if TColorUtils.ToggleColor() then
    Result.Color := TColorUtils.HexToColor(PRIMARY_SQUARE_COLOR)
  else
    Result.Color := TColorUtils.HexToColor(SECONDARY_SQUARE_COLOR);

  TSquareImageBuilder.Build('Piece', Result, ImageTag);
  TSquareImageBuilder.Build('LegalMoveHighlight', Result, ImageTag);
end;

{ TSquareImageBuilder }

class procedure TSquareImageBuilder.Build(const ImageName: string; SquarePanel: TPanel; const Tag: Integer);
var
  SquareImage: TImage;
begin
  SquareImage := TImage.Create(SquarePanel);
  SquareImage.Parent := SquarePanel;
  SquareImage.Align := alClient;
  SquareImage.Proportional := True;
  SquareImage.Transparent := True;
  SquareImage.Name := ImageName;
  SquareImage.Tag := Tag;
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
  ImageTag: Integer;
  SquarePanel: TPanel;
  HighlightImage: TImage;
  BoardMatrix: TBoardMatrix;
begin
  Result := TBoard.Create();

  ImageTag := 0;
  for Row := Pred(BOARD_ROWS) downto 0 do
  begin
    TColorUtils.ToggleColor();
    RowPanel := TRowBuilder.Build(FBoardPanel);

    for Col := 0 to Pred(BOARD_COLUMNS) do
    begin
      SquarePanel := TSquareBuilder.Build(RowPanel, ImageTag);
      SquarePanel.Name := Format('X%d_Y%d',[Col, Row]);

      HighlightImage := TImage(SquarePanel.FindComponent('LegalMoveHighlight'));
      HighlightImage.Cursor := crDefault;
      HighlightImage.Visible := False;

      TImageLoader.Load('LegalMoveHighlight', HighlightImage);

      BoardMatrix[Col, Row] := SquarePanel;
      Inc(ImageTag);
    end;
  end;

  Result.SetState(FState);
  Result.SetBoardPanel(FBoardPanel);
  Result.SetBoardMatrix(BoardMatrix);
end;

end.
