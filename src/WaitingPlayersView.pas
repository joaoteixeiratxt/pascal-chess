unit WaitingPlayersView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TfrmWaitingPlayersView = class(TForm)
    pnlPlay: TPanel;
    imgPlay: TImage;
    lblPlay: TLabel;
    lblTitle: TLabel;
    lstPlayers: TListBox;
    pnlCancel: TPanel;
    imgCancel: TImage;
    lblCancel: TLabel;
  private
    { Private declarations }
  public
    class procedure ShowView;
  end;

var
  frmWaitingPlayersView: TfrmWaitingPlayersView;

implementation

{$R *.dfm}

{ TfrmWaitingPlayersView }

class procedure TfrmWaitingPlayersView.ShowView;
var
  View: TfrmWaitingPlayersView;
begin
  View := TfrmWaitingPlayersView.Create(nil);
  try
    View.ShowModal();
  finally
    View.Free;
  end;
end;

end.
