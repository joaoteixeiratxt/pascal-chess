object BoardView: TBoardView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  ClientHeight = 781
  ClientWidth = 560
  Color = 2829872
  Constraints.MaxHeight = 820
  Constraints.MaxWidth = 576
  Constraints.MinHeight = 820
  Constraints.MinWidth = 576
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlOpponent: TPanel
    Left = 0
    Top = 0
    Width = 560
    Height = 79
    Align = alTop
    BevelOuter = bvNone
    Color = 2829872
    ParentBackground = False
    TabOrder = 0
    object pnlOpponentTime: TPanel
      Left = 481
      Top = 0
      Width = 79
      Height = 79
      Align = alRight
      BevelOuter = bvNone
      Color = 2829872
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object lblOpponentTimer: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 79
        Align = alClient
        Alignment = taCenter
        Caption = '00:00'
        Layout = tlCenter
        ExplicitWidth = 40
        ExplicitHeight = 21
      end
    end
    object pnlOpponentName: TPanel
      Left = 79
      Top = 0
      Width = 402
      Height = 79
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Color = 2829872
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      object lblOpponentName: TLabel
        Left = 6
        Top = 30
        Width = 4
        Height = 17
      end
    end
    object pnlOpponentAvatar: TPanel
      Left = 0
      Top = 0
      Width = 79
      Height = 79
      Align = alLeft
      BevelOuter = bvNone
      Color = 2829872
      Padding.Left = 5
      Padding.Top = 5
      Padding.Right = 5
      Padding.Bottom = 5
      ParentBackground = False
      TabOrder = 2
      object imgOpponentAvatar: TImage
        Left = 5
        Top = 5
        Width = 69
        Height = 69
        Align = alClient
        Center = True
        Proportional = True
        ExplicitLeft = 24
        ExplicitTop = 24
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
  object pnlBoard: TPanel
    Left = 0
    Top = 79
    Width = 560
    Height = 560
    Align = alClient
    BevelOuter = bvNone
    Color = 2829872
    Constraints.MaxHeight = 560
    Constraints.MaxWidth = 560
    Constraints.MinHeight = 560
    Constraints.MinWidth = 560
    ParentBackground = False
    TabOrder = 1
  end
  object pnlPlayer: TPanel
    Left = 0
    Top = 639
    Width = 560
    Height = 79
    Align = alBottom
    BevelOuter = bvNone
    Color = 2829872
    ParentBackground = False
    TabOrder = 2
    object pnlPlayerName: TPanel
      Left = 79
      Top = 0
      Width = 402
      Height = 79
      Align = alClient
      BevelOuter = bvNone
      Color = 2829872
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object lblPlayerName: TLabel
        Left = 6
        Top = 30
        Width = 4
        Height = 17
      end
    end
    object pnlPlayerAvatar: TPanel
      Left = 0
      Top = 0
      Width = 79
      Height = 79
      Align = alLeft
      BevelOuter = bvNone
      Color = 2829872
      Padding.Left = 5
      Padding.Top = 5
      Padding.Right = 5
      Padding.Bottom = 5
      ParentBackground = False
      TabOrder = 1
      object imgPlayerAvatar: TImage
        Left = 5
        Top = 5
        Width = 69
        Height = 69
        Align = alClient
        Center = True
        Proportional = True
        ExplicitLeft = 24
        ExplicitTop = 32
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object pnlPlayerTime: TPanel
      Left = 481
      Top = 0
      Width = 79
      Height = 79
      Align = alRight
      BevelOuter = bvNone
      Color = 2829872
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      object lblPlayerTimer: TLabel
        Left = 0
        Top = 0
        Width = 79
        Height = 79
        Align = alClient
        Alignment = taCenter
        Caption = '00:00'
        Layout = tlCenter
        ExplicitWidth = 40
        ExplicitHeight = 21
      end
    end
  end
  object pnlControls: TPanel
    Left = 0
    Top = 718
    Width = 560
    Height = 63
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object pnlNext: TPanel
      Left = 420
      Top = 0
      Width = 140
      Height = 63
      Align = alRight
      BevelOuter = bvNone
      Color = 2829872
      ParentBackground = False
      TabOrder = 0
      object imgNext: TImage
        Left = 0
        Top = 0
        Width = 140
        Height = 63
        Cursor = crHandPoint
        Align = alClient
        Center = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000180000
          00180806000000E0773DF8000000017352474200AECE1CE90000011F49444154
          78DA6364A031601C500BFEFFFF2F0CA4E603B13A10A73232321EA2B6051B8094
          3F94FB1BC4065AB29D2A16000DE701529FD1844196F8002DD9452D1F8402A9E5
          40CC8C24FC1388BD8196ECA5D802A8257E406A2D10B32009FF006257A0254728
          B600C99275683EF906C4EE842C213A99022D0901522B819809CD1227A0252729
          B6006A4934905A8CA60F9410F480963CA0D802A82589406A1E9AF04EA0051E54
          B1006A4912909A8B262C0CB4E41D352D9883A65F1468C11B6A04511C905A8826
          7C0168B821C54104343C06482D42D3F705888D8016DCA6C8029A26539A66349A
          161540C3DD80D436065A147640C3B980D40B20E64512A65E710DB40024771388
          55910CA75E8503053240BC1F88E58138001A5C248181ADF4A901002B1B6F1937
          03F5A40000000049454E44AE426082}
        ExplicitLeft = 80
        ExplicitTop = 16
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object pnlExit: TPanel
      Left = 0
      Top = 0
      Width = 140
      Height = 63
      Align = alRight
      BevelOuter = bvNone
      Color = 2829872
      ParentBackground = False
      TabOrder = 1
      object imgExit: TImage
        Left = 0
        Top = 0
        Width = 140
        Height = 63
        Cursor = crHandPoint
        Align = alClient
        Center = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000180000
          00180806000000E0773DF8000000017352474200AECE1CE9000000E549444154
          78DA6364A03160A49B05FFFFFF5F0BA482A0DCA58C8C8C31D4B6E03B90E28072
          3F002D10A4B605FF91C4FF012D601ED216FC055AC0824D03501913906A03E248
          A01A79AAFA00A8441848AD026227B06620A09A0540696320B5018865E09AA965
          01502A1648CD01623614CD1458008E03A010C8C0C9409C46C820348B9703A928
          622C58066447926238D482CF408A8F180BA600D9D96458F00D4871D32A889E02
          F5821CD681CF029A47327D9329921AAA6534628A8A08A01A05AAFA801C40570B
          7E00297628F70BD0025EAA5A0004B5409C09723D104F04E26E6A5B401340730B
          00E2C59719FDBD6AA50000000049454E44AE426082}
        ExplicitLeft = 80
        ExplicitTop = 16
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object pnlMessages: TPanel
      Left = 140
      Top = 0
      Width = 140
      Height = 63
      Align = alRight
      BevelOuter = bvNone
      Color = 2829872
      ParentBackground = False
      TabOrder = 2
      object imgMessages: TImage
        Left = 0
        Top = 0
        Width = 140
        Height = 63
        Cursor = crHandPoint
        Align = alClient
        Center = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000180000
          00180806000000E0773DF8000000017352474200AECE1CE9000001FE49444154
          78DAB5954B28454118C7E7789428A1102529EF949D0D565E61E155EC24B2F128
          0B1B16A4A4143B76AC6C2845A2C48AD8B091F22A45A494951DC2F5FB3A3375DC
          DC7BCEB93753FFBE393367FEBF993933DFB1D43F172B5C672010482014A25874
          6559D65BD4004C8B0813A81AE504753FA2033405ECD61740CF760E0DB8AD8CF2
          ADDF1D07F4E515B04AE8F2B9030B00865D01987712D67C9A9B520F643F240073
          81DCA1DC0801A7002AC2012A8947119A9B5210EAA35B516E8F296D0036F12A25
          5E06039A89DB5102DA31DEC06B8FFA031AE0F9C3004A889751D92B558EE1395E
          17D44BD1AE5ED59B006278B852F68D8DA43C6394854F2AF51765DF7A29A3B4CF
          9B63DA4B588E103084D1221E83D4171CED37B4171B403C41F24C8C4FF32DD48A
          92C5106506F5E71A80ECDB850F63490FB36892597E327E9D7AC71FEFD519C012
          A14F379EA1576527BA3CF53B2FC92AE5484BB2BBD3636708632126D2281F399D
          CA13928B32C2C03D3D50B6AB0CA539667D42FFBBEE97ACBB886AC2ACB44000F2
          D5E5361FBB6546DE8D23B4A07ED4E0B28D72F4CBDC7E385584694793DC990C8F
          DFA99B09AFB8E57D81EC109A3C9A9A22B738490E801740A2B2F7BAC727A404C0
          B52BC001AA55F64993739FE0EC42F7CACE4129A85CB72F01E8F70C7080E450C8
          85CA4672A26E4C62D3FDB29DF23BCD4719BE013E265109F8F007BC1EB8E64AAD
          1BC50000000049454E44AE426082}
        ExplicitLeft = 80
        ExplicitTop = 16
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object pnlPrevious: TPanel
      Left = 280
      Top = 0
      Width = 140
      Height = 63
      Align = alRight
      BevelOuter = bvNone
      Color = 2829872
      ParentBackground = False
      TabOrder = 3
      object imgPrevious: TImage
        Left = 0
        Top = 0
        Width = 140
        Height = 63
        Cursor = crHandPoint
        Align = alClient
        Center = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000180000
          00180806000000E0773DF8000000017352474200AECE1CE90000013F49444154
          78DACD943F4B033118871B4414EB6A3F807412FC02D2A1F807B4A51DECE2509C
          0AFD52A54BC149448B82527771757029CE451CA473D5EB137C8797C0DD457201
          033F7E10B8E7B9E42E31A5C8C3FC4B419224756A405E49DF18332B4C00BC415D
          935599B2925D243FC102E0C7D458C1EDF8245B08BE8304C00FA95BB2A6A617A4
          01FC31688B80EF5377645D4D7F9116F0FBAC677305C06BD4C481DBED38053ECE
          7B3E5320F007B2E1C0CF805FFAAC3E55007C9B7A21653D4DBAC02F7CE07902FB
          E10E9CE973E0235F78AA0078857A77DEBC077CF8177896A04A4DA309446205D5
          285B24821DEA996C3A2B29E6238B24ED37F53A03B90225710F9A3DC59DE083A6
          24F1AE0A25391289BE49ED65D74432091688E484BA7124F3D2EF75BD081688A4
          299215997A02BE57C80AD468932BF246EC4FF051B4C07B44172C018A8672199F
          7A1F120000000049454E44AE426082}
        ExplicitLeft = 80
        ExplicitTop = 16
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
end
