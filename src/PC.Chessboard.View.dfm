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
    object pnlExit: TPanel
      Left = 0
      Top = 0
      Width = 560
      Height = 63
      Align = alClient
      BevelOuter = bvNone
      Color = 2829872
      ParentBackground = False
      TabOrder = 0
      ExplicitWidth = 140
      object imgExit: TImage
        Left = 0
        Top = 0
        Width = 560
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
        OnClick = imgExitClick
        ExplicitLeft = 80
        ExplicitTop = 16
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
  end
end
