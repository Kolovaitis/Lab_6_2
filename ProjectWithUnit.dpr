program ProjectWithUnit;

uses
   System.StartUpCopy,
   FMX.Forms,
   UnitVariant in 'UnitVariant.pas' {Form4} ,
   MakeAllClass in 'MakeAllClass.pas';

{$R *.res}

begin
   Application.Initialize;
   Application.CreateForm(TFormMain, FormMain);
   Application.Run;

end.
