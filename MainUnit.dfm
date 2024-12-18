object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MainForm'
  ClientHeight = 497
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object WhoPlayLabel: TLabel
    Left = 216
    Top = 64
    Width = 118
    Height = 15
    Caption = #1048#1075#1088#1072#1077#1090' '#1087#1077#1088#1074#1099#1081' '#1080#1075#1088#1086#1082
  end
  object StringGridUser2: TStringGrid
    Left = 176
    Top = 104
    Width = 281
    Height = 281
    ColCount = 11
    DefaultColWidth = 24
    RowCount = 11
    ScrollBars = ssNone
    TabOrder = 1
    Visible = False
    OnKeyDown = StringGridUser2KeyDown
  end
  object CoordEdit: TEdit
    Left = 256
    Top = 391
    Width = 121
    Height = 23
    TabOrder = 2
    TextHint = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099
    Visible = False
    OnChange = CoordEditChange
    OnKeyDown = CoordEditKeyDown
  end
  object StringGridUser1: TStringGrid
    Left = 176
    Top = 104
    Width = 281
    Height = 281
    ColCount = 11
    DefaultColWidth = 24
    RowCount = 11
    ScrollBars = ssNone
    TabOrder = 0
    OnKeyDown = StringGridUser1KeyDown
  end
  object ShootButton: TButton
    Left = 280
    Top = 432
    Width = 75
    Height = 25
    Caption = 'ShootButton'
    TabOrder = 3
    Visible = False
    OnClick = ShootButtonClick
  end
  object MainMenu: TMainMenu
    Left = 544
    Top = 32
    object FileButtons: TMenuItem
      Caption = #1060#1072#1081#1083
      object OpenFile1Button: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' 1 '#1080#1075#1088#1086#1082#1072
        OnClick = OpenFile1ButtonClick
      end
      object OpenFile2Button: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083' 2 '#1080#1075#1088#1086#1082#1072
        OnClick = OpenFile2ButtonClick
      end
    end
  end
  object OpenTextFileDialog: TOpenTextFileDialog
    Left = 608
    Top = 32
  end
end
