unit AdminLobbyView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, ImageLoader, ColorUtils, WaitingPlayersView;

type
  TfrmAdminLobbyView = class(TForm)
    pnlPrevious: TPanel;
    imgPrevious: TImage;
    lblPrevious: TLabel;
    pnlNext: TPanel;
    imgNext: TImage;
    lblNext: TLabel;
    pnlAvatar: TPanel;
    imgBackground: TImage;
    lblTitle: TLabel;
    imgAvatar: TImage;
    pnlPlay: TPanel;
    imgPlay: TImage;
    lblPlay: TLabel;
    edtPlayerName: TEdit;
    lblPlayerName: TLabel;
    lblRoomName: TLabel;
    edtRoomName: TEdit;
    pnl1Min: TPanel;
    img1Min: TImage;
    lbl1Min: TLabel;
    lblGameTime: TLabel;
    pnl3min: TPanel;
    img3min: TImage;
    lbl3min: TLabel;
    pnl5min: TPanel;
    img5min: TImage;
    lbl5min: TLabel;
    pnl10Min: TPanel;
    img10Min: TImage;
    lbl10Min: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblNextClick(Sender: TObject);
    procedure lblPreviousClick(Sender: TObject);
    procedure TimeClick(Sender: TObject);
    procedure lblPlayClick(Sender: TObject);
  private
    FIndex: Integer;
    procedure LoadAvatar;
  public
    class procedure ShowView;
  end;

var
  frmAdminLobbyView: TfrmAdminLobbyView;

implementation

{$R *.dfm}

procedure TfrmAdminLobbyView.FormCreate(Sender: TObject);
begin
  FIndex := 0;
  LoadAvatar();
  TimeClick(lbl1Min);
end;

procedure TfrmAdminLobbyView.lblPlayClick(Sender: TObject);
begin
  Self.Hide();
  try
    TfrmWaitingPlayersView.ShowView();
  finally
    Self.Show();
  end;
end;

procedure TfrmAdminLobbyView.lblNextClick(Sender: TObject);
begin
  if (FIndex + 1) >= AVATARS_COUNT then
    Exit;

  Inc(FIndex);
  LoadAvatar();
end;

procedure TfrmAdminLobbyView.lblPreviousClick(Sender: TObject);
begin
  if (FIndex - 1) < 0 then
    Exit;

  Dec(FIndex);
  LoadAvatar();
end;

procedure TfrmAdminLobbyView.LoadAvatar;
begin
  TImageLoader.Load(('a' + FIndex.ToString), imgAvatar);
  imgAvatar.Repaint();

  if FIndex = Pred(AVATARS_COUNT) then
    lblNext.Font.Color := clGray
  else
    lblNext.Font.Color := DEFAULT_COLOR;

  if FIndex = 0 then
    lblPrevious.Font.Color := clGray
  else
    lblPrevious.Font.Color := DEFAULT_COLOR;
end;

procedure TfrmAdminLobbyView.TimeClick(Sender: TObject);
begin
  lbl1Min.Font.Color := DEFAULT_COLOR;
  lbl3Min.Font.Color := DEFAULT_COLOR;
  lbl5Min.Font.Color := DEFAULT_COLOR;
  lbl10Min.Font.Color := DEFAULT_COLOR;

  TLabel(Sender).Font.Color := clGray;
end;

class procedure TfrmAdminLobbyView.ShowView;
var
  View: TfrmAdminLobbyView;
begin
  View := TfrmAdminLobbyView.Create(nil);
  try
    View.ShowModal();
  finally
    View.Free;
  end;
end;

end.
