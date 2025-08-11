unit LobbyView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, ImageLoader, ChessBoardView, RoomController;

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
    pnlWaitingPlayers: TPanel;
    lblPlayers: TLabel;
    lstPlayers: TListBox;
    pnlHideScroll: TPanel;
    edtRoomName: TEdit;
    pnlCancelRoom: TPanel;
    imgCancelRoom: TImage;
    lblCancelRoom: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblEnterClick(Sender: TObject);
    procedure lblCancelRoomClick(Sender: TObject);
    procedure cbbRoomsDropDown(Sender: TObject);
  private
    FLoading: Boolean;
    FRoleAdmin: Boolean;
    FWaitingForPlayes: Boolean;
    procedure TogglePanels;
    procedure SetRolePanel;
    procedure StartGame;
  end;

var
  frmLobbyView: TfrmLobbyView;

implementation

{$R *.dfm}

procedure TfrmLobbyView.cbbRoomsDropDown(Sender: TObject);
var
  Rooms: TStringList;
begin
  cbbRooms.Items.Clear();

  Rooms := TStringList.Create();
  try
    TRoomController.GetRooms(Rooms);
    cbbRooms.Items.Assign(Rooms);
  finally
    Rooms.Free;
  end;
end;

procedure TfrmLobbyView.FormCreate(Sender: TObject);
begin
  FLoading := False;
  FRoleAdmin := False;
  FWaitingForPlayes := False;
  
  TImageLoader.LoadGIF('Loading', imgLoading);
  
  SetRolePanel();
end;

procedure TfrmLobbyView.StartGame;
begin
  Self.Visible := False;
  try
    TBoardView.StartGame();
  finally
    Self.Visible := True;
  end;
end;

procedure TfrmLobbyView.SetRolePanel;
var
  Param, Role: string;
begin
  if ParamCount = 0 then
    Exit;

  Param := ParamStr(1);

  if not Param.Contains('/role') then
    Exit;

  Role := Param.Split([':'])[1];

  if not (Role = 'admin') then
    Exit;

  FRoleAdmin := True;
    
  lblRooms.Caption := 'Insira um nome para a sala:';
  lblEnter.Caption := 'Criar sala';
  edtRoomName.BringToFront();
end;

procedure TfrmLobbyView.lblEnterClick(Sender: TObject);
begin
  if FRoleAdmin then
  begin
    if FWaitingForPlayes then
      StartGame()
    else
      TRoomController.CreateRoom(edtRoomName.Text, edtPlayerName.Text);

    FWaitingForPlayes := True;
  end
  else
  begin
    TRoomController.Enter(cbbRooms.Text);
  end;

  TogglePanels();
end;

procedure TfrmLobbyView.lblCancelRoomClick(Sender: TObject);
begin
  if FRoleAdmin then
  begin
    FWaitingForPlayes := False;
    TRoomController.DeleteRoom(edtRoomName.Text);
  end;

  TogglePanels();
end;

procedure TfrmLobbyView.TogglePanels;
begin
  if FRoleAdmin then
  begin
    if FWaitingForPlayes then
    begin
      pnlWaitingPlayers.BringToFront();
      lblEnter.Caption := 'Começar';
      pnlCancelRoom.Visible := True;
    end
    else
    begin
      pnlPlayerInfo.BringToFront();
      lblEnter.Caption := 'Criar sala';
      pnlCancelRoom.Visible := False;
    end;

    Exit;
  end;

  FLoading := not FLoading;

  if FLoading then
  begin
    pnlLoading.BringToFront();
    lblEnter.Caption := 'Cancelar';
  end
  else
  begin
    pnlLoading.SendToBack();
    lblEnter.Caption := 'Entrar';
  end;
end;

end.
