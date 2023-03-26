{*******************************************************}
{                                                       }
{                  PictureConvertor                     }
{                                                       }
{                    Form Methods                       }
{  - separates logic from main form to different Unit   }
{                                                       }
{*******************************************************}

unit PictureConvertor.Form.Methods;

interface

uses
  System.IOUtils,
  System.SysUtils,
  System.UITypes,

  Vcl.StdCtrls,
  Vcl.Dialogs,
  Vcl.ComCtrls,

  PictureConvertor.Picture.Types,
  PictureConvertor.Picture.Thread;

type
  TPictureConvertorFormMethods = class(TObject)
  private
    FProjectLocation: String;

    FProgressBar: TProgressBar;
    FStartButton: TButton;

    FPictureThread: TPictureConvertorPictureThread;

  public
    constructor Create;

    /// <summary> Will start Thread (converts files and move them) </summary>
    /// <param name="ARecursive"> Search through folder tree
    ///  (if false, then will load files only from selected source folder) </param>
    /// <param name="ASquash"> Only if ARecursive is set to True.
    ///  Squash all files to one folder
    ///  (if false, then will creates folders based on source) </param>
    procedure ExecuteMove(const ASrc, ADest: String; const ARecursive, ASquash: Boolean);

    /// <summary> Sets TEdit Text based on project location </summary>
    procedure SetEdtFolder(AEdit: TEdit; const AText: String);
    /// <summary> Will show Information Dialog with supported extension types </summary>
    procedure GetSupportedExtensions;

    /// <summary> Sets ProgressBar for Thread </summary>
    procedure SetProgressBar(AProgressBar: TProgressBar);
    /// <summary> Sets StartButton for Thread </summary>
    procedure SetStartButton(AStartButton: TButton);
  end;

implementation

resourcestring
  RSupportedExtensions = 'Supported extensions are: ';

constructor TPictureConvertorFormMethods.Create;
begin
  // Get project location for base folder paths
  FProjectLocation := ExtractFilePath(ParamStr(0));
end;

procedure TPictureConvertorFormMethods.ExecuteMove(const ASrc, ADest: String; const ARecursive, ASquash: Boolean);
begin
  // Converting and moving files is in separate Thread
  // Thread will Terminate after Execution
  FPictureThread := TPictureConvertorPictureThread.Create(ASrc, ADest, ARecursive, ASquash, True);
  FPictureThread.SetStartButton(FStartButton);
  FPictureThread.SetProgressBar(FProgressBar);

  FPictureThread.Start;
  FPictureThread.FreeOnTerminate := True;
end;

procedure TPictureConvertorFormMethods.SetEdtFolder(AEdit: TEdit; const AText: String);
begin
  AEdit.Text := TPath.Combine(FProjectLocation, AText);
end;

procedure TPictureConvertorFormMethods.GetSupportedExtensions;

  function GetExtensions: String;
  var
    Extensions: String;

  begin
    Extensions := '';

    // Get File extensions from TPictureTypes
    for var I := 0 to Length(TPictureTypes.Extensions) - 1 do
    begin
      Extensions := Extensions + TPictureTypes.Extensions[I] + sLineBreak;
    end;

    Result := Extensions;
  end;

begin
  MessageDlg(RSupportedExtensions + sLineBreak + sLineBreak + GetExtensions, mtInformation,
    [mbOk], 0, mbOk);
end;

procedure TPictureConvertorFormMethods.SetProgressBar(AProgressBar: TProgressBar);
begin
  FProgressBar := AProgressBar;
end;

procedure TPictureConvertorFormMethods.SetStartButton(AStartButton: TButton);
begin
  FStartButton := AStartButton;
end;

end.
