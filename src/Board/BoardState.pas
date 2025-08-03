unit BoardState;

interface

uses
  System.Classes, System.Types, System.SysUtils, System.Generics.Collections,
  BoardPiece;

const
  BOARD_ROWS = 8;
  BOARD_COLUMNS = 8;

type
  TPieceMatrix = array[0..7, 0..7] of IPiece;

  TStateUpdateEvent = procedure of object;

  IBoardState = interface
  ['{984AB04C-D208-47A0-8A1C-71634201AB3B}']
    procedure Initialize;
    function GetPieceMatrix: TPieceMatrix;
    function GetSelectedPiece: IPiece;
    procedure SetSelectedPiece(const Value: IPiece);
    function GetCurrentPlayerColor: TPieceColor;
    procedure SetCurrentPlayerColor(const Value: TPieceColor);
    function GetCurrentTurnColor: TPieceColor;
    function GetPieceAt(const Coordinates: TPoint): IPiece;
    procedure MovePiece(const FromCoordinates, ToCoordinates: TPoint);
    procedure RegisterObserver(const Event: TStateUpdateEvent);
    property SelectedPiece: IPiece read GetSelectedPiece write SetSelectedPiece;
    property CurrentPlayerColor: TPieceColor read GetCurrentPlayerColor write SetCurrentPlayerColor;
    property CurrentTurnColor: TPieceColor read GetCurrentTurnColor;
  end;

  TBoardState = class(TInterfacedObject, IBoardState)
  private
    FBoardMatrix: TPieceMatrix;
    FEvents: TList<TStateUpdateEvent>;
    FSelectedPiece: IPiece;
    FCurrentPlayerColor: TPieceColor;
    FCurrentTurnColor: TPieceColor;
    function GetSelectedPiece: IPiece;
    procedure SetSelectedPiece(const Value: IPiece);
    procedure NotifyAll;
    function GetCurrentPlayerColor: TPieceColor;
    procedure SetCurrentPlayerColor(const Value: TPieceColor);
    function GetCurrentTurnColor: TPieceColor;
    procedure SetCurrentTurnColor;
    procedure Clear;
    procedure CreatePieces(Color: TPieceColor);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    function GetPieceMatrix: TPieceMatrix;
    function GetPieceAt(const Coordinates: TPoint): IPiece;
    procedure MovePiece(const FromCoordinates, ToCoordinates: TPoint);
    procedure RegisterObserver(const Event: TStateUpdateEvent);
    property SelectedPiece: IPiece read GetSelectedPiece write SetSelectedPiece;
    property CurrentPlayerColor: TPieceColor read GetCurrentPlayerColor write SetCurrentPlayerColor;
    property CurrentTurnColor: TPieceColor read GetCurrentTurnColor;

    class var State: IBoardState;
  end;

implementation

{ TBoardState }

constructor TBoardState.Create;
begin
  FCurrentTurnColor := pcWhite;
  FEvents := TList<TStateUpdateEvent>.Create();
end;

destructor TBoardState.Destroy;
begin
  FreeAndNil(FEvents);
  inherited;
end;

procedure TBoardState.Clear;
var
  Row, Column: Integer;
begin
  for Column := Pred(BOARD_COLUMNS) downto 0 do
    for Row := 0 to Pred(BOARD_ROWS) do
      FBoardMatrix[Column, Row] := nil;
end;

procedure TBoardState.CreatePieces(Color: TPieceColor);
var
  RowSpecialPieces, RowPawnPieces,
  KingColumn, QueenColumn, Column: Integer;
begin
  if Color = FCurrentPlayerColor then
  begin
    RowSpecialPieces := 0;
    RowPawnPieces := 1;
  end
  else
  begin
    RowSpecialPieces := 7;
    RowPawnPieces := 6;
  end;

  if FCurrentPlayerColor = pcWhite then
  begin
    QueenColumn := 3;
    KingColumn := 4;
  end
  else
  begin
    QueenColumn := 4;
    KingColumn := 3;
  end;

  FBoardMatrix[0, RowSpecialPieces] := TPieceFactory.New(ptRook, Color);
  FBoardMatrix[1, RowSpecialPieces] := TPieceFactory.New(ptKnight, Color);
  FBoardMatrix[2, RowSpecialPieces] := TPieceFactory.New(ptBishop, Color);

  FBoardMatrix[QueenColumn, RowSpecialPieces] := TPieceFactory.New(ptQueen, Color);
  FBoardMatrix[KingColumn, RowSpecialPieces] := TPieceFactory.New(ptKing, Color);

  FBoardMatrix[5, RowSpecialPieces] := TPieceFactory.New(ptBishop, Color);
  FBoardMatrix[6, RowSpecialPieces] := TPieceFactory.New(ptKnight, Color);
  FBoardMatrix[7, RowSpecialPieces] := TPieceFactory.New(ptRook, Color);

  for Column := 0 to Pred(BOARD_COLUMNS) do
  begin
    FBoardMatrix[Column, RowPawnPieces] := TPieceFactory.New(ptPawn, Color);
    FBoardMatrix[Column, RowPawnPieces].Coordinates := TPoint.Create(Column, RowPawnPieces);

    FBoardMatrix[Column, RowSpecialPieces].Coordinates := TPoint.Create(Column, RowSpecialPieces);
  end;
end;


procedure TBoardState.Initialize;
begin
  Clear();
  CreatePieces(pcWhite);
  CreatePieces(pcBlack);
end;

function TBoardState.GetSelectedPiece: IPiece;
begin
  Result := FSelectedPiece;
end;

procedure TBoardState.SetSelectedPiece(const Value: IPiece);
begin
  FSelectedPiece := Value;
end;

function TBoardState.GetPieceMatrix: TPieceMatrix;
begin
  Result := FBoardMatrix;
end;

function TBoardState.GetCurrentPlayerColor: TPieceColor;
begin
  Result := FCurrentPlayerColor;
end;

procedure TBoardState.SetCurrentPlayerColor(const Value: TPieceColor);
begin
  FCurrentPlayerColor := Value;
end;

function TBoardState.GetCurrentTurnColor: TPieceColor;
begin
  Result := FCurrentTurnColor;
end;

procedure TBoardState.SetCurrentTurnColor;
begin
  if FCurrentTurnColor = pcWhite then
    FCurrentTurnColor := pcBlack
  else
    FCurrentTurnColor := pcWhite
end;

function TBoardState.GetPieceAt(const Coordinates: TPoint): IPiece;
begin
  Result := FBoardMatrix[Coordinates.X, Coordinates.Y];
end;

procedure TBoardState.MovePiece(const FromCoordinates, ToCoordinates: TPoint);
begin
  FBoardMatrix[ToCoordinates.X, ToCoordinates.Y] := FBoardMatrix[FromCoordinates.X, FromCoordinates.Y];
  FBoardMatrix[ToCoordinates.X, ToCoordinates.Y].Coordinates := TPoint.Create(ToCoordinates.X, ToCoordinates.Y);
  FBoardMatrix[ToCoordinates.X, ToCoordinates.Y].HasMoved := True;
  FBoardMatrix[FromCoordinates.X, FromCoordinates.Y] := nil;

  SetCurrentTurnColor();
  NotifyAll();
end;

procedure TBoardState.NotifyAll;
var
  Event: TStateUpdateEvent;
begin
  for Event in FEvents do
    Event();
end;

procedure TBoardState.RegisterObserver(const Event: TStateUpdateEvent);
begin
  FEvents.Add(Event);
end;

initialization
  TBoardState.State := TBoardState.Create();

end.

