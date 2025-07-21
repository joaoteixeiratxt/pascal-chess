unit Pawn;

interface

uses
  System.Classes, System.Types, BoardPiece;

type
  TPawn = class(TPieceBase)
  public
    constructor Create(Color: TPieceColor); override;
  end;

  TPawnStrategy = class(TInterfacedObject, IStrategy)
  private
    FCoordinates: TPoint;
  public
    procedure SetCoordinates(const Value: TPoint);
    function GetLegalMoves: TLegalMoves;
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

procedure TPawnStrategy.SetCoordinates(const Value: TPoint);
begin
  FCoordinates := Value;
end;

function TPawnStrategy.GetLegalMoves: TLegalMoves;
var
  Indice, Y: Integer;
begin
  Y := FCoordinates.Y + 1;

  if (Y >= 0) and (Y <= 7) then
  begin
    Indice := Length(Result);
    SetLength(Result, Indice + 1);

    Result[Indice] := TPoint.Create(FCoordinates.X, Y);
  end;

  if FCoordinates.Y = 1 then
  begin
    Y := FCoordinates.Y + 2;

    if Y <= 7 then
    begin
      Indice := Length(Result);
      SetLength(Result, Indice + 1);

      Result[Indice] := TPoint.Create(FCoordinates.X, Y);
    end;
  end;

  if (FCoordinates.X - 1 >= 0) and (FCoordinates.Y + 1 <= 7) then
  begin
    Indice := Length(Result);
    SetLength(Result, Indice + 1);

    Result[Indice] := TPoint.Create(FCoordinates.X - 1, FCoordinates.Y + 1);
  end;

  if (FCoordinates.X + 1 <= 7) and (FCoordinates.Y + 1 <= 7) then
  begin
    Indice := Length(Result);
    SetLength(Result, Indice + 1);

    Result[Indice] := TPoint.Create(FCoordinates.X + 1, FCoordinates.Y + 1);
  end;
end;

end.
