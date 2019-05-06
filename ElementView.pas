unit ElementView;

interface

uses
   System.SysUtils, System.Types, System.UITypes, System.Classes,
   System.Variants,
   FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
   FMX.Controls.Presentation, FMX.StdCtrls;

type
   TTrack = array of Boolean;
   TViewElementPointer = ^TElementView;
   TAddProcedure = procedure(Pos: TTrack; Value: TViewElementPointer) of object;
   TDeleteProcedure = procedure(Pos: TTrack) of object;
   TElements = array of Integer;

   TElementView = class(TCircle)
   public
      AddElement: TAddProcedure;
      DeleteByPos: TDeleteProcedure;
      Number: Integer;
      Constructor Create(AOwner: TFmxObject; const Position: TTrack;
        AddElement: TAddProcedure; DeleteByPos: TDeleteProcedure); overload;
      Function GetTrack(): TTrack;
      procedure AddLeftClick(Sender: TObject);
      procedure AddRightClick(Sender: TObject);
      procedure Delete();
      function TrackToNumber(Track: TTrack): Integer;

   const
      WidthOfField = 640;
      DeltaHeight = 50;
      Diametr = 20;
      StartY = 10;
      MaxLevel = 5;
      TextMarginXOne = 6;
      TextMarginXTwo = 4;
      TextMarginY = 2;
      NewColor = TAlphaColors.Green;
      MaxNumberTreshold = 9;
   private
      LineLeft, LineRight: TArc;
      AddLeft, AddRight: TCircle;
      Text: TLabel;
      Track: TTrack;
      procedure DblClick(Sender: TObject);
   end;

implementation

{ TElementView }

procedure TElementView.AddLeftClick(Sender: TObject);
var
   NewTrack: TTrack;
   LastIndex: Integer;
   NewElement: TElementView;
begin
   LastIndex := Length(Track);
   NewTrack := Copy(Track);
   SetLength(NewTrack, LastIndex + 1);
   NewTrack[LastIndex] := false;
   NewElement := TElementView.Create(Self.Parent, NewTrack, AddElement,
     DeleteByPos);

   NewElement.AddElement := AddElement;
end;

procedure TElementView.AddRightClick(Sender: TObject);
var
   NewTrack: TTrack;
   LastIndex: Integer;
   NewElement: TElementView;
begin
   LastIndex := Length(Track);
   NewTrack := Copy(Track);
   SetLength(NewTrack, LastIndex + 1);
   NewTrack[LastIndex] := true;
   NewElement := TElementView.Create(Self.Parent, NewTrack, AddElement,
     DeleteByPos);
end;

constructor TElementView.Create(AOwner: TFmxObject; const Position: TTrack;
  AddElement: TAddProcedure; DeleteByPos: TDeleteProcedure);
var
   XPos, YPos, CurWidth: Integer;
   Track: Boolean;
begin
   inherited Create(AOwner);
   Self.AddElement := AddElement;
   Self.DeleteByPos := DeleteByPos;

   Self.Track := Copy(Position);
   Self.Width := Diametr;
   Self.Height := Diametr;

   YPos := StartY;
   XPos := WidthOfField div 2;
   CurWidth := XPos;
   for Track in Position do
   begin
      Inc(YPos, DeltaHeight);
      CurWidth := CurWidth div 2;
      if (Track) then
         Inc(XPos, CurWidth)
      else
         Dec(XPos, CurWidth);
   end;
   if (Length(Position) < MaxLevel) then
   begin
      LineLeft := TArc.Create(Self);
      LineLeft.Parent := AOwner;
      LineLeft.Width := CurWidth;
      LineLeft.Height := DeltaHeight * 2;
      LineLeft.Position.X := XPos - CurWidth div 2;
      LineLeft.Position.Y := YPos + Self.Height / 2;
      LineLeft.StartAngle := -90;
      LineRight := TArc.Create(Self);
      LineRight.Parent := AOwner;
      LineRight.Width := CurWidth;
      LineRight.Height := DeltaHeight * 2;
      LineRight.Position.X := LineLeft.Position.X;
      LineRight.Position.Y := LineLeft.Position.Y;

      AddLeft := TCircle.Create(Self);
      AddLeft.Parent := AOwner;
      AddLeft.Width := Diametr;
      AddLeft.Height := Diametr;
      AddLeft.Position.X := XPos - CurWidth div 2 - Diametr / 2;
      AddLeft.Position.Y := YPos + DeltaHeight;
      AddLeft.Fill.Color := NewColor;
      AddLeft.OnClick := AddLeftClick;

      AddRight := TCircle.Create(Self);
      AddRight.Parent := AOwner;
      AddRight.Width := Diametr;
      AddRight.Height := Diametr;
      AddRight.Position.X := XPos + CurWidth div 2 - Diametr / 2;
      AddRight.Position.Y := AddLeft.Position.Y;
      AddRight.Fill.Color := NewColor;
      AddRight.OnClick := AddRightClick;
   end;
   Self.Position.X := XPos - Self.Width / 2;
   Self.Position.Y := YPos;
   Self.Parent := AOwner;
   Self.OnDblClick := DblClick;

   Number := TrackToNumber(Position);
   Text := TLabel.Create(Self);
   Text.Parent := Self;
   Text.Text := IntToStr(Number);
   if (Number > MaxNumberTreshold) then
      Text.Position.X := TextMarginXTwo
   else
      Text.Position.X := TextMarginXOne;
   Text.Position.Y := TextMarginY;
   AddElement(Position, @Self);
end;

procedure TElementView.Delete;
var
   MyNumber: Integer;
begin
   MyNumber := Number;
   Self.Destroy;

end;

function TElementView.GetTrack: TTrack;
begin
   GetTrack := Track;
end;

procedure TElementView.DblClick(Sender: TObject);
begin
   DeleteByPos(Track);

   // Delete;
end;

function TElementView.TrackToNumber(Track: TTrack): Integer;
var
   Direction: Boolean;
begin
   Result := 1;
   for Direction in Track do
   begin
      Result := Result * 2;
      if (Direction) then
         Inc(Result);
   end;
end;

end.
