library Lib_6_2;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
   System.SysUtils,
   System.Classes,
   Fmx.Types,
   ElementView;

type

   TPointer = ^TTree;

   TTree = Record
      Sons: array [Boolean] of TPointer;
      Number: Integer;
   End;

var
   Root: TPointer;
   Answer: String;
   CurrentIndex: Integer;

const
   MaxElementCount = 63;

{$R *.res}

procedure DeleteElement(Element: TPointer; var DeletedElements: TElements);
begin
   if (Element <> nil) then
   begin
      DeletedElements[CurrentIndex] := Element.Number;
      Inc(CurrentIndex);
      DeleteElement(Element.Sons[true], DeletedElements);
      DeleteElement(Element.Sons[false], DeletedElements);

      FreeMem(Element);
   end;
end;

function FindAnswer(Element: TPointer): Integer;
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
         Answer := Answer + IntToStr(Element.Number) + ', ';
      Result := Values[true] + Values[false] + 1;
   end;
end;

procedure AddElement(Pos: TTrack; Number: Integer); export;
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

   NewElement.Number := Number;
   if (PastElement <> nil) then
      PastElement.Sons[Pos[High(Pos)]] := NewElement
   else
      Root := NewElement;

end;

function DeleteElementByPos(Pos: TTrack): TElements; export;
var
   FindElement, Father: TPointer;
   Direction: Boolean;
   DeletedElements: TElements;
begin
   SetLength(DeletedElements, MaxElementCount);
   CurrentIndex := 0;
   Father := nil;
   FindElement := Root;
   for Direction in Pos do
   begin
      Father := FindElement;
      FindElement := FindElement.Sons[Direction];
   end;
   DeleteElement(FindElement, DeletedElements);
   if (Father <> nil) then
      Father.Sons[Pos[High(Pos)]] := nil
   else
      Root := nil;
   SetLength(DeletedElements, CurrentIndex);
   DeleteElementByPos := DeletedElements;
end;

function GetAnswer(): String; export;
begin
   Answer := '';
   FindAnswer(Root);
   if (Length(Answer) > 0) then
      SetLength(Answer, Length(Answer) - 2);
   Result := Answer;
end;

exports
   AddElement, DeleteElementByPos, GetAnswer;

begin
   Root := nil;

end.
