unit PlayerLobbyView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, ImageLoader, ColorUtils;

type
  TfrmPlayerLobbyView = class(TForm)
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
    Label1: TLabel;
    cbbRoom: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure lblNextClick(Sender: TObject);
    procedure lblPreviousClick(Sender: TObject);
  private
    FIndex: Integer;
    procedure LoadAvatar;
  public
    class procedure ShowView;
  end;

var
  frmPlayerLobbyView: TfrmPlayerLobbyView;

implementation

{$R *.dfm}

procedure TfrmPlayerLobbyView.FormCreate(Sender: TObject);
begin
  FIndex := 0;
  LoadAvatar();
end;

procedure TfrmPlayerLobbyView.lblNextClick(Sender: TObject);
begin
  if (FIndex + 1) >= AVATARS_COUNT then
    Exit;

  Inc(FIndex);
  LoadAvatar();
end;

procedure TfrmPlayerLobbyView.lblPreviousClick(Sender: TObject);
begin
  if (FIndex - 1) < 0 then
    Exit;

  Dec(FIndex);
  LoadAvatar();
end;

procedure TfrmPlayerLobbyView.LoadAvatar;
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

class procedure TfrmPlayerLobbyView.ShowView;
var
  View: TfrmPlayerLobbyView;
begin
  View := TfrmPlayerLobbyView.Create(nil);
  try
    View.ShowModal();
  finally
    View.Free;
  end;
end;

end.
