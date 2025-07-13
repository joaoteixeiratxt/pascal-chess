unit ImageLoader;

interface

uses
  System.Classes, System.Types, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TImageLoader = class
  public
    class procedure Load(ImageName: string; Image: TImage);
  end;

implementation

{$R ./Icons/Icons.RES}

{ TImageLoader }

class procedure TImageLoader.Load(ImageName: string; Image: TImage);
var
  Png: TPngImage;
  ResStream: TResourceStream;
begin
  ResStream := TResourceStream.Create(HInstance, ImageName, RT_RCDATA);
  try
    Png := TPngImage.Create();
    try
      Png.LoadFromStream(ResStream);
      Image.Picture.Graphic := Png;
    finally
      Png.Free;
    end;
  finally
    ResStream.Free;
  end;
end;

end.
