unit ServerController;

interface

uses
  System.Classes, System.SysUtils, System.JSON, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Generics.Collections, HttpClient.IndyFacade, RoomController;

type
  IServerController = interface
  ['{6B6A01E0-8138-4F06-BCCA-83B67F3F59CE}']
    procedure Start;
    procedure Finalize;
  end;

  TServerController = class(TInterfacedObject, IServerController)
  private
    FRoom: IRoom;
    FTimer: TTimer;
    FHttpClient: IHttpClient;
    procedure OnTimer(Sender: TObject);
  public
    constructor Create(const Room: IRoom);
    destructor Destroy; override;
    procedure Start;
    procedure Finalize;
  end;

implementation

{ TServerController }

constructor TServerController.Create(const Room: IRoom);
begin
  FRoom := Room;
  FHttpClient := NewIndyHttpClient();

  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 1000;
  FTimer.OnTimer := OnTimer;
end;

destructor TServerController.Destroy;
begin
  FTimer.Enabled := False;
  FreeAndNil(Ftimer);
  FHttpClient := nil;
  inherited;
end;

procedure TServerController.OnTimer(Sender: TObject);
var
  NewRoom: IRoom;
  JSONRoom: TJSONObject;
begin
  NewRoom := TRoomController.GetRoom(FRoom.Name);

  if NewRoom.HasChanged then
  begin
    JSONRoom := TJSONObject(TJSONObject.ParseJSONValue(NewRoom.ToJSON()));
    try
      FRoom.LoadFromJSON(JSONRoom);
    finally
      if Assigned(JSONRoom) then
        JSONRoom.Free;
    end;
  end;
end;

procedure TServerController.Start;
begin
  FTimer.Enabled := True;
end;

procedure TServerController.Finalize;
begin
  FTimer.Enabled := False;
end;

end.
