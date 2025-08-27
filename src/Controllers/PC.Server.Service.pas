unit PC.Server.Service;

interface

uses
  System.Classes, System.SysUtils, System.JSON, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Generics.Collections, HttpClient.IndyFacade, PC.Room.Controller;

type
  TOnErrorCallback = TProc<ExceptClass>;

  IServerService = interface
  ['{6B6A01E0-8138-4F06-BCCA-83B67F3F59CE}']
    procedure Start;
    procedure Finalize;
  end;

  TServerService = class(TInterfacedObject, IServerService)
  private
    FRoom: IRoom;
    FTimer: TTimer;
    FOnError: TOnErrorCallback;
    FHashRoom: string;
    FHttpClient: IHttpClient;
    procedure OnTimer(Sender: TObject);
  public
    constructor Create(const Room: IRoom; const OnError: TOnErrorCallback);
    destructor Destroy; override;
    procedure Start;
    procedure Finalize;
  end;

implementation

{ TServerService }

constructor TServerService.Create(const Room: IRoom; const OnError: TOnErrorCallback);
begin
  FRoom := Room;
  FOnError := OnError;
  FHttpClient := NewIndyHttpClient();

  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 1000;
  FTimer.OnTimer := OnTimer;
end;

destructor TServerService.Destroy;
begin
  FTimer.Enabled := False;
  FreeAndNil(Ftimer);
  FHttpClient := nil;
  inherited;
end;

procedure TServerService.OnTimer(Sender: TObject);
var
  Hash: string;
  NewRoom: IRoom;
  JSONRoom: TJSONObject;
begin
  NewRoom := TRoomController.GetRoom(FRoom.Name);

  if not Assigned(NewRoom) then
  begin
    FTimer.Enabled := False;

    if Assigned(FOnError) then
      FOnError(EDeletedRoom);

    Exit;
  end;

  JSONRoom := TJSONObject(TJSONObject.ParseJSONValue(NewRoom.ToJSON()));
  try
    Hash := JSONRoom.ToString();

    if Hash <> FHashRoom then
    begin
      FRoom.LoadFromJSON(JSONRoom);
      FHashRoom := Hash;

      FRoom.Update();
    end;
  finally
    if Assigned(JSONRoom) then
      JSONRoom.Free;
  end;
end;

procedure TServerService.Start;
begin
  FTimer.Enabled := True;
end;

procedure TServerService.Finalize;
begin
  FTimer.Enabled := False;
end;

end.
