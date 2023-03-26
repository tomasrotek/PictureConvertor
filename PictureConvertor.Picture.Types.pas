{*******************************************************}
{                                                       }
{                  PictureConvertor                     }
{                                                       }
{                    Picture Types                      }
{      - base types for PictureConvertor project        }
{                                                       }
{*******************************************************}

unit PictureConvertor.Picture.Types;

interface

type
  TPictureTypes = class(TObject)
  const
    // These are only supported file extensions
    Extensions : array[0..2] of String = (
      'JPG',
      'JPEG',
      'PNG'
    );
  end;

implementation

end.
