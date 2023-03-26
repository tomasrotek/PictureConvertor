{*******************************************************}
{                                                       }
{                  PictureConvertor                     }
{                                                       }
{                  Picture Methods                      }
{    - backend logic for converting and moving files    }
{                                                       }
{*******************************************************}

unit PictureConvertor.Picture.Methods;

interface

uses
  System.IOUtils,
  System.Types,
  System.SysUtils,
  System.UITypes,

  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,
  Vcl.ExtCtrls,

  PictureConvertor.Picture.Types;

type
  TPictureConvertorPictureMethods = class(TObject)
  private
    // Class responsible for file converting
    FImage: TImage;

  protected
    /// <summary> Based on AFiles will prepare folders in ADest </summary>
    procedure CreateFolders(const AFiles: TStringDynArray; const ASrc, ADest: String);

    /// <summary> Load files (with supported extension) in folder </summary>
    /// <param name="ARecursive"> if True, then search All Directories in ADir </param>
    function GetPicturesInDir(out AFiles: TStringDynArray; const ADir: String; const ARecursive: Boolean): Integer;
    /// <summary> Move pictures from AFiles to ADest </summary>
    /// <param name="ASquash"> if True, then didn't respects folder structure </param>
    procedure MovePicturesToDir(const AFiles: TStringDynArray; const ASrc, ADest: String; const ASquash: Boolean);

  public
    constructor Create;
    destructor Destroy; override;

    /// <summary> Move files from ASrc to ADest folder </summary>
    /// <param name="ARecursive"> Search through folder tree
    ///  (if false, then will load files only from selected source folder) </param>
    /// <param name="ASquash"> Only if ARecursive is set to True.
    ///  Squash all files to one folder
    ///  (if false, then will creates folders based on source) </param>
    procedure MoveFolder(const ASrc, ADest: String; const ARecursive, ASquash: Boolean);
  end;

implementation

resourcestring
  RSrcNotExists = 'A source folder didn''t exists.';
  RSrcNoData = 'A source folder is empty.';
  RDestNotExists = 'A target folder didn''t exists.';
  RDestNotEmpty = 'A target folder must be empty.';

procedure TPictureConvertorPictureMethods.CreateFolders(const AFiles: TStringDynArray; const ASrc, ADest: String);
var
  DirToCreate: String;

begin
  for var I := 0 to Length(AFiles) - 1 do
  begin
    DirToCreate := StringReplace(AFiles[I], ASrc + '\', '', [rfReplaceAll, rfIgnoreCase]);
    DirToCreate := TPath.Combine(ADest, DirToCreate);

    DirToCreate := ExtractFilePath(DirToCreate);

    if not DirectoryExists(DirToCreate) then
      ForceDirectories(DirToCreate);
  end;
end;

function TPictureConvertorPictureMethods.GetPicturesInDir(out AFiles: TStringDynArray; const ADir: String; const ARecursive: Boolean): Integer;

  procedure GetFilesByExtensions(out AFiles: TStringDynArray; const ADir: String; const ASearchOption: TSearchOption);
  var
    LoadedFiles: TStringDynArray;

  begin
    // Load all files with supported extensions
    for var I := 0 to Length(TPictureTypes.Extensions) - 1 do
    begin
      LoadedFiles := TDirectory.GetFiles(ADir, '*.' + TPictureTypes.Extensions[I], ASearchOption);
      AFiles := AFiles + LoadedFiles;
    end;
  end;

begin
  // if ARecursive, then search All Directories in ADir
  if ARecursive then
    GetFilesByExtensions(AFiles, ADir, TSearchOption.soAllDirectories)
  else
    GetFilesByExtensions(AFiles, ADir, TSearchOption.soTopDirectoryOnly);

  Result := Length(AFiles);
end;

procedure TPictureConvertorPictureMethods.MovePicturesToDir(const AFiles: TStringDynArray; const ASrc, ADest: String; const ASquash: Boolean);
var
  SavePath: String;

begin
  SavePath := '';

  for var I := 0 to Length(AFiles) - 1 do
  begin
    // if ASquash than ignore folder structure
    if ASquash then
      SavePath := ExtractFileName(AFiles[I])
    else
      SavePath := StringReplace(AFiles[I], ASrc + '\', '', [rfReplaceAll, rfIgnoreCase]);

    SavePath := ChangeFileExt(SavePath, '.JPEG');
    SavePath := TPath.Combine(ADest, SavePath);

    // Load file
    FImage.Picture.LoadFromFile(AFiles[I]);
    // Save file (makes convert automatically based on SavePath extension)
    FImage.Picture.SaveToFile(SavePath);
  end;
end;

constructor TPictureConvertorPictureMethods.Create;
begin
  inherited Create;

  FImage := TImage.Create(nil);
end;

destructor TPictureConvertorPictureMethods.Destroy;
begin
  FImage.Free;

  inherited Destroy;
end;

procedure TPictureConvertorPictureMethods.MoveFolder(const ASrc, ADest: String; const ARecursive, ASquash: Boolean);
var
  Files: TStringDynArray;
  DestFiles: TStringDynArray;

begin
  try
    // Src folder must exists
    if not DirectoryExists(ASrc) then
      raise Exception.Create(RSrcNotExists);

    // Dest folder must exists
    if not DirectoryExists(ADest) then
      raise Exception.Create(RDestNotExists);

    // Check if Dest folder is empty
    DestFiles := TDirectory.GetFiles(ADest, '*', TSearchOption.soAllDirectories);

    if Length(DestFiles) > 0 then
      raise Exception.Create(RDestNotEmpty);

    // Check if Src folder is not empty
    if not (GetPicturesInDir(Files, ASrc, ARecursive) > 0) then
      raise Exception.Create(RSrcNoData);

    // Prepare folders structure
    if ARecursive AND not ASquash then
      CreateFolders(Files, ASrc, ADest);

    MovePicturesToDir(Files, ASrc, ADest, ASquash);

  except
    // All units that implements that, need to handle errors
    raise;
  end;
end;

end.
