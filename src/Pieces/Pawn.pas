unit Pawn;

interface

uses
  System.Classes, System.Types, BoardPiece, PieceBase;

type
  TPawn = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TPawnStrategy = class(TStrategyBase)
  public
    function GetLegalMoves: TLegalMoves; override;
  end;

implementation

{ TPawn }

constructor TPawn.Create;
begin
  inherited Create(Color);

  FPieceType := ptPawn;
  SetStrategy(TPawnStrategy.Create());
end;

{ TPawnStrategy }

function TPawnStrategy.GetLegalMoves: TLegalMoves;
var
  Piece: IPiece;
  Point: TPoint;
  Indice, Y: Integer;
begin
  inherited;

  Y := FCoordinates.Y + 1;

  if (Y >= 0) and (Y <= 7) then
  begin
    Point := TPoint.Create(FCoordinates.X, Y);
    Piece := FState.GetPieceAt(Point);

    if (not Assigned(Piece)) then
    begin
      Indice := Length(Result);
      SetLength(Result, Indice + 1);

      Result[Indice] := TPoint.Create(FCoordinates.X, Y);
    end;
  end;

  if FCoordinates.Y = 1 then
  begin
    Y := FCoordinates.Y + 2;

    if Y <= 7 then
    begin
      Point := TPoint.Create(FCoordinates.X, Y);
      Piece := FState.GetPieceAt(Point);

      if (not Assigned(Piece)) then
      begin
        Indice := Length(Result);
        SetLength(Result, Indice + 1);

        Result[Indice] := TPoint.Create(FCoordinates.X, Y);
      end;
    end;
  end;

  if (FCoordinates.X - 1 >= 0) and (FCoordinates.Y + 1 <= 7) then
  begin
    Point := TPoint.Create(FCoordinates.X - 1, FCoordinates.Y + 1);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
    begin
      Indice := Length(Result);
      SetLength(Result, Indice + 1);
      Result[Indice] := Point;
    end;
  end;

  if (FCoordinates.X + 1 <= 7) and (FCoordinates.Y + 1 <= 7) then
  begin
    Point := TPoint.Create(FCoordinates.X + 1, FCoordinates.Y + 1);
    Piece := FState.GetPieceAt(Point);

    if Assigned(Piece) and (Piece.Color <> FState.CurrentPlayerColor) then
    begin
      Indice := Length(Result);
      SetLength(Result, Indice + 1);
      Result[Indice] := Point;
    end;
  end;
end;

end.
