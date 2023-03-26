object Main: TMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'PictureConvertor'
  ClientHeight = 277
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblSrcFolder: TLabel
    Left = 8
    Top = 32
    Width = 68
    Height = 13
    Caption = 'Source folder:'
  end
  object lblDestFolder: TLabel
    Left = 8
    Top = 90
    Width = 67
    Height = 13
    Caption = 'Target folder:'
  end
  object btnChooseSrcFolder: TButton
    Left = 527
    Top = 45
    Width = 66
    Height = 25
    Caption = 'Choose'
    TabOrder = 0
    OnClick = btnChooseSrcFolderClick
  end
  object edtSrcFolder: TEdit
    Left = 8
    Top = 51
    Width = 513
    Height = 21
    TabOrder = 1
  end
  object edtDestFolder: TEdit
    Left = 8
    Top = 109
    Width = 513
    Height = 21
    TabOrder = 2
  end
  object btnChooseDestFolder: TButton
    Left = 527
    Top = 107
    Width = 66
    Height = 25
    Caption = 'Choose'
    TabOrder = 3
    OnClick = btnChooseDestFolderClick
  end
  object chbRecursive: TCheckBox
    Left = 8
    Top = 154
    Width = 97
    Height = 17
    Caption = 'Load recursive'
    TabOrder = 4
    OnClick = chbRecursiveClick
  end
  object btnMove: TButton
    Left = 488
    Top = 201
    Width = 105
    Height = 59
    Caption = 'Move files'
    TabOrder = 5
    OnClick = btnMoveClick
  end
  object chbSquash: TCheckBox
    Left = 8
    Top = 184
    Width = 97
    Height = 17
    Caption = 'Squash folders'
    Enabled = False
    TabOrder = 6
  end
  object btnSupportedExtensions: TButton
    Left = 8
    Top = 235
    Width = 137
    Height = 25
    Caption = 'Supported extensions ?'
    TabOrder = 7
    OnClick = btnSupportedExtensionsClick
  end
  object pbLoading: TProgressBar
    Left = 240
    Top = 218
    Width = 225
    Height = 25
    ParentShowHint = False
    Smooth = True
    Style = pbstMarquee
    MarqueeInterval = 1
    Step = 1
    ShowHint = True
    TabOrder = 8
  end
end
