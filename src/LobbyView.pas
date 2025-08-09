unit LobbyView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, ImageLoader;

type
  TfrmLobbyView = class(TForm)
    imgLogo: TImage;
    pnlEnter: TPanel;
    imgEnter: TImage;
    lblEnter: TLabel;
    pnlPlayerInfo: TPanel;
    lblPlayerName: TLabel;
    lblRooms: TLabel;
    cbbRooms: TComboBox;
    edtPlayerName: TEdit;
    pnlLoading: TPanel;
    imgLoading: TImage;
    procedure FormCreate(Sender: TObject);
    procedure lblEnterClick(Sender: TObject);
  private
    FLoading: Boolean;
    procedure ToggleLoading;
  end;

var
  frmLobbyView: TfrmLobbyView;

implementation

{$R *.dfm}

procedure TfrmLobbyView.FormCreate(Sender: TObject);
begin
  FLoading := False;
  TImageLoader.LoadGIF('Loading', imgLoading);
end;

procedure TfrmLobbyView.lblEnterClick(Sender: TObject);
begin
  ToggleLoading();
end;

procedure TfrmLobbyView.ToggleLoading;
begin
  FLoading := not FLoading;

  if FLoading then
  begin
    pnlLoading.BringToFront();
    pnlPlayerInfo.SendToBack();
    lblEnter.Caption := 'Cancelar';
  end
  else
  begin
    pnlLoading.SendToBack();
    pnlPlayerInfo.BringToFront();
    lblEnter.Caption := 'Entrar';
  end;
end;

end.
