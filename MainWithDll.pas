unit MainWithDll;

interface

uses
   System.SysUtils, System.Types, System.UITypes, System.Classes,
   System.Variants,
   FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
   FMX.Menus, Vcl.Dialogs, Winapi.Windows, FMX.Platform.Win,
   FMX.Controls.Presentation, FMX.StdCtrls {,
     MakeAllClass} , ElementView;

// AddElement, DeleteElement, DeleteElementByPos, FindAnswer, GetAnswer;
procedure AddElement(Pos: TTrack; Number: Integer); external 'Lib_6_2.dll';

function DeleteElementByPos(Pos: TTrack): TElements; external 'Lib_6_2.dll';

function GetAnswer(): String; external 'Lib_6_2.dll';

type

   TFormMain = class(TForm)
      MainMenu: TMainMenu;
      MIToStart: TMenuItem;
      MIterm: TMenuItem;
      BGetAnswer: TButton;

      procedure MIToStartClick(Sender: TObject);
      procedure MItermClick(Sender: TObject);
      procedure BGetAnswerClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
   private
      AllElements: array [1 .. 63] of TElementView;
   public
      procedure AddElementMethod(Pos: TTrack; Value: TViewElementPointer);
      procedure DeleteElementByPosMethod(Pos: TTrack);

   end;

var
   FormMain: TFormMain;

implementation

{$R *.fmx}

procedure TFormMain.AddElementMethod(Pos: TTrack; Value: TViewElementPointer);
var
   Number: Integer;
begin
   AllElements[Value.Number] := Value^;
   AddElement(Pos, Value.Number);
   // GetViewByPos(Pos)^:=Value^;
   // Number:=GetViewByPos(Pos).Number;
end;

procedure TFormMain.BGetAnswerClick(Sender: TObject);
var
   Answer: String;
begin
   Answer := GetAnswer;

   if (Length(Answer) > 0) then
   begin

      MessageBox(GetDesktopWindow,
        PChar('Номера вершин, у которых не совпадает количество потомков:' +
        #13#10 + Answer), PChar('Ответ'), MB_OK)
   end
   else
      MessageBox(GetDesktopWindow,
        PChar('Вершин с несовпадающим количеством потомков не обнаружено.'),
        PChar('Ответ'), MB_OK)
end;

procedure TFormMain.DeleteElementByPosMethod(Pos: TTrack);
var
   DeletedElement: Integer;

begin

   // GetViewByPos(Pos).Delete;

   for DeletedElement in DeleteElementByPos(Pos) do
   begin
      AllElements[DeletedElement].Delete;
   end;

end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
   // MakeAll:=TMakeAll.Create();
end;

procedure TFormMain.MItermClick(Sender: TObject);
begin
   MessageBox(GetDesktopWindow,
     PChar('Вывести номера вершин, у которых количество потомков в левом поддереве не равно количеству потомков в правом поддереве. Дерево визуализировать!'),
     PChar('Условие'), MB_OK)
end;

procedure TFormMain.MIToStartClick(Sender: TObject);
var
   Path: TTrack;
   StartElement: TElementView;

begin
   SetLength(Path, 0);

   DeleteElementByPosMethod(Path);
   StartElement := TElementView.Create(Self, Path, AddElementMethod,
     DeleteElementByPosMethod);

end;

end.
