unit BoardBuilder;

interface

uses
  System.Classes, System.Types, System.SysUtils, Vcl.ExtCtrls,
  Vcl.Controls;

type
  TRowBuilder = class
  public
    class function Build(const BoardPanel: TPanel): TPanel; static;
  end;

  TSquareBuilder = class
  public
    class function Build(const RowPanel: TPanel): TPanel; static;
  end;

  TSquareImageBuilder = class
  public
    class procedure Build(const SquarePanel: TPanel); static;
  end;

  IBoardBuilder = interface
  ['{C15DF4E4-4B03-4C73-B7DD-560151028BC9}']
    function Board(BoardPanel: TPanel): IBoardBuilder;
    function Build: IBoardBuilder;
  end;

  TBoardBuilder = class(TInterfacedObject, IBoardBuilder)
  private
    FBoardPanel: TPanel;
  public
    function Board(BoardPanel: TPanel): IBoardBuilder;
    function Build: IBoardBuilder;
  end;

implementation

const
  ROWS = 8;
  COLUMNS = 8;

{ TRowBuilder }

class function TRowBuilder.Build(const BoardPanel: TPanel): TPanel;
begin
  Result := TPanel.Create(BoardPanel);
  Result.Parent := BoardPanel;
  Result.Align := alTop;
  Result.Width := BoardPanel.Width;
  Result.Height := Trunc(BoardPanel.Height / ROWS);
end;

{ TSquareBuilder }

class function TSquareBuilder.Build(const RowPanel: TPanel): TPanel;
begin
  Result := TPanel.Create(RowPanel);
  Result.Parent := RowPanel;
  Result.Align := alLeft;
  Result.Width := Trunc(RowPanel.Width / COLUMNS);

  TSquareImageBuilder.Build(Result);
end;

{ TSquareImageBuilder }

class procedure TSquareImageBuilder.Build(const SquarePanel: TPanel);
var
  SquareImage: TImage;
begin
  SquareImage := TImage.Create(SquarePanel);
  SquareImage.Parent := SquarePanel;
  SquareImage.Align := alClient;
  SquareImage.Cursor := crHandPoint;
end;

{ TBoardBuilder }

function TBoardBuilder.Board(BoardPanel: TPanel): IBoardBuilder;
begin
  FBoardPanel := BoardPanel;
  Result := Self;
end;

function TBoardBuilder.Build: IBoardBuilder;
var
  I, J: Integer;
  RowPanel: TPanel;
begin
  for I := 1 to ROWS do
  begin
    RowPanel := TRowBuilder.Build(FBoardPanel);

    for J := 1 to COLUMNS do
      TSquareBuilder.Build(RowPanel);
  end;
end;

end.
