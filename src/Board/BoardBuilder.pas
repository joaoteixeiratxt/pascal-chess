unit BoardBuilder;

interface

uses
  System.Classes, System.Types, System.SysUtils, Vcl.ExtCtrls,
  Vcl.Controls, BoardState, BoardPiece, ImageLoader;

type
  TBoardMatrix = array[0..7, 0..7] of TPanel;

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

  IBoard = interface
  ['{9E74D5D8-3789-4B7F-A288-EEED76F9F589}']
    procedure SetState(const State: IBoardState);
    procedure SetBoardPanel(const BoardPanel: TPanel);
    procedure SetBoardMatrix(const BoardMatrix: TBoardMatrix);
    procedure Render;
  end;

  TBoard = class(TInterfacedObject, IBoard)
  private
    FState: IBoardState;
    FBoardPanel: TPanel;
    FBoardMatrix: TBoardMatrix;
  public
    procedure SetState(const State: IBoardState);
    procedure SetBoardPanel(const BoardPanel: TPanel);
    procedure SetBoardMatrix(const BoardMatrix: TBoardMatrix);
    procedure Render;
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

const
  ROWS = 8;
  COLUMNS = 8;

{ TRowBuilder }

class function TRowBuilder.Build(const BoardPanel: TPanel): TPanel;
begin
  Result := TPanel.Create(BoardPanel);
  Result.Parent := BoardPanel;
  Result.Align := alTop;
  Result.Width := BoardPanel.Width;
  Result.Height := Trunc(BoardPanel.Height / ROWS);
end;

{ TSquareBuilder }

class function TSquareBuilder.Build(const RowPanel: TPanel): TPanel;
begin
  Result := TPanel.Create(RowPanel);
  Result.Parent := RowPanel;
  Result.Align := alLeft;
  Result.Width := Trunc(RowPanel.Width / COLUMNS);

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
  SquareImage.Cursor := crHandPoint;
  SquareImage.Proportional := True;
end;

{ TBoard }

procedure TBoard.SetState(const State: IBoardState);
begin
  FState := State;
end;

procedure TBoard.SetBoardPanel(const BoardPanel: TPanel);
begin
  FBoardPanel := BoardPanel;
end;

procedure TBoard.SetBoardMatrix(const BoardMatrix: TBoardMatrix);
begin
  FBoardMatrix := BoardMatrix;
end;

procedure TBoard.Render;
var
  Piece: IPiece;
  PiecePanel: TPanel;
  Row, Col: Integer;
  SquareImage: TImage;
  PieceMatrix: TPieceMatrix;
begin
  PieceMatrix := FState.GetPieceMatrix();

  for Row := 0 to 7 do
  begin
    for Col := 0 to 7 do
    begin
      Piece := PieceMatrix[Row, Col];

      if not Assigned(Piece) then
        Continue;

      PiecePanel := FBoardMatrix[Row, Col];
      SquareImage := TImage(PiecePanel.Components[0]);

      TImageLoader.Load(Piece.ImageName, SquareImage);
    end;
  end;

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

  for Row := 0 to Pred(ROWS) do
  begin
    RowPanel := TRowBuilder.Build(FBoardPanel);

    for Col := 0 to Pred(COLUMNS) do
      BoardMatrix[Row, Col]:= TSquareBuilder.Build(RowPanel);
  end;

  Result.SetState(State);
  Result.SetBoardPanel(FBoardPanel);
  Result.SetBoardMatrix(BoardMatrix);
end;

end.
