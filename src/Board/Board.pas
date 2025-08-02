unit Board;

interface

uses
  System.Classes, System.Types, System.SysUtils, Vcl.ExtCtrls, Winapi.Windows,
  Vcl.Controls, Vcl.Graphics, BoardState, BoardPiece, ImageLoader, Dialogs,
  System.Generics.Collections;

const
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
    procedure OnLegalMoveClick(Sender: TObject);
    procedure ClearHighlights;
    procedure HightLightLegalMoves(const LegalMoves: TLegalMoves);
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
  for Row := Pred(BOARD_ROWS) downto 0 do
  begin
    for Col := 0 to Pred(BOARD_COLUMNS) do
    begin
      PiecePanel := FBoardMatrix[Col, Row];

      HighlightImage := TImage(PiecePanel.FindComponent('LegalMoveHighlight'));
      HighlightImage.Cursor := crDefault;
      HighlightImage.Visible := False;
    end;
  end;
end;

procedure TBoard.HightLightLegalMoves(const LegalMoves: TLegalMoves);
var
  Coordinates: TPoint;
  PiecePanel: TPanel;
  HighlightImage: TImage;
begin
  ClearHighlights();

  for Coordinates in LegalMoves do
  begin
    PiecePanel := FBoardMatrix[Coordinates.X, Coordinates.Y];

    HighlightImage := TImage(PiecePanel.FindComponent('LegalMoveHighlight'));
    HighlightImage.Cursor := crHandPoint;
    HighlightImage.Visible := True;
    HighlightImage.OnClick := OnLegalMoveClick;
  end;
end;

procedure TBoard.OnPieceClick(Sender: TObject);
var
  Piece: IPiece;
begin
  Piece := FPiecesMap[TComponent(Sender).Tag];
  TBoardState.State.SelectedPiece := Piece;

  HightLightLegalMoves(Piece.GetLegalMoves());
end;

procedure TBoard.OnLegalMoveClick(Sender: TObject);
var
  SquarePanel: TPanel;
  Coordinates: string;
  ToCoordinates: TPoint;
begin
  SquarePanel := TPanel(TComponent(Sender).Owner);
  Coordinates := SquarePanel.Name;

  ToCoordinates.X := Coordinates.Split(['_'])[0].Split(['X'])[1].ToInteger();
  ToCoordinates.Y := Coordinates.Split(['_'])[1].Split(['Y'])[1].ToInteger();

  FState.MovePiece(FState.SelectedPiece.Coordinates, ToCoordinates);

  ClearHighlights();
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

  for Row := Pred(BOARD_ROWS) downto 0 do
  begin
    for Col := 0 to Pred(BOARD_COLUMNS) do
    begin
      Piece := PieceMatrix[Col, Row];
      PiecePanel := FBoardMatrix[Col, Row];

      if not Assigned(Piece) then
      begin
        TImage(PiecePanel.FindComponent('Piece')).Visible := False;
        TImage(PiecePanel.FindComponent('LegalMoveHighlight')).Visible := False;
        Continue;
      end;

      SquareImage := TImage(PiecePanel.FindComponent('Piece'));
      SquareImage.Cursor := crHandPoint;
      SquareImage.OnClick := OnPieceClick;
      SquareImage.Visible := True;

      TImageLoader.Load(Piece.ImageName, SquareImage);

      FPiecesMap.AddOrSetValue(SquareImage.Tag, Piece);
    end;
  end;
end;

end.
