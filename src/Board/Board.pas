unit Board;

interface

uses
  System.Classes, System.Types, System.SysUtils, Vcl.ExtCtrls, Winapi.Windows,
  Vcl.Controls, Vcl.Graphics, BoardState, BoardPiece, ImageLoader;

const
  BOARD_ROWS = 8;
  BOARD_COLUMNS = 8;
  PRIMARY_SQUARE_COLOR = 'EBECD0';
  SECONDARY_SQUARE_COLOR = '739552';

type
  TBoardMatrix = array[0..7, 0..7] of TPanel;

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

implementation

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

  for Row := 0 to Pred(BOARD_ROWS) do
  begin
    for Col := 0 to Pred(BOARD_COLUMNS) do
    begin
      Piece := PieceMatrix[Row, Col];

      if not Assigned(Piece) then
        Continue;

      PiecePanel := FBoardMatrix[Row, Col];

      SquareImage := TImage(PiecePanel.Components[0]);
      SquareImage.Cursor := crHandPoint;

      TImageLoader.Load(Piece.ImageName, SquareImage);
    end;
  end;
end;

end.
