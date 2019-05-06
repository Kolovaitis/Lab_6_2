unit UnitVariant;

interface

uses
   System.SysUtils, System.Types, System.UITypes, System.Classes,
   System.Variants,
   FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, MakeAllClass,
   FMX.Controls.Presentation, FMX.StdCtrls, FMX.Menus, Vcl.Dialogs,
   Winapi.Windows, FMX.Platform.Win;

type
   TFormMain = class(TForm)
      procedure BGetAnswerClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure MIToStartClick(Sender: TObject);
      procedure MItermClick(Sender: TObject);
   private
      MakeAll: TMakeAll;
   public
      { Public declarations }
   end;

var
   FormMain: TFormMain;

implementation

{$R *.fmx}

procedure TFormMain.BGetAnswerClick(Sender: TObject);
var
   Answer: String;
begin
   Answer := MakeAll.GetAnswer;

   if (Length(Answer) > 0) then
   begin

      MessageBox(GetDesktopWindow,
        PChar('������ ������, � ������� �� ��������� ���������� ��������:' +
        #13#10 + Answer), PChar('�����'), MB_OK)
   end
   else
      MessageBox(GetDesktopWindow,
        PChar('������ � ������������� ����������� �������� �� ����������.'),
        PChar('�����'), MB_OK)
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
   MakeAll := TMakeAll.Create;
end;

procedure TFormMain.MItermClick(Sender: TObject);
begin
   MessageBox(GetDesktopWindow,
     PChar('������� ������ ������, � ������� ���������� �������� � ����� ��������� �� ����� ���������� �������� � ������ ���������. ������ ���������������!'),
     PChar('�������'), MB_OK);
end;

procedure TFormMain.MIToStartClick(Sender: TObject);
begin
   MakeAll.ToStart(TForm(Self));
end;

end.
