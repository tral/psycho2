program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ToolUnit in 'ToolUnit.pas',
  Analytics in 'Analytics.pas',
  UAuthForm in 'UAuthForm.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ÊÏÂ';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;

end.
