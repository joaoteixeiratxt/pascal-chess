unit ColorUtils;

interface

uses
  System.Classes, Winapi.Windows, System.StrUtils,
  System.SysUtils, Vcl.Controls, Vcl.Graphics;

type
  TColorUtils = class
  private
    class var FToggle: Boolean;
  public
    class function ToggleColor: Boolean;
    class function HexToColor(HexString: string): TColor; static;
  end;

implementation

{ TColorUtils }

class function TColorUtils.HexToColor(HexString: string): TColor;
begin
  Result :=
   RGB(
     StrToInt('$'+Copy(HexString, 1, 2)),
     StrToInt('$'+Copy(HexString, 3, 2)),
     StrToInt('$'+Copy(HexString, 5, 2))
   ) ;
end;

class function TColorUtils.ToggleColor: Boolean;
begin
  Result := FToggle;
  FToggle := not FToggle;
end;

end.
