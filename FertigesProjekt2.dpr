program FertigesProjekt2;

{$APPTYPE CONSOLE}

{ $R+,Q+,X-}

uses
  System.math;

const
  Tischplätze = 6;
  Personengruppe1 = 'Lerngruppenfreunde';
  Personengruppe2 = 'AstaWedel';
  Personengruppe3 = 'Partygänger';

var
  Gruppe1 : Byte;
  Gruppe2 : Byte;
  Gruppe3 : Byte;
  Gesammtanzahl : Byte;
  Tischanzahl: Byte;
  Rest : Byte;
  MaxGruppe : Byte;
  MinGruppe : Byte;
  Gruppe1Max: Boolean;
  Gruppe2Max: Boolean;
  Gruppe3Max: Boolean;
  Gruppe1Min: Boolean;
  Gruppe2Min: Boolean;
  Gruppe3Min: Boolean;
  AlleGruppenVorhanden: Boolean;
  GrößteGruppe: Boolean;
  LetzterTisch: Boolean;
  Rundung: Boolean;
  KeinerDa: Boolean;


begin
//Abfrage der Personenanzahl
    writeln('Wie viele Personen der ', Personengruppe1, ' wollen kommen?');
    readln(Gruppe1);
    writeln('Wie viele Personen der ', Personengruppe2, ' wollen kommen?');
    readln(Gruppe2);
    writeln('Wie viele Personen der ', Personengruppe3, ' wollen kommen?');
    readln(Gruppe3);
//Berechnung der Tische
    Gesammtanzahl := Gruppe1 + Gruppe2 + Gruppe3;
    Rundung:= Gesammtanzahl mod Tischplätze <> 0;
    Tischanzahl := Gesammtanzahl div Tischplätze + byte(Rundung);
//Berechnung des Restes
    LetzterTisch:= Gesammtanzahl mod Tischplätze = 0;
    KeinerDa:= Gesammtanzahl = 0;
    Rest := Gesammtanzahl mod Tischplätze + (byte(LetzterTisch)*Tischplätze)-(byte(KeinerDa)*Tischplätze);
//Ausgabe
    writeln('Es werden ' ,Tischanzahl, ' Tische der Größe ', Tischplätze, ' benötigt');
    writeln;
    writeln('Am letzten Tisch sitzen ',Rest,' Personen');
    writeln;
    writeln('Insgesammt sind ', Gesammtanzahl, ' Studierende vorhanden');
    writeln;
//Min/Max
    MaxGruppe :=  max(Gruppe1, max(Gruppe2, Gruppe3));
    MinGruppe :=  min(Gruppe1, min(Gruppe2, Gruppe3));
    Gruppe1Max := MaxGruppe = Gruppe1;
    Gruppe2Max := MaxGruppe = Gruppe2;
    Gruppe3Max := MaxGruppe = Gruppe3;
    Gruppe1Min := MinGruppe = Gruppe1;
    Gruppe2Min := MinGruppe = Gruppe2;
    Gruppe3Min := MinGruppe = Gruppe3;
    writeln('Die Maximale Anzahl in einer Gruppe ist ',MaxGruppe, ', die minimale Anzahl ist ', MinGruppe);
    writeln;
//Vergleiche Max
    writeln(Personengruppe1, ' sind die größte Gruppe ', Gruppe1Max);
    writeln(Personengruppe2, ' sind die größte Gruppe ', Gruppe2Max);
    writeln(Personengruppe3, ' sind die größte Gruppe ', Gruppe3Max);
//Vergleiche Min
    writeln(Personengruppe1, ' sind die kleinste Gruppe ', Gruppe1Min);
    writeln(Personengruppe2, ' sind die kleinste Gruppe ', Gruppe2Min);
    writeln(Personengruppe3, ' sind die kleinste Gruppe ', Gruppe3Min);
//Mitgliederzahl
    AlleGruppenVorhanden :=  MinGruppe <> 0;
    writeln('Aus jeder Gruppe ist mindestens ein(e) Studierende(r) vorhanden: ', AlleGruppenVorhanden);
    writeln;
//Eindeutig Größte Gruppe
    GrößteGruppe :=  ((byte(Gruppe1Max) + byte(Gruppe2Max) + byte(Gruppe3Max)) = 1);
    writeln('Es gibt eindeutig eine größte Gruppe ', GrößteGruppe);
//Programmende
    readln
    end.
