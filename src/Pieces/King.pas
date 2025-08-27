unit King;

interface

uses
  System.Classes, System.Types, PC.Piece, PC.State, PieceBase;

type
  TKing = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TKingStrategy = class(TStrategyBase)
  private
    function IsSquareAttacked(const Target: TPoint): Boolean;
  public
    function GetLegalMoves: TLegalMoves; override;
  end;

implementation

{ TKing }

constructor TKing.Create;
begin
  inherited Create(Color);

  FPieceType := ptKing;
  SetStrategy(TKingStrategy.Create());
end;

{ TKingStrategy }

function TKingStrategy.GetLegalMoves: TLegalMoves;
const
  MOV_X: array[0..7] of Integer = ( -1, 0, 1, -1, 1, -1, 0, 1 );
  MOV_Y: array[0..7] of Integer = ( -1, -1, -1, 0, 0, 1, 1, 1 );
var
  Point: TPoint;
  Piece, Rook: IPiece;
  I, X, Y, Indice, Col: Integer;
begin
  inherited;

  for I := 0 to 7 do
  begin
    X := FCoordinates.X + MOV_X[I];
    Y := FCoordinates.Y + MOV_Y[I];

    if (X >= 0) and (X <= 7) and (Y >= 0) and (Y <= 7) then
    begin
      Point := TPoint.Create(X, Y);
      Piece := FState.GetPieceAt(Point);

      if Assigned(Piece) and (Piece.Color = FState.CurrentPlayerColor) then
        Continue;

      Indice := Length(Result);
      SetLength(Result, Indice + 1);
      Result[Indice] := Point;
    end;
  end;

  Piece := FState.GetPieceAt(FCoordinates);
  if not Piece.HasMoved and not IsSquareAttacked(FCoordinates) then
  begin
    // Kingside castling
    Rook := nil;
    for Col := FCoordinates.X + 1 to 7 do
    begin
      if Assigned(FMatrix[Col, FCoordinates.Y]) then
      begin
        Rook := FMatrix[Col, FCoordinates.Y];
        Break;
      end;
    end;

    if Assigned(Rook) and (Rook.PieceType = ptRook) and (Rook.Color = FCurrentPlayerColor) and not Rook.HasMoved then
      if (FMatrix[FCoordinates.X + 1, FCoordinates.Y] = nil) and
         (FMatrix[FCoordinates.X + 2, FCoordinates.Y] = nil) and
         not IsSquareAttacked(TPoint.Create(FCoordinates.X + 1, FCoordinates.Y)) and
         not IsSquareAttacked(TPoint.Create(FCoordinates.X + 2, FCoordinates.Y)) then
      begin
        Indice := Length(Result);
        SetLength(Result, Indice + 1);
        Result[Indice] := TPoint.Create(FCoordinates.X + 2, FCoordinates.Y);
      end;

    // Queenside castling
    Rook := nil;
    for Col := FCoordinates.X - 1 downto 0 do
    begin
      if Assigned(FMatrix[Col, FCoordinates.Y]) then
      begin
        Rook := FMatrix[Col, FCoordinates.Y];
        Break;
      end;
    end;

    if Assigned(Rook) and (Rook.PieceType = ptRook) and (Rook.Color = FCurrentPlayerColor) and not Rook.HasMoved then
      if (FMatrix[FCoordinates.X - 1, FCoordinates.Y] = nil) and
         (FMatrix[FCoordinates.X - 2, FCoordinates.Y] = nil) and
         not IsSquareAttacked(TPoint.Create(FCoordinates.X - 1, FCoordinates.Y)) and
         not IsSquareAttacked(TPoint.Create(FCoordinates.X - 2, FCoordinates.Y)) then
      begin
        Indice := Length(Result);
        SetLength(Result, Indice + 1);
        Result[Indice] := TPoint.Create(FCoordinates.X - 2, FCoordinates.Y);
      end;
  end;
end;

function TKingStrategy.IsSquareAttacked(const Target: TPoint): Boolean;
const
  KNIGHT_MOVES: array[0..7] of TPoint = (
    (X: -2; Y: -1), (X: -2; Y: 1), (X: -1; Y: -2), (X: -1; Y: 2),
    (X:  1; Y: -2), (X:  1; Y: 2), (X:  2; Y: -1), (X:  2; Y: 1)
  );
