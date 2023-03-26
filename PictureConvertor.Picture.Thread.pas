{*******************************************************}
{                                                       }
{                  PictureConvertor                     }
{                                                       }
{                   Picture Thread                      }
{   - thread that separates execute from main thread    }
{                                                       }
{*******************************************************}

unit PictureConvertor.Picture.Thread;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,

  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Dialogs,

  PictureConvertor.Picture.Methods;

type
  TPictureConvertorPictureThread = class(TThread)
  private
    FProgressBar: TProgressBar;
    FStartButton: TButton;

    FSrc, FDest: String;
    FRecursive, FSquash: Boolean;

  protected
    procedure Execute; override;

  public
    constructor Create(const ASrc, ADest: String; const ARecursive, ASquash, ACreateSuspended: Boolean);

    // show ProgressBar when execution starts
    procedure SetProgressBar(AProgressBar: TProgressBar);
    // disable button when execution starts
    procedure SetStartButton(AStartButton: TButton);
  end;

implementation

procedure TPictureConvertorPictureThread.Execute;
begin
  if Assigned(FStartButton) then
    FStartButton.Enabled := False;

  // Start ProgressBar
  if Assigned(FProgressBar) then
    Synchronize(FProgressBar.Show);

  with TPictureConvertorPictureMethods.Create do
  try
    try
      MoveFolder(FSrc, FDest, FRecursive, FSquash);

    except
      // MoveFolder could rise errors, so you need to handle them there
      on E : Exception do
      begin
        MessageDlg(E.Message, mtError,
          [mbOk], 0, mbOk);
      end;
    end;

  finally
    Free;

    // Stop ProgressBar
    if Assigned(FProgressBar) then
      Synchronize(FProgressBar.Hide);

    if Assigned(FStartButton) then
      FStartButton.Enabled := True;
  end;
end;

constructor TPictureConvertorPictureThread.Create(const ASrc, ADest: String; const ARecursive, ASquash, ACreateSuspended: Boolean);
begin
  Inherited Create(ACreateSuspended);

  FSrc := ASrc;
  FDest := ADest;
  FRecursive := ARecursive;
  FSquash := ASquash;
end;

procedure TPictureConvertorPictureThread.SetProgressBar(AProgressBar: TProgressBar);
begin
  FProgressBar := AProgressBar;
end;

procedure TPictureConvertorPictureThread.SetStartButton(AStartButton: TButton);
begin
  FStartButton := AStartButton;
end;


end.
