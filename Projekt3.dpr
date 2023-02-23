program Projekt3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math;
const
SERIE1 = 'Grauen sucht Frau';
SERIE2 = 'Wenn Gebäude kollabieren';
SERIE3 = 'Bronzeeisens Mutantenstadl';
SERIE4 = 'Die 25 besten 25en';

var
wochentag: Byte;
spannend: Char;
istSpannend: Boolean;
romantisch: Char;
istRomantisch: Boolean;
informativ: Char;
istInformativ: Boolean;
rindvieh: Char;
geschlecht: Char;
alter: Byte;
zahlenjunkie: Char;
serie1empfehlenswert, serie2empfehlenswert, serie3empfehlenswert, serie4empfehlenswert: Boolean;



begin
//Abfrage der Wochentage
writeln('Bitte den Wochentag eingeben (Mo = 1, So = 7)');
readln(Wochentag);

//Berechnung der Wochentage
case Wochentag of
1: writeln('Heute ist Montag');
2: writeln('Heute ist Dienstag');
3: writeln('Heute ist Mittwoch');
4: writeln('Heute ist Donnerstag');
5: writeln('Heute ist Freitag');
6,7: writeln('Am Wochenende gehen wir raus, da wird nicht ferngesehen :-)');
else
writeln('Diesen Wochentag gibt es gar nicht!');
end;


if Wochentag <6 then
begin
//Abfrage der Seriengenre
writeln('Magst du es spannend?(J/N)');
readln(spannend);
istSpannend := spannend = 'J';

writeln('Magst du es romantisch?(J/N)');
readln(romantisch);
istRomantisch := romantisch = 'J';

writeln('Magst du es informativ?(J/N)');
readln(informativ);
istInformativ := informativ = 'J';

//Variebalendeklaration
serie1empfehlenswert := not istSpannend and not istInformativ and istRomantisch;
serie2empfehlenswert := (istSpannend or istInformativ) and not istRomantisch;
serie3empfehlenswert := not istSpannend and not istInformativ and not istRomantisch;
serie4empfehlenswert := not istSpannend and not istRomantisch and istInformativ;

if serie4empfehlenswert then
begin
writeln('Du solltest ',SERIE4,' schauen');
write('Magst du Zahlen? (J/N) ');
read(zahlenjunkie);
if zahlenjunkie = 'N' then
 writeln('Du magst ', SERIE4, ' leider doch nicht...');
 readln;
 end;

if serie1empfehlenswert then

begin
writeln('Du solltest ' ,SERIE1, ' sehen');
write('Magst du Rindviecher? (J/N) ');
read(rindvieh);
if rindvieh = 'N' then
writeln('Du magst ', SERIE1, ' leider doch nicht...');
readln;
end;

if serie2empfehlenswert then
begin
writeln('Du solltest', SERIE2, ' schauen');
write('Welches Geschlecht hast du? (M/W) ');
readln(geschlecht);
if geschlecht = 'W' then
writeln('Du magst ', SERIE2, ' leider doch nicht...');
readln;
end;

if serie3empfehlenswert then
begin
writeln('Du solltest ', SERIE3, ' schauen');
write('Wie alt bist du? ');
readln(alter);
if alter <= 80 then
writeln('Du magst ', SERIE3, ' leider doch nicht...');
readln;
end;

if byte(serie1empfehlenswert) + byte(serie2empfehlenswert) + byte(serie3empfehlenswert) + byte(serie4empfehlenswert) = 0 then
writeln('Viel Spaß beim Häkeln...');

end;
//Programmende
readln;
end.
