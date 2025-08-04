unit BoardTimer;

interface

uses
  System.Classes, System.SysUtils, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TBoardTimer = class
  private
    FLabel: TLabel;
    FTimer: TTimer;
    FTimeRemaining: Integer;
    procedure OnTimer(Sender: TObject);
    procedure UpdateLabel;
  public
    constructor Create(Seconds: Integer; ALabel: TLabel);
    destructor Destroy; override;
    procedure Play;
    procedure Pause;
  end;

implementation

const
  INTERVAL = 1000;

{ TBoardTimer }

constructor TBoardTimer.Create(Seconds: Integer; ALabel: TLabel);
begin
  FLabel := ALabel;
  FTimeRemaining := Seconds;

  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := OnTimer;
  FTimer.Enabled := False;
  FTimer.Interval := INTERVAL;

  UpdateLabel();
end;

destructor TBoardTimer.Destroy;
begin
  FreeAndNil(Ftimer);
  inherited;
end;

procedure TBoardTimer.OnTimer(Sender: TObject);
begin
  Dec(FTimeRemaining);
  UpdateLabel();

  FTimer.Enabled := (FTimeRemaining > 0);
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
