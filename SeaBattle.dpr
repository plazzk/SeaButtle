program SeaBattle;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  WinUnit in 'WinUnit.pas' {WinForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TWinForm, WinForm);
  Application.Run;
end.
