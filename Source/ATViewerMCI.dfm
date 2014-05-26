object MediaFrame: TMediaFrame
  Left = 0
  Top = 0
  Width = 424
  Height = 253
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 216
    Width = 424
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 97
      Top = 0
      Width = 327
      Height = 37
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object TrackBar1: TTrackBar
        Left = 0
        Top = 0
        Width = 327
        Height = 37
        Align = alClient
        PageSize = 10
        TabOrder = 0
        OnChange = TrackBar1Change
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 97
      Height = 37
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object P: TMediaPlayer
        Left = 8
        Top = 3
        Width = 85
        Height = 30
        VisibleButtons = [btPlay, btPause, btStop]
        Display = Panel2
        TabOrder = 0
        OnNotify = PNotify
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 424
    Height = 216
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 296
    Top = 144
  end
end
