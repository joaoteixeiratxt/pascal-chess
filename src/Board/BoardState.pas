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
    function GetPieceAt(const Row, Col: Integer): IPiece;
    procedure SetPieceAt(const Row, Col: Integer; const Value: IPiece);
    procedure MovePiece(const FromCol, FromRow, ToCol, ToRow: Integer);
    procedure RegisterObserver(const Event: TStateUpdateEvent);
    property SelectedPiece: IPiece read GetSelectedPiece write SetSelectedPiece;
    property CurrentPlayerColor: TPieceColor read GetCurrentPlayerColor write SetCurrentPlayerColor;
  end;

  TBoardState = class(TInterfacedObject, IBoardState)
  private
    FBoardMatrix: TPieceMatrix;
    FEvents: TList<TStateUpdateEvent>;
    FSelectedPiece: IPiece;
    FCurrentPlayerColor: TPieceColor;
    function GetSelectedPiece: IPiece;
    procedure SetSelectedPiece(const Value: IPiece);
    procedure NotifyAll;
    function GetCurrentPlayerColor: TPieceColor;
    procedure SetCurrentPlayerColor(const Value: TPieceColor);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    function GetPieceMatrix: TPieceMatrix;
    function GetPieceAt(const Row, Col: Integer): IPiece;
    procedure SetPieceAt(const Row, Col: Integer; const Value: IPiece);
    procedure MovePiece(const FromCol, FromRow, ToCol, ToRow: Integer);
    procedure RegisterObserver(const Event: TStateUpdateEvent);
    property SelectedPiece: IPiece read GetSelectedPiece write SetSelectedPiece;
    property CurrentPlayerColor: TPieceColor read GetCurrentPlayerColor write SetCurrentPlayerColor;

    class var State: IBoardState;
  end;

implementation

{ TBoardState }

constructor TBoardState.Create;
begin
  FEvents := TList<TStateUpdateEvent>.Create();
end;

destructor TBoardState.Destroy;
begin
  FreeAndNil(FEvents);
  inherited;
end;

procedure TBoardState.Initialize;
var
  Row, Column: Integer;
begin
  for Row := Pred(BOARD_ROWS) downto 0 do
    for Column := 0 to Pred(BOARD_COLUMNS) do
      FBoardMatrix[Row, Column] := nil;

  FBoardMatrix[0, 0] := TPieceFactory.New(ptRook, pcWhite);
  FBoardMatrix[1, 0] := TPieceFactory.New(ptKnight, pcWhite);
  FBoardMatrix[2, 0] := TPieceFactory.New(ptBishop, pcWhite);
  FBoardMatrix[3, 0] := TPieceFactory.New(ptQueen, pcWhite);
  FBoardMatrix[4, 0] := TPieceFactory.New(ptKing, pcWhite);
  FBoardMatrix[5, 0] := TPieceFactory.New(ptBishop, pcWhite);
  FBoardMatrix[6, 0] := TPieceFactory.New(ptKnight, pcWhite);
  FBoardMatrix[7, 0] := TPieceFactory.New(ptRook, pcWhite);

  for Column := 0 to Pred(BOARD_COLUMNS) do
  begin
    FBoardMatrix[Column, 1] := TPieceFactory.New(ptPawn, pcWhite);
    FBoardMatrix[Column, 1].Coordinates := TPoint.Create(Column, 1);

    FBoardMatrix[Column, 0].Coordinates := TPoint.Create(Column, 0);
  end;

  FBoardMatrix[0, 7] := TPieceFactory.New(ptRook, pcBlack);
  FBoardMatrix[1, 7] := TPieceFactory.New(ptKnight, pcBlack);
  FBoardMatrix[2, 7] := TPieceFactory.New(ptBishop, pcBlack);
  FBoardMatrix[3, 7] := TPieceFactory.New(ptQueen, pcBlack);
  FBoardMatrix[4, 7] := TPieceFactory.New(ptKing, pcBlack);
  FBoardMatrix[5, 7] := TPieceFactory.New(ptBishop, pcBlack);
  FBoardMatrix[6, 7] := TPieceFactory.New(ptKnight, pcBlack);
  FBoardMatrix[7, 7] := TPieceFactory.New(ptRook, pcBlack);

  for Column := 0 to Pred(BOARD_COLUMNS) do
  begin
    FBoardMatrix[Column, 6] := TPieceFactory.New(ptPawn, pcBlack);
    FBoardMatrix[Column, 6].Coordinates := TPoint.Create(Column, 6);

    FBoardMatrix[Column, 7].Coordinates := TPoint.Create(Column, 7);
  end;
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

function TBoardState.GetPieceAt(const Row, Col: Integer): IPiece;
begin
  Result := FBoardMatrix[Row, Col];
end;

procedure TBoardState.SetPieceAt(const Row, Col: Integer; const Value: IPiece);
begin
  FBoardMatrix[Row, Col] := Value;
end;

procedure TBoardState.MovePiece(const FromCol, FromRow, ToCol, ToRow: Integer);
begin
  FBoardMatrix[ToCol, ToRow] := FBoardMatrix[FromCol, FromRow];
  FBoardMatrix[ToCol, ToRow].Coordinates := TPoint.Create(ToCol, ToRow);
  FBoardMatrix[FromCol, FromRow] := nil;

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
begin
  TBoardState.State := TBoardState.Create();
  TBoardState.State.Initialize();
end;

end.

