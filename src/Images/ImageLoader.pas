unit ImageLoader;

interface

uses
  System.Classes, System.Types, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.GIFImg;

const
  AVATARS_COUNT = 5;

type
  TImageLoader = class
  public
    class procedure Load(ImageName: string; Image: TImage);
    class procedure LoadGIF(GifName: string; Image: TImage);
  end;

implementation

{$R ./Icons/Icons.RES}
{$R ./Avatars/Avatars.RES}

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

class procedure TImageLoader.LoadGIF(GifName: string; Image: TImage);
var
  GIF: TGIFImage;
  ResStream: TResourceStream;
begin
  ResStream := TResourceStream.Create(HInstance, GifName, RT_RCDATA);
  try
    GIF := TGIFImage.Create;
    try
      GIF.LoadFromStream(ResStream);
      GIF.Animate := True;
      GIF.AnimationSpeed := 100;
      Image.Picture.Assign(GIF);
    finally
      GIF.Free;
    end;
  finally
    ResStream.Free;
  end;
end;

end.
