unit PC.State;

interface

uses
  System.Classes, System.Types, System.SysUtils, System.Generics.Collections,
  System.JSON, System.IOUtils, PC.Piece, PC.Player;

const
  BOARD_ROWS = 8;
  BOARD_COLUMNS = 8;

type
  TPieceMatrix = array[0..7, 0..7] of IPiece;

  IState = interface
  ['{984AB04C-D208-47A0-8A1C-71634201AB3B}']
    procedure Initialize;
    function GetPieceMatrix: TPieceMatrix;
    function GetSelectedPiece: IPiece;
    procedure SetSelectedPiece(const Value: IPiece);
    function GetCurrentPlayerColor: TPieceColor;
    procedure SetCurrentPlayerColor(const Value: TPieceColor);
    function GetCurrentTurnColor: TPieceColor;
    function GetPlayerID: string;
    procedure SetPlayerID(const Value: string);
    function GetOpponentColor: TPieceColor;
    procedure SetOpponentColor(const Value: TPieceColor);
    function GetPieceAt(const Coordinates: TPoint): IPiece;
    procedure MovePiece(const FromCoordinates, ToCoordinates: TPoint);
    function IsInCheck(Color: TPieceColor): Boolean;
    function IsCheckMate(Color: TPieceColor): Boolean;
    function MoveLeavesKingInCheck(const FromCoordinates, ToCoordinates: TPoint; const Color: TPieceColor): Boolean;
    property SelectedPiece: IPiece read GetSelectedPiece write SetSelectedPiece;
    property CurrentPlayerColor: TPieceColor read GetCurrentPlayerColor write SetCurrentPlayerColor;
    property CurrentTurnColor: TPieceColor read GetCurrentTurnColor;
    property OpponentColor: TPieceColor read GetOpponentColor write SetOpponentColor;
    function ToJSON: TJSONObject;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

  TState = class(TInterfacedObject, IState)
  private
    FBoardMatrix: TPieceMatrix;
    FSelectedPiece: IPiece;
    FCurrentPlayerColor: TPieceColor;
    FCurrentTurnColor: TPieceColor;
    FPlayerID: string;
    FOpponentColor: TPieceColor;
    function GetSelectedPiece: IPiece;
    procedure SetSelectedPiece(const Value: IPiece);
    function GetCurrentPlayerColor: TPieceColor;
    procedure SetCurrentPlayerColor(const Value: TPieceColor);
    function GetCurrentTurnColor: TPieceColor;
    procedure SetCurrentTurnColor;
    procedure Clear;
    procedure CreatePieces(Color: TPieceColor);
    function GetPlayerID: string;
    procedure SetPlayerID(const Value: string);
    function GetOpponentColor: TPieceColor;
    procedure SetOpponentColor(const Value: TPieceColor);
    function FindKingPosition(Color: TPieceColor): TPoint;
  public
    constructor Create;
    procedure Initialize;
    function GetPieceMatrix: TPieceMatrix;
    function GetPieceAt(const Coordinates: TPoint): IPiece;
    procedure MovePiece(const FromCoordinates, ToCoordinates: TPoint);
    function IsInCheck(Color: TPieceColor): Boolean;
    function IsCheckMate(Color: TPieceColor): Boolean;
    function MoveLeavesKingInCheck(const FromCoordinates, ToCoordinates: TPoint; const Color: TPieceColor): Boolean;
    property SelectedPiece: IPiece read GetSelectedPiece write SetSelectedPiece;
    property CurrentPlayerColor: TPieceColor read GetCurrentPlayerColor write SetCurrentPlayerColor;
    property CurrentTurnColor: TPieceColor read GetCurrentTurnColor;
    property OpponentColor: TPieceColor read GetOpponentColor write SetOpponentColor;
    function ToJSON: TJSONObject;
    procedure LoadFromJSON(const JSON: TJSONObject);
  end;

implementation

uses
  PC.Room.Controller, Dialogs;

{ TState }

constructor TState.Create;
begin
  FCurrentPlayerColor := pcWhite;
  FOpponentColor := pcBlack;
  FCurrentTurnColor := pcWhite;
end;

procedure TState.Clear;
var
  Row, Column: Integer;
begin
  for Column := Pred(BOARD_COLUMNS) downto 0 do
    for Row := 0 to Pred(BOARD_ROWS) do
      FBoardMatrix[Column, Row] := nil;
end;

procedure TState.CreatePieces(Color: TPieceColor);
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

procedure TState.Initialize;
begin
  Clear();
  CreatePieces(pcWhite);
  CreatePieces(pcBlack);
end;

function TState.GetSelectedPiece: IPiece;
begin
  Result := FSelectedPiece;
