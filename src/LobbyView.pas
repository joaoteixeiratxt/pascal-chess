unit LobbyView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, PlayerLobbyView, AdminLobbyView;

type
  TfrmLobbyView = class(TForm)
    imgLogo: TImage;
    pnlPlay: TPanel;
    imgPlay: TImage;
    lblPlay: TLabel;
    pnlCreateRoom: TPanel;
    imgCreateRoom: TImage;
    lblCreateRoom: TLabel;
    procedure lblPlayClick(Sender: TObject);
    procedure lblCreateRoomClick(Sender: TObject);
  end;

var
  frmLobbyView: TfrmLobbyView;

implementation

{$R *.dfm}

procedure TfrmLobbyView.lblPlayClick(Sender: TObject);
begin
  Self.Hide();
  try
    TfrmPlayerLobbyView.ShowView();
  finally
    Self.Show();
    Self.BringToFront();
    Self.SetFocus();
  end;
end;

procedure TfrmLobbyView.lblCreateRoomClick(Sender: TObject);
begin
  Self.Hide();
  try
    TfrmAdminLobbyView.ShowView();
  finally
    Self.Show();
    Self.BringToFront();
    Self.SetFocus();
  end;
end;

end.
