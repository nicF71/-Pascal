program ueb6_fertig;
{ Erstellt von Nic Frigius und Justin Walger am 30.11.2021
  Das Programm besteht aus Funktionen / Prozeduren und einem Hauptteil.
  Im Hauptteil wurden für jede Funktion / Prozedur 5 Testfälle erstellt, mit denen
  die Funktionalität getestet wurde. Wir haben dabei bewusst untypische Werte (0, negative Werte etc.)
  verwendet. }
{$APPTYPE CONSOLE}
{$R+,Q+,X-}


uses
  System.SysUtils;

// Gibt zurück, ob die Zahl i positiv ist oder nicht (0 gilt als positiv).
// @param:
// i, Zahl bei der geprüft wird, ob sie positiv oder negativ ist
// @return:
// True, wenn die Zahl Positiv ist

function isPositive(i: integer): boolean;
begin
  isPositive := (i >= 0);
end;

// Gibt zurück, ob die Zahl i eine Quadratzahl ist (also 0, 1, 4, 9, ...).
// @param:
// i, Zahl bei der geprüft wird, ob sie eine Quadrahtzahl ist
// @return:
// True, wenn i eine Quadrahtzahl ist
function isSquare(i: integer): boolean;
var
  j: integer;

begin
  isSquare := False;
  if isPositive(i) then
  begin
    // TODO DONE: vereinfachen keine Schleife verwenden
    j := round(sqrt(i));
    if sqr(j) = i then
      isSquare := True;
  end;

end;

// Berechnet die Wurzel der Zahl i, wenn i eine Quadratzahl ist und gibt die Wurzel
// dann über i nach außen zurück. Ansonsten bleibt i unverändert.
// @param:
// i, Zahl deren Wurzel gesucht wird, wenn sie eine Quadrahtzahl ist
// @return:
// i , wenn i keine Quadrahtzahl ist, sonst die Wurzel aus i
// TODO DONE: @out fehlt
// @out i entweder Wurzel der Eingabezahl oder bei Rückgabe False -> Eingabezahl bleibt unverändert
function squareRoot(var i: integer): boolean;
begin
  if isSquare(i) then
  begin
    i := trunc(sqrt(i));
    squareRoot := True;
  end
  else
    squareRoot := False;
end;

// Gibt zurück, ob die Ziffer digit in der Zahl i vorkommt. Auch negative Zahlen
// sind hier möglich!
// @param:
// i, Zahl für die geprüft wird, ob digit enthalten ist.
// digit, Ziffer für die geprüft wird, ob sie in i enthalten ist.
// @return:
// Gibt True zurück, wenn digit in i vorkommt
function digitExists(i: integer; digit: byte): boolean;
var
  // TODO DONE: vorkommen mit boolean lösbar
  rest: byte;

begin
  digitExists := False;
  i := (abs(i));
  digit := abs(digit);
  repeat
  begin
    rest := (i mod 10);
    i := i div 10;
    if rest = digit then
      digitExists := True;
  end;
  until i = 0;

end;

// Gibt die Ziffern, die in beiden Zahlen i1 und i2 vorkommen, aufsteigend sortiert
// als String zurück.
// @param:
// i1, erste Zahl
// i2, zweite Zahl
// @return:
// Gibt, der Größe nach sortiert, die gemeinsamen Ziffern in i1 und i2 zurück. Wenn
// es keine gemeinsamen Ziffern gibt, wird ein leerer String zurückgegeben
function commonDigits(i1, i2: integer): string;
var

  mehrfachZahlen: string;
  m: byte;

begin

  mehrfachZahlen := '';

  for m := 0 to 9 do
  begin

    if digitExists(i1, m) and digitExists(i2, m) then
      mehrfachZahlen := mehrfachZahlen + inttostr(m);

  end;
  commonDigits := mehrfachZahlen;
end;

// Gibt zur Zahl i eine Reihe von Informationen als Text in der Konsole aus (alles
// in einer Zeile): Die Zahl selbst; ob sie positiv ist; ob sie eine Quadratzahl ist;
// wie ggf. ihre Quadratwurzel aussieht (oder '-', wenn es keine Quadratzahl ist.);
// welche Ziffern in der Zahl vorkommen und welche Ziffern
// in der Zahl und ihrer Wurzel vorkommen (oder wieder '-', wenn es keine gemeinsamen gibt).
// @param:
// i, die Zahl für die diese Berchnungen durchgeführt werden sollen.
// @return:
// Gibt die ergebnisse der Funktion gebündelt in einer Ausgabe aus.
procedure printInfos(i: integer);
var
  zahl,j : integer;

