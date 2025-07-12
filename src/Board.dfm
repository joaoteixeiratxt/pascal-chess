object BoardView: TBoardView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  ClientHeight = 781
  ClientWidth = 560
  Color = clBtnFace
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
  TextHeight = 15
  object pnlOpponent: TPanel
    Left = 0
    Top = 0
    Width = 560
    Height = 79
    Align = alTop
    TabOrder = 0
    object pnlOpponentTime: TPanel
      Left = 480
      Top = 1
      Width = 79
      Height = 77
      Align = alRight
      TabOrder = 0
    end
    object pnlOpponentName: TPanel
      Left = 80
      Top = 1
      Width = 400
      Height = 77
      Align = alClient
      TabOrder = 1
    end
    object pnlOpponentAvatar: TPanel
      Left = 1
      Top = 1
      Width = 79
      Height = 77
      Align = alLeft
      TabOrder = 2
      object imgOpponentAvatar: TImage
        Left = 1
        Top = 1
        Width = 77
        Height = 75
        Align = alClient
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
    Constraints.MaxHeight = 560
    Constraints.MaxWidth = 560
    Constraints.MinHeight = 560
    Constraints.MinWidth = 560
    TabOrder = 1
  end
  object pnlPlayer: TPanel
    Left = 0
    Top = 639
    Width = 560
    Height = 79
    Align = alBottom
    TabOrder = 2
    object pnlPlayerName: TPanel
      Left = 80
      Top = 1
      Width = 400
      Height = 77
      Align = alClient
      TabOrder = 0
    end
    object pnlPlayerAvatar: TPanel
      Left = 1
      Top = 1
      Width = 79
      Height = 77
      Align = alLeft
      TabOrder = 1
      object imgPlayerAvatar: TImage
        Left = 1
        Top = 1
        Width = 77
        Height = 75
        Align = alClient
        ExplicitLeft = 24
        ExplicitTop = 32
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object pnlPlayerTime: TPanel
      Left = 480
      Top = 1
      Width = 79
      Height = 77
      Align = alRight
      TabOrder = 2
    end
  end
  object pnlControls: TPanel
    Left = 0
    Top = 718
    Width = 560
    Height = 63
    Align = alBottom
    TabOrder = 3
    object pnlNext: TPanel
      Left = 419
      Top = 1
      Width = 140
      Height = 61
      Align = alRight
      TabOrder = 0
    end
    object pnlExit: TPanel
      Left = -1
      Top = 1
      Width = 140
      Height = 61
      Align = alRight
      TabOrder = 1
    end
    object pnlMessages: TPanel
      Left = 139
      Top = 1
      Width = 140
      Height = 61
      Align = alRight
      TabOrder = 2
    end
    object pnlPrevious: TPanel
      Left = 279
      Top = 1
      Width = 140
      Height = 61
      Align = alRight
      TabOrder = 3
    end
  end
end
