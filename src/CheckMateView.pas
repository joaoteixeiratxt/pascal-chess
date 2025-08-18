unit CheckMateView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TfrmCheckMateView = class(TForm)
    imgCheckMate: TImage;
    pnlExit: TPanel;
    imgExit: TImage;
    lblExit: TLabel;
    pnlWinner: TPanel;
    pnlImgPiece: TPanel;
    imgPiece: TImage;
    lblWinner: TLabel;
    shpPiece: TShape;
    pnlView: TPanel;
    procedure lblExitClick(Sender: TObject);
  end;

  TCheckMateView = class
  public
    class procedure Show; static;
  end;

implementation

{$R *.dfm}

procedure TfrmCheckMateView.lblExitClick(Sender: TObject);
begin
  Close;
end;

{ TCheckMateView }

class procedure TCheckMateView.Show;
var
  View: TfrmCheckMateView;
begin
  View := TfrmCheckMateView.Create(nil);
  try
    View.ShowModal();
  finally
    View.Free;
  end;
end;

end.
