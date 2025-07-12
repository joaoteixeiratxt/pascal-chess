program PascalChess;

uses
  Vcl.Forms,
  Board in 'Board.pas' {BoardView};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBoardView, BoardView);
  Application.Run;
end.
