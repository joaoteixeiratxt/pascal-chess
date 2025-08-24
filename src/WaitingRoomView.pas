unit WaitingRoomView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, ImageLoader;

type
  TfrmWaitingRoomView = class(TForm)
    lblTitle: TLabel;
    pnlCancel: TPanel;
    imgCancel: TImage;
    lblCancel: TLabel;
    imgLoading: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    class procedure ShowView;
  end;

var
  frmWaitingRoomView: TfrmWaitingRoomView;

implementation

{$R *.dfm}

{ TfrmWaitingRoomView }

procedure TfrmWaitingRoomView.FormCreate(Sender: TObject);
begin
  TImageLoader.LoadGIF('Loading', imgLoading);
end;

class procedure TfrmWaitingRoomView.ShowView;
var
  View: TfrmWaitingRoomView;
begin
  View := TfrmWaitingRoomView.Create(nil);
  try
    View.ShowModal();
  finally
    View.Free;
  end;
end;

end.