begin
  // TODO DONE: Kommentare immer über die entsprechende Zeile und nicht dahinter oder darunter
  // TODO DONE: printInfo an den neuen Rückgabewert von squareRoot anpassen (war vorher extended)

  // wurzel als Quadratwurzel von i definieren (falls es keine Quadratzahl ist, ist wurzel = i
  zahl := i;

  // Alle Ausgaben bis zur Wurzel
  write('Zahl: ', zahl, ' Positiv: ', isPositive(zahl), ' Quadrat: ', isSquare(zahl),
    ' Wurzel: ');

  // Falls wurzel = i, gibt es keine Quadratwurzel
  if isSquare(i) then
  begin
  write(trunc(sqrt(i)));
  end
  else
  begin
  write('-');
  end;

  // TODO DONE: Ziffern mit digitExists lösen
  write(' Ziffern: ');
  for j := 0 to 9 do
    begin
    if digitExists(i, j) then
      write(j)

    end;
  write(' Ziffern in Zahl und Wurzel: ');

  if (commonDigits(i, zahl) = '') or not isSquare(i) then
  // Wenn es keine Wurzel oder keine mehrfachen Ziffern gibt ist die Ausgabe -> -
  begin
    write('-')
  end
  else
  begin
    write(commonDigits(i, zahl));
  end;

end;


// Hauptprogramm in dem wir alle Funktionen und Prozeduren Testen. Es wird pro Funktion/ Prozedur
// 5 mal getestet, ob diese korrekt funktionieren

var
  testZahlWurzel: integer; // Für die Berchnung der Wurzel
  i : integer;

