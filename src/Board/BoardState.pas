unit BoardState;

interface

uses
  System.Classes, System.Types, System.SysUtils, System.Generics.Collections,
  BoardPiece;

type
  TPieceMatrix = array[0..7, 0..7] of IPiece;

  TStateUpdateEvent = procedure of object;

  IBoardState = interface
  ['{984AB04C-D208-47A0-8A1C-71634201AB3B}']
    procedure Initialize;
    function GetPieceMatrix: TPieceMatrix;
    function GetSelectedPiece: IPiece;
    procedure SetSelectedPiece(const Value: IPiece);
    function GetPieceAt(const Row, Col: Integer): IPiece;
    procedure SetPieceAt(const Row, Col: Integer; const Value: IPiece);
    procedure MovePiece(const FromRow, FromCol, ToRow, ToCol: Integer);
    property SelectedPiece: IPiece read GetSelectedPiece write SetSelectedPiece;
    procedure RegisterObserver(const Event: TStateUpdateEvent);
  end;

  TBoardState = class(TInterfacedObject, IBoardState)
  private
    FBoardMatrix: TPieceMatrix;
    FEvents: TList<TStateUpdateEvent>;
    FSelectedPiece: IPiece;
    function GetSelectedPiece: IPiece;
    procedure SetSelectedPiece(const Value: IPiece);
    procedure NotifyAll;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    property SelectedPiece: IPiece read GetSelectedPiece write SetSelectedPiece;
    function GetPieceMatrix: TPieceMatrix;
    function GetPieceAt(const Row, Col: Integer): IPiece;
    procedure SetPieceAt(const Row, Col: Integer; const Value: IPiece);
    procedure MovePiece(const FromRow, FromCol, ToRow, ToCol: Integer);
    procedure RegisterObserver(const Event: TStateUpdateEvent);

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
  for Row := 0 to 7 do
    for Column := 0 to 7 do
      FBoardMatrix[Row, Column] := nil;

  FBoardMatrix[0, 0] := TPieceFactory.New(ptRook, pcBlack);
  FBoardMatrix[0, 1] := TPieceFactory.New(ptKnight, pcBlack);
  FBoardMatrix[0, 2] := TPieceFactory.New(ptBishop, pcBlack);
  FBoardMatrix[0, 3] := TPieceFactory.New(ptQueen, pcBlack);
  FBoardMatrix[0, 4] := TPieceFactory.New(ptKing, pcBlack);
  FBoardMatrix[0, 5] := TPieceFactory.New(ptBishop, pcBlack);
  FBoardMatrix[0, 6] := TPieceFactory.New(ptKnight, pcBlack);
  FBoardMatrix[0, 7] := TPieceFactory.New(ptRook, pcBlack);

  for Column := 0 to 7 do
  begin
    FBoardMatrix[1, Column] := TPieceFactory.New(ptPawn, pcBlack);
    FBoardMatrix[1, Column].Coordinates := TPoint.Create(Column, 1);

    FBoardMatrix[0, Column].Coordinates := TPoint.Create(Column, 0);
  end;

  FBoardMatrix[7, 0] := TPieceFactory.New(ptRook, pcWhite);
  FBoardMatrix[7, 1] := TPieceFactory.New(ptKnight, pcWhite);
  FBoardMatrix[7, 2] := TPieceFactory.New(ptBishop, pcWhite);
  FBoardMatrix[7, 3] := TPieceFactory.New(ptQueen, pcWhite);
  FBoardMatrix[7, 4] := TPieceFactory.New(ptKing, pcWhite);
  FBoardMatrix[7, 5] := TPieceFactory.New(ptBishop, pcWhite);
  FBoardMatrix[7, 6] := TPieceFactory.New(ptKnight, pcWhite);
  FBoardMatrix[7, 7] := TPieceFactory.New(ptRook, pcWhite);

  for Column := 0 to 7 do
  begin
    FBoardMatrix[6, Column] := TPieceFactory.New(ptPawn, pcWhite);
    FBoardMatrix[6, Column].Coordinates := TPoint.Create(Column, 6);

    FBoardMatrix[7, Column].Coordinates := TPoint.Create(Column, 7);
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

function TBoardState.GetPieceAt(const Row, Col: Integer): IPiece;
begin
  Result := FBoardMatrix[Row, Col];
end;

procedure TBoardState.SetPieceAt(const Row, Col: Integer; const Value: IPiece);
begin
  FBoardMatrix[Row, Col] := Value;
end;

procedure TBoardState.MovePiece(const FromRow, FromCol, ToRow, ToCol: Integer);
begin
  FBoardMatrix[ToRow, ToCol] := FBoardMatrix[FromRow, FromCol];
  FBoardMatrix[FromRow, FromCol] := nil;

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

