program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  Menue1 = 'A. Bitte geben sie einen Satz ein';
  Menue2 = 'B. Anzahl der Gro�buchstaben im Satz bestimmen';
  Menue3 = 'C. Gro�-/Kleinschreibung im Satz vertauschen';
  Menue4 = 'D. Alle W�rter k�rzen';


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
