program PictureConvertor;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Main},
  PictureConvertor.Form.Methods in 'PictureConvertor.Form.Methods.pas',
  PictureConvertor.Picture.Methods in 'PictureConvertor.Picture.Methods.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
