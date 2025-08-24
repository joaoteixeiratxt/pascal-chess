unit CheckMateView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, BoardPiece, ImageLoader;

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
    procedure FormShow(Sender: TObject);
  private
    FWinnerColor: TPieceColor;
  public
    property WinnerColor: TPieceColor read FWinnerColor write FWinnerColor;
  end;

  TCheckMateView = class
  public
    class procedure ShowView(WinnerColor: TPieceColor); static;
  end;

implementation

{$R *.dfm}

procedure TfrmCheckMateView.FormShow(Sender: TObject);
var
  KingPiece: IPiece;
begin
  KingPiece := TPieceFactory.New(ptKing, WinnerColor);
  TImageLoader.Load(KingPiece.ImageName, imgPiece);

  case WinnerColor of
    pcBlack: lblWinner.Caption := 'Pretas vencem';
    pcWhite: lblWinner.Caption := 'Brancas vencem';
    pcNull: lblWinner.Caption := '';
  end;
end;

procedure TfrmCheckMateView.lblExitClick(Sender: TObject);
begin
  Close;
end;

{ TCheckMateView }

class procedure TCheckMateView.ShowView(WinnerColor: TPieceColor);
var
  View: TfrmCheckMateView;
begin
  View := TfrmCheckMateView.Create(nil);
  try
    View.WinnerColor := WinnerColor;
    View.ShowModal();
  finally
    View.Free;
  end;
end;

end.
