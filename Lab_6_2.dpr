program Lab_6_2;

uses
   System.StartUpCopy,
   FMX.Forms,
   Main in 'Main.pas' {FormMain} ,
   ElementView in 'ElementView.pas';

{$R *.res}

begin
   Application.Initialize;
   Application.CreateForm(TFormMain, FormMain);
   Application.Run;

end.
