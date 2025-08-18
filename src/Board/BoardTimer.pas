unit BoardTimer;

interface

uses
  System.Classes, System.SysUtils, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TTimeExpiredEvent = procedure of object;

  TBoardTimer = class
  private
    FLabel: TLabel;
    FTimer: TTimer;
    FTimeRemaining: Integer;
    FOnTimeExpired: TTimeExpiredEvent;
    procedure OnTimer(Sender: TObject);
    procedure UpdateLabel;
  public
    constructor Create(Seconds: Integer; ALabel: TLabel; AOnTimeExpired: TTimeExpiredEvent);
    destructor Destroy; override;
    procedure Play;
    procedure Pause;
    property OnTimeExpired: TTimeExpiredEvent read FOnTimeExpired write FOnTimeExpired;
  end;

implementation

const
  INTERVAL = 1000;

{ TBoardTimer }

constructor TBoardTimer.Create(Seconds: Integer; ALabel: TLabel; AOnTimeExpired: TTimeExpiredEvent);
begin
  FLabel := ALabel;
  FTimeRemaining := Seconds;
  FOnTimeExpired := AOnTimeExpired;

  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := OnTimer;
  FTimer.Enabled := False;
  FTimer.Interval := INTERVAL;

  UpdateLabel();
end;

destructor TBoardTimer.Destroy;
begin
  FTimer.Enabled := False;
  FreeAndNil(Ftimer);
  inherited;
end;

procedure TBoardTimer.OnTimer(Sender: TObject);
begin
  Dec(FTimeRemaining);
  UpdateLabel();

  if FTimeRemaining <= 0 then
  begin
    FTimer.Enabled := False;
    if Assigned(FOnTimeExpired) then
      FOnTimeExpired();
  end;
end;

procedure TBoardTimer.Play;
begin
  UpdateLabel();
  FTimer.Enabled := True;
end;

procedure TBoardTimer.Pause;
begin
  UpdateLabel();
  FTimer.Enabled := False;
end;

procedure TBoardTimer.UpdateLabel;
var
  Min, Secs: Integer;
begin
  Min := FTimeRemaining div 60;
  Secs := FTimeRemaining mod 60;

  FLabel.Caption := Format('%.2d:%.2d', [Min, Secs]);
end;

end.
