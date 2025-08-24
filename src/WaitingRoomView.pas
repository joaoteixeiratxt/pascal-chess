unit WaitingRoomView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, ImageLoader, RoomController, ChessBoardView;

type
  TfrmWaitingRoomView = class(TForm)
    lblTitle: TLabel;
    pnlCancel: TPanel;
    imgCancel: TImage;
    lblCancel: TLabel;
    imgLoading: TImage;
    TimerWaitingRoom: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerWaitingRoomTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TfrmWaitingRoomView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerWaitingRoom.Enabled := False;
end;

procedure TfrmWaitingRoomView.FormShow(Sender: TObject);
begin
  TimerWaitingRoom.Enabled := True;
end;

procedure TfrmWaitingRoomView.lblCancelClick(Sender: TObject);
begin
  Self.Close();
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

procedure TfrmWaitingRoomView.TimerWaitingRoomTimer(Sender: TObject);
begin
  TRoomController.Current.Pull();

  if TRoomController.Current.Started then
  begin
    TimerWaitingRoom.Enabled := False;

    Self.Hide();
    try
      TBoardView.StartGame();
    finally
      Self.Close();
    end;
  end;
end;

end.
