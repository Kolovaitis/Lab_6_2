program ProjectWithDll;

uses
   System.StartUpCopy,
   FMX.Forms,
   MainWithDll in 'MainWithDll.pas' {FormMain} ,
   ElementView in 'ElementView.pas';

{$R *.res}

begin
   Application.Initialize;
   Application.CreateForm(TFormMain, FormMain);
   Application.Run;

end.
