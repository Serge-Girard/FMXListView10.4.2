program Project113;

uses
  System.StartUpCopy,
  FMX.Forms,
  U113 in 'U113.pas' {umain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tumain, umain);
  Application.Run;
end.
