program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  Menue1 = 'A. Bitte geben sie einen Satz ein';
  Menue2 = 'B. Anzahl der Großbuchstaben im Satz bestimmen';
  Menue3 = 'C. Groß-/Kleinschreibung im Satz vertauschen';
  Menue4 = 'D. Alle Wörter kürzen';


  var
  Satz : String;
  Eingabe : String;
  EingabeA : Boolean;
  AntwortA : String;

begin
AntwortA := 'A';
writeln(Menue1);
writeln(Menue2);
writeln(Menue3);
writeln(Menue4);
readln(Eingabe);

AntwortA := Eingabe = EingabeA;

writeln('Bitte geben sie einen Satz ein');
readln(Satz);




end.
