unit PC.Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, PC.Player.Lobby.View, PC.Admin.Lobby.View;

type
  TfrmMainView = class(TForm)
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
  frmMainView: TfrmMainView;

implementation

{$R *.dfm}

procedure TfrmMainView.lblPlayClick(Sender: TObject);
begin
  TfrmPlayerLobbyView.ShowView();
end;

procedure TfrmMainView.lblCreateRoomClick(Sender: TObject);
begin
  TfrmAdminLobbyView.ShowView();
end;

end.
