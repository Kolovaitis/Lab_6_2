unit Main;

interface

uses
   System.SysUtils, System.Types, System.UITypes, System.Classes,
   System.Variants,
   FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
   FMX.Menus, Vcl.Dialogs, Winapi.Windows, FMX.Platform.Win,
   FMX.Controls.Presentation, FMX.StdCtrls, ElementView;

type

   TPointer = ^TTree;

   TTree = Record
      Da: array [Boolean] of TPointer;
      Value: TElementView;

   End;

   TFormMain = class(TForm)
      MainMenu: TMainMenu;
      MIToStart: TMenuItem;
      MIterm: TMenuItem;
      BGetAnswer: TButton;

      procedure MIToStartClick(Sender: TObject);
      procedure MItermClick(Sender: TObject);
      procedure BGetAnswerClick(Sender: TObject);
   private
      Root: TPointer;
   public
      Answer: String;
      procedure AddElement(Pos: TTrack; Value: TViewElementPointer);
      procedure DeleteElement(Element: TPointer);
      procedure DeleteElementByPos(Pos: TTrack);
      Function FindAnswer(Element: TPointer): Integer;
   end;

var
   FormMain: TFormMain;

implementation

{$R *.fmx}

procedure TFormMain.AddElement(Pos: TTrack; Value: TViewElementPointer);
var
   NewElement, PastElement: TPointer;
   Navigation: Boolean;
begin
   PastElement := nil;
   NewElement := Root;
   for Navigation in Pos do
   begin
      PastElement := NewElement;

      NewElement := NewElement.Da[Navigation];
   end;

   new(NewElement);

   NewElement.Da[true] := nil;
   NewElement.Da[false] := nil;
   NewElement.Value := Value^;
   if (PastElement <> nil) then
      PastElement.Da[Pos[High(Pos)]] := NewElement
   else
      Root := NewElement;

end;

procedure TFormMain.BGetAnswerClick(Sender: TObject);
begin
   Answer := '';
   FindAnswer(Root);
   if (Length(Answer) > 0) then
   begin
      SetLength(Answer, Length(Answer) - 2);
      MessageBox(GetDesktopWindow,
        PChar('Номера вершин, у которых не совпадает количество потомков:' +
        #13#10 + Answer), PChar('Ответ'), MB_OK)
   end
   else
      MessageBox(GetDesktopWindow,
        PChar('Вершин с несовпадающим количеством потомков не обнаружено.'),
        PChar('Ответ'), MB_OK)
end;

procedure TFormMain.DeleteElement(Element: TPointer);
begin
   if (Element <> nil) then
   begin
      DeleteElement(Element.Da[true]);
      DeleteElement(Element.Da[false]);
      Element.Value.Delete;
      FreeMem(Element); // Поправить

   end;
end;

procedure TFormMain.DeleteElementByPos(Pos: TTrack);
var
   FindElement, Father: TPointer;
   Direction: Boolean;
begin
   Father := nil;
   FindElement := Root;
   for Direction in Pos do
   begin
      Father := FindElement;
      FindElement := FindElement.Da[Direction];
   end;
   DeleteElement(FindElement);
   if (Father <> nil) then
      Father.Da[Pos[High(Pos)]] := nil
   else
      Root := nil;

end;

function TFormMain.FindAnswer(Element: TPointer): Integer;
var
   Values: array [false .. true] of Integer;
   i: Boolean;
begin
   Result := 0;
   if (Element <> nil) then
   begin
      for i := false to true do
      begin
         Values[i] := FindAnswer(Element.Da[i]);
      end;
      if (Values[true] <> Values[false]) then
         Answer := Answer + IntToStr(Element.Value.Number) + ', ';
      Result := Values[true] + Values[false] + 1;
   end;
end;

procedure TFormMain.MItermClick(Sender: TObject);
begin
   MessageBox(GetDesktopWindow,
     PChar('Вывести номера вершин, у которых количество потомков в левом поддереве не равно количеству потомков в правом поддереве. Дерево визуализировать!'),
     PChar('Условие'), MB_OK)
end;

procedure TFormMain.MIToStartClick(Sender: TObject);
var
   Pos: TTrack;
   ElementRoot: TElementView;
begin
   if (Root <> nil) then
   begin
      DeleteElement(Root);
   end;
   SetLength(Pos, 0);

   ElementRoot := TElementView.Create(Self, Pos, AddElement,
     DeleteElementByPos);
   // ElementRoot.OnClick := Self.OnNewClick;

end;

end.