begin
  // Tests für isPositive
  // Testcase 1
  write('Test 1, isPositive(0) -> True ');
  if isPositive(0) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', isPositive(0));

  // Testcase 2
  write('Test 2, isPositive(2147483647) -> True ');
  if isPositive(2147483647) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', isPositive(2147483647));

  // Testcase 3
  write('Test 3, isPositive(-2147483648) -> False ');
  if isPositive(-2147483648) then
  begin
    writeln('Fehler: ', isPositive(-2147483648));
  end
  else
    writeln('OK');

  // Testcase 4
  write('Test 4, isPositive(1234567) -> True ');
  if isPositive(1234567) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', isPositive(1234567));

  // Testcase 5
  write('Test 5, isPositive(-1234567) -> False ');
  if isPositive(-1234567) then
  begin
    writeln('Fehler: ', isPositive(-1234567));
  end
  else
    writeln('OK');

  writeln;

  // Tests für isSquare
  // Testcase 1
  write('Test 1, isSquare(0) -> True ');
  if isSquare(0) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', isSquare(0));

  // Testcase 2
  write('Test 2, isSquare(9) -> True ');
  if isSquare(9) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', isSquare(9));

  // Testcase 3
  write('Test 3, isSquare(-9) -> False ');
  if isSquare(-9) then
  begin
    writeln('Fehler: ', isSquare(-9));
  end
  else
    writeln('OK');

  // Testcase 4
  write('Test 4, isSquare(8) -> False ');
  if isSquare(8) then
  begin
    writeln('Fehler: ', isSquare(8));
  end
  else
    writeln('OK');

  // Testcase 5
  write('Test 5, isSquare(10000) -> True ');
  if isSquare(10000) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', isSquare(10000));

  writeln;

  // TODO DONE: Tests an den neuen Rückgabewert anpassen (war vorher extended)
  // Test für squareRoot
  // Testcase 1
  write('Test 1, squareRoot(0) -> 0 ');
  testZahlWurzel := 0;
  if squareRoot(testZahlWurzel) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', squareRoot(testZahlWurzel));

  // Testcase 2
  write('Test 2, squareRoot(9) -> 3 ');
  testZahlWurzel := 9;
  if squareRoot(testZahlWurzel) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', squareRoot(testZahlWurzel));

  // Testcase 3
  write('Test 3, squareRoot(8) -> 8 ');
  testZahlWurzel := 8;
  if not squareRoot(testZahlWurzel) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', squareRoot(testZahlWurzel));

  // Testcase 4
  write('Test 4, squareRoot(-10) -> -10 ');
  testZahlWurzel := -10;
  if  not squareRoot(testZahlWurzel) then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', squareRoot(testZahlWurzel));

  // Testcase 5
  write('Test 5, squareRoot(10000) -> 100 ');
  testZahlWurzel := 10000;
  if squareRoot(testZahlWurzel)then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', squareRoot(testZahlWurzel));

  writeln;

  // test für digitExists
  // Testcase 1
  write('Test 1, digitExists(0,0) -> True ');
  if digitExists(0, 0) then
  begin
    writeln('OK')
  end
  else
    writeln('Fehler: ', digitExists(0, 0));

  // Testcase 2
  write('Test 2, digitExists(-30,3) -> True ');
  if digitExists(-30, 3) then
  begin
    writeln('OK')
  end
  else
    writeln('Fehler: ', digitExists(-30, 3));

  // Testcase 3
  write('Test 3, digitExists(4000,4) -> True ');
  if digitExists(4000, 4) then
  begin
    writeln('OK')
  end
  else
    writeln('Fehler: ', digitExists(4000, 4));

  // Testcase 4
  write('Test 4, digitExists(1234,5) -> False ');
  if digitExists(1234, 5) then
  begin
    writeln('Fehler: ', digitExists(1234, 5));
  end
  else
    writeln('OK');

  // Testcase 5
  write('Test 5, digitExists(567,0) -> False ');
  if digitExists(567, 0) then
  begin
    writeln('Fehler: ', digitExists(567, 0));
  end
  else
    writeln('OK');

  write('Test 6, digitExists(1234,14) -> False ');
  if digitExists(1234, 14) then
  begin
    writeln('Fehler: ', digitExists(1234, 14));
  end
  else
    writeln('OK');

  writeln;

  // Test für CommonDigits
  // Testcase 1
  write('Test 1, commonDigits(0,0) -> 0 ');
  if commonDigits(0, 0) = '0' then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', commonDigits(0, 0));

  // Testcase 2
  write('Test 2, commonDigits(-5,55) -> 5 ');
  if commonDigits(-5, 55) = '5' then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', commonDigits(-5, 55));

  // Testcase 3
  write('Test 3, commonDigits(12345,6789) -> "" ');
  if commonDigits(12345, 6789) = '' then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', commonDigits(12345, 6789));

  // Testcase 4
  write('Test 4, commonDigits(99888000,889990) -> 089 ');
  if commonDigits(99888000, 889990) = '089' then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', commonDigits(99888000, 889990));

  // Testcase 5
  write('Test 5, commonDigits(-1234567890,1234567890) -> 0123456789 ');
  if commonDigits(-1234567890, 1234567890) = '0123456789' then
  begin
    writeln('OK');
  end
  else
    writeln('Fehler: ', commonDigits(-1234567890, 1234567890));

  writeln;

  // TODO Done erwartet Zeile für printInfo // Test für printInfos
  // Testcase 1
  i := 0;
  writeln('Test mit ', i,
    ', Positiv : True, Quadraht :True, Wurzel: 0, Ziffern: 0, Gleiche Ziffern in Zahl und Wurzel: 0');
  write('Ergebnis: ');
  printInfos(i);
  writeln; // Testcase 2
  i := 9;
  writeln('Test mit ', i,
    ', Positiv : True, Quadraht : True, Wurzel: 3, Ziffern: 9, Gleiche Ziffern in Zahl und Wurzel: -');
  write('Ergebnis: ');
  printInfos(i);
  writeln; // Testcase 3
  i := 121;
  writeln('Test mit ', i,
    ', Positiv : True, Quadraht : True, Wurzel: 11, Ziffern: 12, Gleiche Ziffern in Zahl und Wurzel: 1');
  write('Ergebnis: ');
  printInfos(i);
  writeln; // Testcase 4
  i := -169;
  writeln('Test mit ', i,
    ', Positiv : False, Quadraht : False, Wurzel: -, Ziffern: 169, Gleiche Ziffern in Zahl und Wurzel: -');
  write('Ergebnis: ');
  printInfos(i);
  writeln; // Testcase 5
  i := 2147483647;
  writeln('Test mit ', i,
    ', Positiv : True, Quadraht :False, Wurzel: -, Ziffern: 1234678, Gleiche Ziffern in Zahl und Wurzel: -');
  write('Ergebnis: ');
  printInfos(i);
  writeln;
  readln;

end.
