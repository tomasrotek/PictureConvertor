unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PictureConvertor.Form.Methods, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TMain = class(TForm)
    btnChooseSrcFolder: TButton;
    edtSrcFolder: TEdit;
    edtDestFolder: TEdit;
    btnChooseDestFolder: TButton;
    chbRecursive: TCheckBox;
    lblSrcFolder: TLabel;
    lblDestFolder: TLabel;
    btnMove: TButton;
    chbSquash: TCheckBox;
    btnSupportedExtensions: TButton;
    pbLoading: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnChooseSrcFolderClick(Sender: TObject);
    procedure btnChooseDestFolderClick(Sender: TObject);
    procedure chbRecursiveClick(Sender: TObject);
    procedure btnSupportedExtensionsClick(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);

  private
    { Private declarations }
    // There are some functions for TForm
    FFormMethods: TPictureConvertorFormMethods;

    /// <summary> Sets folder paths based on project location </summary>
    procedure SetBaseFolders;

  public
    { Public declarations }
    /// <summary> Will open choose folder dialog </summary>
    /// <param name="AEdit"> Based on Dialog result will fill this TEdit </param>
    procedure OpenChooseDirDialog(AEdit: TEdit);
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

procedure TMain.btnChooseDestFolderClick(Sender: TObject);
begin
  OpenChooseDirDialog(edtDestFolder);
end;

procedure TMain.btnChooseSrcFolderClick(Sender: TObject);
begin
  OpenChooseDirDialog(edtSrcFolder);
end;

procedure TMain.btnMoveClick(Sender: TObject);
begin
  FFormMethods.ExecuteMove(edtSrcFolder.Text, edtDestFolder.Text, chbRecursive.Checked, chbSquash.Checked);
end;

procedure TMain.btnSupportedExtensionsClick(Sender: TObject);
begin
  FFormMethods.GetSupportedExtensions;
end;

procedure TMain.chbRecursiveClick(Sender: TObject);
begin
  // Recursive is useful only, when you are searching through multiple folders
  if chbRecursive.Checked then
  begin
    chbSquash.Enabled := True;
    chbSquash.Checked := False;
  end
  else
  begin
    chbSquash.Enabled := False;
    chbSquash.Checked := False;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  // Useful for debugging
  // ReportMemoryLeaksOnShutdown := True;

  pbLoading.Hide;

  FFormMethods := TPictureConvertorFormMethods.Create;

  // You need to give TFormMethods TProgressBar reference (for hide/show by Thread)
  FFormMethods.SetProgressBar(pbLoading);
  FFormMethods.SetStartButton(btnMove);

  SetBaseFolders;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  FFormMethods.Free;
end;

procedure TMain.SetBaseFolders;
begin
  FFormMethods.SetEdtFolder(edtSrcFolder, 'src');
  FFormMethods.SetEdtFolder(edtDestFolder, 'dest');
end;

procedure TMain.OpenChooseDirDialog(AEdit: TEdit);
begin
  with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
      AEdit.Text := FileName;

  finally
    Free;
  end;
end;

end.