end;

procedure TState.SetSelectedPiece(const Value: IPiece);
begin
  FSelectedPiece := Value;
end;

function TState.GetPieceMatrix: TPieceMatrix;
begin
  Result := FBoardMatrix;
end;

function TState.GetCurrentPlayerColor: TPieceColor;
begin
  Result := FCurrentPlayerColor;
end;

procedure TState.SetCurrentPlayerColor(const Value: TPieceColor);
begin
  FCurrentPlayerColor := Value;
end;

function TState.GetCurrentTurnColor: TPieceColor;
begin
  Result := FCurrentTurnColor;
end;

procedure TState.SetCurrentTurnColor;
var
  Player: IPlayer;
  NextPlayersBlackPiece: TPlayerList;
begin
  if FCurrentTurnColor = pcWhite then
    FCurrentTurnColor := pcBlack
  else
    FCurrentTurnColor := pcWhite;

  if FCurrentPlayerColor = pcBlack then
    Exit;

  NextPlayersBlackPiece := TRoomController.Current.NextPlayersBlackPiece;

  if (NextPlayersBlackPiece.Count = 1) then
    Exit;

  Player := NextPlayersBlackPiece[0];
  NextPlayersBlackPiece.Delete(0);
  NextPlayersBlackPiece.Add(Player);
end;

function TState.GetPlayerID: string;
begin
  Result := FPlayerID;
end;

procedure TState.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

function TState.GetOpponentColor: TPieceColor;
begin
  Result := FOpponentColor;
end;

procedure TState.SetOpponentColor(const Value: TPieceColor);
begin
  FOpponentColor := Value;
end;

function TState.GetPieceAt(const Coordinates: TPoint): IPiece;
begin
  Result := FBoardMatrix[Coordinates.X, Coordinates.Y];
end;

function TState.FindKingPosition(Color: TPieceColor): TPoint;
var
  Row, Column: Integer;
  Piece: IPiece;
begin
  Result := TPoint.Create(-1, -1);
  for Column := 0 to Pred(BOARD_COLUMNS) do
    for Row := 0 to Pred(BOARD_ROWS) do
    begin
      Piece := FBoardMatrix[Column, Row];
      if Assigned(Piece) and (Piece.PieceType = ptKing) and (Piece.Color = Color) then
        Exit(TPoint.Create(Column, Row));
    end;
end;

function TState.MoveLeavesKingInCheck(const FromCoordinates, ToCoordinates: TPoint; const Color: TPieceColor): Boolean;
var
  Piece, Captured: IPiece;
  OriginalFrom, OriginalTo: TPoint;
begin
  Piece := FBoardMatrix[FromCoordinates.X, FromCoordinates.Y];
  Captured := FBoardMatrix[ToCoordinates.X, ToCoordinates.Y];

  OriginalFrom := FromCoordinates;
  OriginalTo := ToCoordinates;

  FBoardMatrix[OriginalTo.X, OriginalTo.Y] := Piece;
  FBoardMatrix[OriginalFrom.X, OriginalFrom.Y] := nil;
  Piece.Coordinates := OriginalTo;

  Result := IsInCheck(Color);

  Piece.Coordinates := OriginalFrom;
  FBoardMatrix[OriginalFrom.X, OriginalFrom.Y] := Piece;
  FBoardMatrix[OriginalTo.X, OriginalTo.Y] := Captured;
end;

function TState.IsInCheck(Color: TPieceColor): Boolean;
var
  KingPos, Move: TPoint;
  Row, Column: Integer;
  Piece: IPiece;
  OpponentColor, SaveColor: TPieceColor;
  Moves: TLegalMoves;
begin
  KingPos := FindKingPosition(Color);
  if (KingPos.X = -1) or (KingPos.Y = -1) then
    Exit(False);

  if Color = pcWhite then
    OpponentColor := pcBlack
  else
    OpponentColor := pcWhite;

  SaveColor := FCurrentPlayerColor;
  for Column := 0 to Pred(BOARD_COLUMNS) do
    for Row := 0 to Pred(BOARD_ROWS) do
    begin
      Piece := FBoardMatrix[Column, Row];
      if Assigned(Piece) and (Piece.Color = OpponentColor) then
      begin
        FCurrentPlayerColor := OpponentColor;
        Moves := Piece.GetPseudoLegalMoves();
        for Move in Moves do
          if (Move.X = KingPos.X) and (Move.Y = KingPos.Y) then
          begin
            FCurrentPlayerColor := SaveColor;
            Exit(True);
          end;
      end;
    end;
  FCurrentPlayerColor := SaveColor;
  Result := False;
end;

