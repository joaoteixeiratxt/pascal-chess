unit PC.Player.Lobby.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, ImageLoader, ColorUtils, RoomController, PC.Player,
  PC.WaitingRoom.View;

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
    TimerRooms: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure lblNextClick(Sender: TObject);
    procedure lblPreviousClick(Sender: TObject);
    procedure lblPlayClick(Sender: TObject);
    procedure TimerRoomsTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FAvatarIndex: Integer;
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
  FAvatarIndex := 0;
  LoadAvatar();
end;

procedure TfrmPlayerLobbyView.lblPlayClick(Sender: TObject);
var
  Player: IBoardPlayer;
begin
  Self.Hide();
  try
    TimerRooms.Enabled := False;
    try
      Player := TBoardPlayer.Create(edtPlayerName.Text, FAvatarIndex);

      TRoomController.Enter(Player,cbbRoom.Text);

      TfrmWaitingRoomView.ShowView();

      cbbRoom.Text := '';
    finally
      TimerRooms.Enabled := True;
    end;
  finally
    Self.Show();
  end;
end;

procedure TfrmPlayerLobbyView.FormShow(Sender: TObject);
begin
  TimerRooms.Enabled := True;
end;

procedure TfrmPlayerLobbyView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerRooms.Enabled := False;
end;

procedure TfrmPlayerLobbyView.lblNextClick(Sender: TObject);
begin
  if (FAvatarIndex + 1) >= AVATARS_COUNT then
    Exit;

  Inc(FAvatarIndex);
  LoadAvatar();
end;

procedure TfrmPlayerLobbyView.lblPreviousClick(Sender: TObject);
begin
  if (FAvatarIndex - 1) < 0 then
    Exit;

  Dec(FAvatarIndex);
  LoadAvatar();
end;

procedure TfrmPlayerLobbyView.LoadAvatar;
begin
  TImageLoader.Load(('a' + FAvatarIndex.ToString), imgAvatar);
  imgAvatar.Repaint();

  if FAvatarIndex = Pred(AVATARS_COUNT) then
    lblNext.Font.Color := clGray
  else
    lblNext.Font.Color := DEFAULT_COLOR;

  if FAvatarIndex = 0 then
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

procedure TfrmPlayerLobbyView.TimerRoomsTimer(Sender: TObject);
var
  CurrentRoom: string;
  Rooms: TStringList;
begin
  Rooms := TStringList.Create();
  try
    TRoomController.GetRooms(Rooms);

    CurrentRoom := cbbRoom.Text;

    if cbbRoom.Items.Text <> Rooms.Text then
      cbbRoom.Items.Assign(Rooms);

    cbbRoom.Text := CurrentRoom;
  finally
    Rooms.Free;
  end;
end;

end.
