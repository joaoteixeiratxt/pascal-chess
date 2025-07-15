unit ColorUtils;

interface

uses
  System.Classes, Winapi.Windows, System.StrUtils,
  System.SysUtils, Vcl.Controls, Vcl.Graphics;

type
  TColorUtils = class
  public
    class function HexToColor(HexString: string): TColor;
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

end.
