unit Board;

interface

uses
  System.Classes, System.Types, System.SysUtils, Vcl.ExtCtrls, Winapi.Windows,
  Vcl.Controls, Vcl.Graphics, BoardState, BoardPiece, ImageLoader, Dialogs,
  System.Generics.Collections;

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
    FPiecesMap: TDictionary<Integer,IPiece>;
    procedure OnPieceClick(Sender: TObject);
    procedure ClearHighlights;
    procedure HightLightPossibleMovements(const PossibleMovements: TPossibleMovements);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetState(const State: IBoardState);
    procedure SetBoardPanel(const BoardPanel: TPanel);
    procedure SetBoardMatrix(const BoardMatrix: TBoardMatrix);
    procedure Render;
  end;

implementation

{ TBoard }

constructor TBoard.Create;
begin
  FPiecesMap := TDictionary<Integer,IPiece>.Create();
end;

destructor TBoard.Destroy;
begin
  FreeAndNil(FPiecesMap);
  inherited;
end;

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

procedure TBoard.ClearHighlights;
var
  PiecePanel: TPanel;
  Row, Col: Integer;
  HighlightImage: TImage;
begin
  for Row := 0 to Pred(BOARD_ROWS) do
  begin
    for Col := 0 to Pred(BOARD_COLUMNS) do
    begin
      PiecePanel := FBoardMatrix[Row, Col];

      HighlightImage := TImage(PiecePanel.FindComponent('LegalMoveHighlight'));
      HighlightImage.Cursor := crDefault;
      HighlightImage.Visible := False;
    end;
  end;
end;

procedure TBoard.HightLightPossibleMovements(const PossibleMovements: TPossibleMovements);
var
  Coordinates: TPoint;
  PiecePanel: TPanel;
  HighlightImage: TImage;
begin
  ClearHighlights();

  for Coordinates in PossibleMovements do
  begin
    PiecePanel := FBoardMatrix[Coordinates.Y, Coordinates.X];

    HighlightImage := TImage(PiecePanel.FindComponent('LegalMoveHighlight'));
    HighlightImage.Cursor := crHandPoint;
    HighlightImage.Visible := True;
  end;
end;

procedure TBoard.OnPieceClick(Sender: TObject);
var
  Piece: IPiece;
begin
  Piece := FPiecesMap[TComponent(Sender).Tag];

  TBoardState.State.SelectedPiece := Piece;

  HightLightPossibleMovements(Piece.GetPossibleMovements());
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

      SquareImage := TImage(PiecePanel.FindComponent('Piece'));
      SquareImage.Cursor := crHandPoint;
      SquareImage.OnClick := OnPieceClick;

      TImageLoader.Load(Piece.ImageName, SquareImage);

      FPiecesMap.AddOrSetValue(SquareImage.Tag, Piece);
    end;
  end;
end;

end.