var
  DX, DY, NX, NY, J: Integer;
  OpponentPiece: IPiece;
begin
  // Rooks and queens
  for DX := -1 to 1 do
    if DX <> 0 then
    begin
      NX := Target.X + DX;
      while (NX >= 0) and (NX <= 7) do
      begin
        OpponentPiece := FMatrix[NX, Target.Y];
        if Assigned(OpponentPiece) then
        begin
          if (OpponentPiece.Color <> FCurrentPlayerColor) and
             ((OpponentPiece.PieceType = ptRook) or (OpponentPiece.PieceType = ptQueen)) then
            Exit(True);
          Break;
        end;
        NX := NX + DX;
      end;
    end;

  for DY := -1 to 1 do
    if DY <> 0 then
    begin
      NY := Target.Y + DY;
      while (NY >= 0) and (NY <= 7) do
      begin
        OpponentPiece := FMatrix[Target.X, NY];
        if Assigned(OpponentPiece) then
        begin
          if (OpponentPiece.Color <> FCurrentPlayerColor) and
             ((OpponentPiece.PieceType = ptRook) or (OpponentPiece.PieceType = ptQueen)) then
            Exit(True);
          Break;
        end;
        NY := NY + DY;
      end;
    end;

  // Bishops and queens
  for DX := -1 to 1 do
    for DY := -1 to 1 do
      if (DX <> 0) and (DY <> 0) then
      begin
        NX := Target.X + DX;
        NY := Target.Y + DY;
        while (NX >= 0) and (NX <= 7) and (NY >= 0) and (NY <= 7) do
        begin
          OpponentPiece := FMatrix[NX, NY];
          if Assigned(OpponentPiece) then
          begin
            if (OpponentPiece.Color <> FCurrentPlayerColor) and
               ((OpponentPiece.PieceType = ptBishop) or (OpponentPiece.PieceType = ptQueen)) then
              Exit(True);
            Break;
          end;
          NX := NX + DX;
          NY := NY + DY;
        end;
      end;

  // Knights
  for J := 0 to 7 do
  begin
    NX := Target.X + KNIGHT_MOVES[J].X;
    NY := Target.Y + KNIGHT_MOVES[J].Y;
    if (NX >= 0) and (NX <= 7) and (NY >= 0) and (NY <= 7) then
    begin
      OpponentPiece := FMatrix[NX, NY];
      if Assigned(OpponentPiece) and (OpponentPiece.Color <> FCurrentPlayerColor) and (OpponentPiece.PieceType = ptKnight) then
        Exit(True);
    end;
  end;

  // Pawns
  for DX := -1 to 1 do
    if DX <> 0 then
    begin
      NX := Target.X + DX;
      NY := Target.Y - 1;
      if (NX >= 0) and (NX <= 7) and (NY >= 0) then
      begin
        OpponentPiece := FMatrix[NX, NY];
        if Assigned(OpponentPiece) and (OpponentPiece.Color <> FCurrentPlayerColor) and (OpponentPiece.PieceType = ptPawn) then
          Exit(True);
      end;
      NY := Target.Y + 1;
      if (NX >= 0) and (NX <= 7) and (NY <= 7) then
      begin
        OpponentPiece := FMatrix[NX, NY];
        if Assigned(OpponentPiece) and (OpponentPiece.Color <> FCurrentPlayerColor) and (OpponentPiece.PieceType = ptPawn) then
          Exit(True);
      end;
    end;

  // Kings
  for DX := -1 to 1 do
    for DY := -1 to 1 do
      if not ((DX = 0) and (DY = 0)) then
      begin
        NX := Target.X + DX;
        NY := Target.Y + DY;
        if (NX >= 0) and (NX <= 7) and (NY >= 0) and (NY <= 7) then
        begin
          OpponentPiece := FMatrix[NX, NY];
          if Assigned(OpponentPiece) and (OpponentPiece.Color <> FCurrentPlayerColor) and (OpponentPiece.PieceType = ptKing) then
            Exit(True);
        end;
      end;

  Result := False;
end;

end.
