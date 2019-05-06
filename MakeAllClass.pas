unit MakeAllClass;

interface

uses
   System.SysUtils,
   System.Classes,
   Fmx.Types,
   ElementView, Fmx.Forms;

type

   TPointer = ^TTree;

   TTree = Record
      Sons: array [Boolean] of TPointer;
      Value: TElementView;

   End;

   TMakeAll = class
   public
   var
      Root: TPointer;
      Answer: String;

      procedure AddElement(Pos: TTrack; Value: TViewElementPointer);
      procedure DeleteElement(Element: TPointer);
      procedure DeleteElementByPos(Pos: TTrack);
      function FindAnswer(Element: TPointer): Integer;
      function GetAnswer(): String;
      procedure ToStart(var Parent: TForm);
   end;

implementation

procedure TMakeAll.AddElement(Pos: TTrack; Value: TViewElementPointer);
var
   NewElement, PastElement: TPointer;
   Navigation: Boolean;
begin
   PastElement := nil;
   NewElement := Root;
   for Navigation in Pos do
   begin
      PastElement := NewElement;

      NewElement := NewElement.Sons[Navigation];
   end;

   new(NewElement);

   NewElement.Sons[true] := nil;
   NewElement.Sons[false] := nil;
   NewElement.Value := Value^;
   if (PastElement <> nil) then
      PastElement.Sons[Pos[High(Pos)]] := NewElement
   else
      Root := NewElement;

end;

procedure TMakeAll.DeleteElement(Element: TPointer);
begin
   if (Element <> nil) then
   begin
      DeleteElement(Element.Sons[true]);
      DeleteElement(Element.Sons[false]);
      Element.Value.Delete;
      FreeMem(Element);
   end;
end;

procedure TMakeAll.DeleteElementByPos(Pos: TTrack);
var
   FindElement, Father: TPointer;
   Direction: Boolean;
begin
   Father := nil;
   FindElement := Root;
   for Direction in Pos do
   begin
      Father := FindElement;
      FindElement := FindElement.Sons[Direction];
   end;
   DeleteElement(FindElement);
   if (Father <> nil) then
      Father.Sons[Pos[High(Pos)]] := nil
   else
      Root := nil;

end;

function TMakeAll.FindAnswer(Element: TPointer): Integer;
var
   Values: array [false .. true] of Integer;
   i: Boolean;
begin
   Result := 0;
   if (Element <> nil) then
   begin
      for i := false to true do
      begin
         Values[i] := FindAnswer(Element.Sons[i]);
      end;
      if (Values[true] <> Values[false]) then
         Answer := Answer + IntToStr(Element.Value.Number) + ', ';
      Result := Values[true] + Values[false] + 1;
   end;
end;

function TMakeAll.GetAnswer(): String;
begin
   Answer := '';
   FindAnswer(Root);
   if (Length(Answer) > 0) then
      SetLength(Answer, Length(Answer) - 2);
   Result := Answer;
end;

procedure TMakeAll.ToStart(var Parent: TForm);
var
   Pos: ElementView.TTrack;
   AddProc: TAddProcedure;
   DeleteProc: TDeleteProcedure;
   StartElement: TElementView;
begin
   if (Root <> nil) then
   begin
      DeleteElement(Root);
   end;
   SetLength(Pos, 0);

   StartElement := TElementView.Create(Parent, Pos, AddElement,
     DeleteElementByPos);
   // New(Root);
   // Root.Sons[true]:=nil;
   // Root.Sons[false]:=nil;
   // Root.Value:=StartElement;
end;

end.