function TState.IsCheckMate(Color: TPieceColor): Boolean;
var
  Row, Column: Integer;
  Piece: IPiece;
  Moves: TLegalMoves;
  SaveColor: TPieceColor;
begin
  if not IsInCheck(Color) then
    Exit(False);

  SaveColor := FCurrentPlayerColor;
  FCurrentPlayerColor := Color;
  for Column := 0 to Pred(BOARD_COLUMNS) do
    for Row := 0 to Pred(BOARD_ROWS) do
    begin
      Piece := FBoardMatrix[Column, Row];
      if Assigned(Piece) and (Piece.Color = Color) then
      begin
        Moves := Piece.GetLegalMoves();
        if Length(Moves) > 0 then
        begin
          FCurrentPlayerColor := SaveColor;
          Exit(False);
        end;
      end;
    end;
  FCurrentPlayerColor := SaveColor;
  Result := True;
end;

procedure TState.MovePiece(const FromCoordinates, ToCoordinates: TPoint);
var
  Piece, Rook: IPiece;
  RookFrom, RookTo: TPoint;
begin
  Piece := FBoardMatrix[FromCoordinates.X, FromCoordinates.Y];

  if (Piece.PieceType = ptKing) and
     ((ToCoordinates.X = FromCoordinates.X + 2) or (ToCoordinates.X = FromCoordinates.X - 2)) then
  begin
    if ToCoordinates.X > FromCoordinates.X then
    begin
      RookFrom := TPoint.Create(7, FromCoordinates.Y);
      RookTo := TPoint.Create(ToCoordinates.X - 1, FromCoordinates.Y);
    end
    else
    begin
      RookFrom := TPoint.Create(0, FromCoordinates.Y);
      RookTo := TPoint.Create(ToCoordinates.X + 1, FromCoordinates.Y);
    end;

    Rook := FBoardMatrix[RookFrom.X, RookFrom.Y];
    if Assigned(Rook) then
    begin
      FBoardMatrix[RookTo.X, RookTo.Y] := Rook;
      FBoardMatrix[RookTo.X, RookTo.Y].Coordinates := RookTo;
      FBoardMatrix[RookTo.X, RookTo.Y].HasMoved := True;
      FBoardMatrix[RookFrom.X, RookFrom.Y] := nil;
    end;
  end;

  FBoardMatrix[ToCoordinates.X, ToCoordinates.Y] := Piece;
  FBoardMatrix[ToCoordinates.X, ToCoordinates.Y].Coordinates := TPoint.Create(ToCoordinates.X, ToCoordinates.Y);
  FBoardMatrix[ToCoordinates.X, ToCoordinates.Y].HasMoved := True;
  FBoardMatrix[FromCoordinates.X, FromCoordinates.Y] := nil;

  SetCurrentTurnColor();
  TRoomController.Current.Push();
  TRoomController.Current.Update();
end;

function TState.ToJSON: TJSONObject;
var
  Point: TPoint;
  Piece: IPiece;
  Column, Row: Integer;
  PiecesArray: TJSONArray;
begin
  Result := TJSONObject.Create();

  Result.AddPair('currentTurnColor',TJSONNumber.Create(Integer(Self.CurrentTurnColor)));

  PiecesArray := TJSONArray.Create();
  Result.AddPair('pieces', PiecesArray);

  for Column := 0 to Pred(BOARD_COLUMNS) do
  begin
    for Row := 0 to Pred(BOARD_ROWS) do
    begin
      Point := TPoint.Create(Column, Row);
      Piece := GetPieceAt(Point);

      if not Assigned(Piece) then
        Continue;

      PiecesArray.Add(Piece.ToJSON());
    end;
  end;
end;

procedure TState.LoadFromJSON(const JSON: TJSONObject);
var
  I: Integer;
  Piece: IPiece;
  PieceType: TPieceType;
  PieceColor: TPieceColor;
  PieceInfo: TJSONObject;
  PiecesArray: TJSONArray;
begin
  Clear();

  FCurrentTurnColor := TPieceColor(JSON.GetValue<Integer>('currentTurnColor'));
  PiecesArray := JSON.GetValue<TJSONArray>('pieces');

  for I := 0 to Pred(PiecesArray.Count) do
  begin
    PieceInfo := TJSONObject(PiecesArray.Items[I]);

    PieceType := TPieceType(PieceInfo.GetValue<Integer>('type'));
    PieceColor := TPieceColor(PieceInfo.GetValue<Integer>('color'));

    Piece := TPieceFactory.New(PieceType, PieceColor);
    Piece.LoadFromJSON(PieceInfo);

    FBoardMatrix[Piece.Coordinates.X, Piece.Coordinates.Y] := Piece;
  end;
end;

end.

