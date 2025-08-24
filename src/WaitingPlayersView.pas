unit WaitingPlayersView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, RoomController, BoardPlayer, ChessBoardView, BoardPiece;

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
    TimerWaitingPlayers: TTimer;
    procedure TimerWaitingPlayersTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblPlayClick(Sender: TObject);
    procedure lblCancelClick(Sender: TObject);
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

procedure TfrmWaitingPlayersView.lblPlayClick(Sender: TObject);
begin
  if (lstPlayers.Count = 1) then
    Exit;

  TimerWaitingPlayers.Enabled := False;

  TRoomController.Current.Started := True;
  TRoomController.Current.Push();

  Self.Hide();
  try
    TBoardView.StartGame();
  finally
    Self.Close();
  end;
end;

procedure TfrmWaitingPlayersView.lblCancelClick(Sender: TObject);
begin
  TimerWaitingPlayers.Enabled := False;

  TRoomController.Current.Started := False;
  TRoomController.Current.Push();

  TRoomController.DeleteRoom(TRoomController.Current.Name);

  Self.Close();
end;

procedure TfrmWaitingPlayersView.FormShow(Sender: TObject);
begin
  TimerWaitingPlayers.Enabled := True;
end;

procedure TfrmWaitingPlayersView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerWaitingPlayers.Enabled := False;
end;

procedure TfrmWaitingPlayersView.TimerWaitingPlayersTimer(Sender: TObject);
var
  Player: IBoardPlayer;
begin
  TRoomController.Current.Pull();

  lstPlayers.Clear();

  for Player in TRoomController.Current.Players do
    lstPlayers.Items.Add(Player.Name);
end;

end.
