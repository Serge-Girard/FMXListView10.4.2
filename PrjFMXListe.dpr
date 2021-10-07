program PrjFMXListe;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFMXListe in 'UFMXListe.pas' {Form13};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm13, Form13);
  Application.Run;
end.
