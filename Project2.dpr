program Project2;

uses
  Forms,
  Unit1 in '..\disk_work\Unit1.pas' {Form1},
  UBrowsebySector in 'UBrowsebySector.pas' {Brows_Sect_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TBrows_Sect_Form, Brows_Sect_Form);
  Application.Run;
end.
