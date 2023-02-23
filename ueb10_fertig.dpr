program ueb10_fertig;

{$APPTYPE CONSOLE}
{$R+,Q+,X-,I-}
{
 - Erstellt von Nic Frigius und Justin Walger
  - Zuletzt bearbeitet am 12.01.2022

  Dieses Programm liest eine Textdatei mit Studentendaten ein. Der Nutzer kann
  dann gewisse Berechnungen durchführen und diese als neue Datei speichern, oder an eine
  bestehende Datei dranhängne / diese überschreiben.

}

uses
  SysUtils,
  windows;

// Line Break zur besseren Übersicht!
const
  sLineBreak = {$IFDEF LINUX} AnsiChar(#10) {$ENDIF}
{$IFDEF MSWINDOWS} AnsiString(#13#10) {$ENDIF};

  // Typen, die die entsprechende Fehlermeldung ausgeben
type
  TErgebnissLesen = (lesenOeffnenErfolg, lesenSchliessenErfolg, lesenOeffnenFehler, lesenSchliessenFehler,
    lesenFalschesFormatFehler, lesenDateNichtGefundenFehler);
  TErgebnissSchreiben = (schreibenOeffnenErfolg, schreibenSchliessenErfolg, schreibenSchreibenErfolg,
    schreibenSchliessenFehler, schreibenErstellenFehler, schreibenHinzufuegenErfolg, schreibenUeberschreibenErfolg);
  TErgebnissAuswertung = (I, A, D, Fehler);

  // Buchstabenmengentyp zur Prüfung ob etwas nur aus Buchstaben besteht.
  setBuchstaben = Set of AnsiChar;

  // Hier einen Record für den Student mit Unterrecords.
  TStudent = record
    MatrNr: record
      kuerzel: string;
      zahl: integer;
    end;

    Name: record
      vorname: string;
      nachname: string;
    end;

    Note: double;
  end;

  // Klassische Listentypen
  PList = ^TElement;

  TElement = record
    Value: TStudent;
    Next: PList;
  end;

  // Globale Variable für den Speicherverbrauch
var
  speicherverbrauch: integer;

  // Setzt die Textfarbe der Konsole.
  // @param
  // color - zu setzender Farbwert
procedure setTextColor(color: word);
begin
  if SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color) then;
end;

// Diese Prozedur gibt die den Status des öffnens der Datei aus
// @param
// status: Status des Einlesens der Datei
procedure writeStatusRead(status: TErgebnissLesen);
begin
  case status of

    lesenOeffnenErfolg:
      begin
        setTextColor(10);
        writeln('Datei erfolgreich geöffnet');
      end;
    lesenOeffnenFehler:
      begin
        setTextColor(12);
        writeln('Fehler beim Öffnen der Datei');
      end;
    lesenSchliessenFehler:
      begin
        setTextColor(12);
        writeln('Fehler beim Schließen der Datei');
      end;
    lesenSchliessenErfolg:
      begin
        setTextColor(10);
        writeln('Datei erfolgreich geschlossen');

      end;
    lesenFalschesFormatFehler:
      begin
        setTextColor(12);
        writeln('Datei hat ein falsches Format');
      end;
    lesenDateNichtGefundenFehler:
      begin
        setTextColor(12);
        writeln('Datei nicht gefunden');
      end;
  end;
       setTextColor(7);
end;

// Diese Prozedur gibt die den Status des schreibens der Datei aus
// @param
// status -  Status des Schreibens der Datei
procedure writeStatusWrite(status: TErgebnissSchreiben);
begin
  case status of

    schreibenOeffnenErfolg:
      begin
        setTextColor(10);
        writeln('Datei erfolgreich geschrieben');
      end;
    schreibenSchreibenErfolg:
      begin
        setTextColor(12);
        writeln('Fehler beim Öffnen der Datei');
      end;
    schreibenSchliessenFehler:
      begin
        setTextColor(12);
        writeln('Fehler beim Schließen der Datei');
      end;
    schreibenSchliessenErfolg:
      begin
        setTextColor(10);
        writeln('Datei erfolgreich geschlossen');

      end;
    schreibenUeberschreibenErfolg:
      begin
        setTextColor(10);
        writeln('Datei erfolgreich überschrieben');

      end;
    schreibenHinzufuegenErfolg:
      begin
        setTextColor(10);
        writeln('Datei erfolgreich angehängt');

      end;
    schreibenErstellenFehler:
      begin
        setTextColor(12);
        writeln('Fehler beim Erstellen der Datei');
      end;
  end;
        setTextColor(7);

end;

// Diese Funktion gibt - je nach case - die Berechnungen der minimalen, maximalen und durchschnitts
// Note aus
// @param
// status - Ergebnissstatus der Auswertung
procedure writeStatusAuswertung(status: TErgebnissAuswertung);
begin
  case status of
    Fehler:
      begin
        setTextColor(12);
        writeln('Keine gültige Eingabe');
        setTextColor(7);
      end;

  end;

end;

// Diese Funktion wandelt die einzelnen Zeilen der Datei in ein Record um, bzw fügt die
// Eigenschaften in der Zeile dem Record hinzu
// @param
// zeile - Die Zeile, die in einen Record umgewandelt werden soll.
// @return
// Diese Funktion git den Record des Studenten aus
function lineToRecord(zeile: string): TStudent;
var
  Name, matrikelNummer: string;
  komma, komma2: byte; //Positionen der Komma
  leerzeichen: byte; //Position des Leerzeichens
  student: TStudent;
  fehler: integer; //Notwendig zur Umwandlung per val

begin

  komma := pos(',', zeile);
  komma2 := pos(',', zeile, komma + 1);
  matrikelNummer := copy(zeile, 1, komma - 1);
  name := copy(zeile, komma + 1, (komma2 - 1) - (komma));
  leerzeichen := pos(' ', name);

  student.Name.vorname := copy(name, 1, leerzeichen);
  student.Name.nachname := copy(name, leerzeichen + 1);
  student.MatrNr.kuerzel := copy(matrikelNummer, 1, length(matrikelNummer) - 6);
  student.MatrNr.zahl :=
    strtoint(copy(matrikelNummer, length(student.MatrNr.kuerzel) + 1,
    length(matrikelNummer) - length(student.MatrNr.kuerzel)));
  val(copy(zeile, komma2 + 1, length(zeile)), student.Note, fehler);
  lineToRecord := student;

end;

// Diese Funktion prüft, ob alle Angaben im Record richtig sind
// @param
// student  - Record mit den Daten eines Students
// @return
// Ein Wharehietswert, ob alle Angaben im Record valide sind
function checkRecord(student: TStudent): Boolean;
var
  vornameValide, nachnameValide, kuerzelValide, zahlValide, noteValide: Boolean;
  StrNote: string;
  buchstaben: set of AnsiChar;
  I: byte;
begin
  kuerzelValide := False;
  buchstaben := ['a' .. 'z', 'A' .. 'Z'];
  noteValide := False;
  vornameValide := (length(student.Name.vorname) > 2) and
    (pos(',', student.Name.vorname) = 0);
  nachnameValide := (length(student.Name.nachname) > 2) and
    (pos(',', student.Name.nachname) = 0);

  if (length(student.MatrNr.kuerzel) > 1) and
    (length(student.MatrNr.kuerzel) < 5) then
  begin
    kuerzelValide := True;
    for I := 1 to (length(student.MatrNr.kuerzel)) do
      if not CharInSet(student.MatrNr.kuerzel[I], buchstaben) then
      begin
        kuerzelValide := False;
      end;
  end;
  zahlValide := (student.MatrNr.zahl > 99999) and
    (student.MatrNr.zahl < 1000000);
  StrNote := FormatFloat('0.0', student.Note);

  if length(StrNote) = 3 then
    noteValide := ((StrNote[1] = '5') and (StrNote[3] = '0')) or
      ((student.Note >= 1) and (student.Note <= 4));

  checkRecord := vornameValide and nachnameValide and kuerzelValide and
    zahlValide and noteValide;

end;

// Diese Funktion fügt das valide Record eienr Liste hinzu
// @param
// First - erstes Element der Liste
// student - Record des Studenten
// @out
// First - Der neue Anfangszeiger der Liste
procedure AddElement(var First: PList; student: TStudent);
var
  Last, Element: PList;
begin
  new(Element);
    inc(speicherverbrauch);
  Element^.Value.MatrNr.kuerzel := student.MatrNr.kuerzel;
  Element^.Value.MatrNr.zahl := student.MatrNr.zahl;
  Element^.Value.Name.vorname := student.Name.vorname;
  Element^.Value.Name.nachname := student.Name.nachname;
  Element^.Value.Note := student.Note;
  Element^.Next := First;
  Element^.Next := nil;
  if First = nil then
    First := Element
  else
  begin
    Last := First;
    while Last^.Next <> nil do
      Last := Last^.Next;
    Last^.Next := Element;
  end;
end; { AppendElement }

// Diese Prozedur gibt die Zeichen der linearen Liste aus
// @param
// First - Der Zeiger auf das erste Element der Liste
procedure WriteList(First: PList);
var
  RunPointer: PList;

begin
  RunPointer := First;
  writeln('Listeneinträge:');
  While RunPointer <> nil do
  begin
    writeln;
    write(RunPointer^.Value.Name.vorname, RunPointer^.Value.Name.nachname, ' (',
      RunPointer^.Value.MatrNr.kuerzel, RunPointer^.Value.MatrNr.zahl,
      ') hat die Note ', RunPointer^.Value.Note:0:1);
    RunPointer := RunPointer^.Next;
  end;
  writeln;
end; { WriteList }

// Diese Prozedur liest die Datei Zeile für Zeile und fügt die Studenten der Liste hinzu
// @param
// eingabe - Der Name der Datei, welche eingelesen werden soll
// datei - die Datei selber
// First - der Zeiger auf das erste Element der Lsite
procedure readFile(eingabe: string; var datei: text; var First: PList);
var
  zeile: string;
  student: TStudent;
begin

  AssignFile(datei, eingabe);
  Reset(datei);

  while not Eof(datei) do
  begin
    readln(datei, zeile);
    try
      student := lineToRecord(zeile);
    except
      writeStatusRead(lesenFalschesFormatFehler);
      raISE
    end;
    if not(checkRecord(student)) then
    begin

      writeStatusRead(lesenFalschesFormatFehler);
      Raise Exception.Create('');
    end
    else
    begin
      AddElement(First, student);
    end;
  end;
  writeStatusRead(lesenOeffnenErfolg);

  try
    closeFile(datei);
  except
    writeStatusRead(lesenSchliessenFehler);
    raise;
  end;

end;

// Diese Funktion sucht die beste Note der Datei raus
// @param
// First - Zeiger auf das erste Element der Liste
// @return
// Die beste Note der Datei
function getMinimum(First: PList): double;
var
  RunPointer: PList;
  minimum: double;
begin
  RunPointer := First;
  minimum := RunPointer^.Value.Note;
  While RunPointer <> nil do
  begin
    if RunPointer^.Value.Note < minimum then
      minimum := RunPointer^.Value.Note;
    RunPointer := RunPointer^.Next;
  end;
  getMinimum := minimum;

end;

// Diese Funktion sucht die schlechteste Note der Datei raus
// @param
// First - eiger auf das erste Element der Liste
// @return
// Die beste Note der Datei
function getMaximum(First: PList): double;
var
  RunPointer: PList;
  maximum: double;
begin
  RunPointer := First;
  maximum := RunPointer^.Value.Note;
  While RunPointer <> nil do
  begin
    if RunPointer^.Value.Note > maximum then
      maximum := RunPointer^.Value.Note;
    RunPointer := RunPointer^.Next;
  end;
  getMaximum := maximum;

end;

// Diese Funktion berechnet den Durchschnitt aller Noten in der Datei
// @param
// First - Zeiger auf das erste Element der Liste
// @return
// Der Durchschnitt der Noten der Datei
function getMean(First: PList): double;
var
  RunPointer: PList;
  summe: double;
begin
  summe := 0;
  RunPointer := First;
  While RunPointer <> nil do
  begin
    summe := summe + RunPointer^.Value.Note;
    RunPointer := RunPointer^.Next;
  end;
  getMean := summe / speicherverbrauch;

end;

// Diese Funktion gibt die Berechnungen aus
// eingabe - die Eingabe des benutzers, was er berechnet haben möchte
// First - erstes Element der Liste
// @return
// Das berechnete Ergebnis
function doCalculations(eingabe: string; First: PList): string;
begin
  if length(eingabe) < 2 then
  begin
    case uppercase(eingabe)[1] of
      'I':
        begin

          doCalculations := sLineBreak + 'shutdown /p';
        end;
      'A':
        begin
          doCalculations := sLineBreak + 'Die maximale Note ist: ' +
            floattostr(getMaximum(First))

        end;
      'D':
        begin
          doCalculations := sLineBreak + 'Die durchschnittliche Note ist: ' +
            floattostr(getMean(First));
        end;
    else
      begin
        Raise Exception.Create('');
      end;

    end;
  end
  else
  begin
    Raise Exception.Create('');
  end;

end;

// Diese Prozedur speichert die ausgerechneten Werte entweder in einer vorhandenen Datei und
// hängt sie dort an, oder es überschreibt den Inhalt der vorhandenen, oder es erstellt eine
// neue Datei
// @param
// auswertungen -  Die erhaltene Auswertung als String
procedure writeResults(auswertungen: string);
var
  eingabe, eingabe2: string;
  datei: text;
begin
  writeln('In welche Datei möchtest du die Auswertungen schreiben?');
  readln(eingabe);
  // Wenn die Datei schon existiert, fragen ob anhängen oder neu erstellen
  if fileExists(eingabe) then
  begin
    writeln('Soll an die Datei angehängt (a) oder der Inhalt neu (n) erstellt werden?');
    readln(eingabe2);
    // Versuchen die Datei zu assignen.
    if length(eingabe2) = 1 then
    begin
      try
        AssignFile(datei, eingabe);
        case eingabe2[1] of
          'a':
            begin
              try
                Append(datei);
                writeln;
                writeln(datei, auswertungen);
                closeFile(datei);
                writeStatusWrite(schreibenHinzufuegenErfolg);
                writeStatusWrite(schreibenSchliessenErfolg);
              except
                writeStatusWrite(schreibenSchreibenErfolg);

              end;
            end;
          'n':
            begin
              try
                Rewrite(datei);
                writeln(datei, auswertungen);
                closeFile(datei);
                writeStatusWrite(schreibenUeberschreibenErfolg);
                writeStatusWrite(schreibenSchliessenErfolg);
              except
                writeStatusWrite(schreibenSchreibenErfolg);
              end;

            end;
          // Fehlermeldung ausgeben, wenn datei nicht assigned werden kann.
        else
          begin
            writeStatusAuswertung(Fehler);

          end;

        end;

      except
        writeStatusWrite(schreibenErstellenFehler);
      end;
    end
    else
    begin
      writeStatusAuswertung(Fehler);
    end;

  end
  else
  begin
    try
      AssignFile(datei, eingabe);

    except
      writeStatusWrite(schreibenErstellenFehler);

    end;
    try
      Rewrite(datei);
      writeln(datei, auswertungen);
      writeStatusWrite(schreibenOeffnenErfolg);
    except
      writeStatusWrite(schreibenSchreibenErfolg);

    end;
    try
      closeFile(datei);
      writeStatusWrite(schreibenSchliessenErfolg);

    except
      writeStatusWrite(schreibenSchliessenFehler);

    end;

  end;

end;

// Diese Prozedur gibt den Speicher der Liste wieder Frei
// @param
// First - Zeiger auf das erste Element der Liste
procedure DisposeList(var First: PList);
var
  RunPointer: PList;
begin
  While First <> nil do
  begin
    RunPointer := First;
    First := RunPointer^.Next;
    Dispose(RunPointer);
    dec(speicherverbrauch);
  end;
end;

// Start Hauptprogramm
var
  // Eingabe des Nutzers
  eingabe: string;
  datei: text;
  First: PList;
  // String, der dann auf die Datei geschrieben wird.
  auswertungen: string;

begin
  First := nil;
  speicherverbrauch := 0;
  writeln('Bitte den Dateinamen der zu lesenden Datei eingeben:');
  readln(eingabe);

  // Nur ausführen, wenn Datei vorhanden
  if fileExists(eingabe) then
  begin
    try
      // Versuchen die Datei einzulesen
      try
        readFile(eingabe, datei, First);
        WriteList(First);
        // Wenn das nicht klappt, Fehlermeldung ausgeben
      except
        writeStatusRead(lesenOeffnenFehler);
        raise // Damit der zweite Part mit den Berechnungen nicht durchgeführt wird.
      end;

      // Versuchen die Berechnung durchzuführen und zu schreiben
      try
        writeln('Soll der minimale (I), der maximale (A) oder der Durchschnittswert (D) der Noten berechnet werden?');
        readln(eingabe);
        auswertungen := doCalculations(eingabe, First);
        writeResults(auswertungen);
        // Wenn das nicht klappt, entsprechende Fehlermeldung ausgeben.
      except
        writeStatusAuswertung(Fehler);
      end;
    except

    end;

  end

  // Wenn DAtei nicht vorhanden, entsprechenden Fehlerstatus ausgeben
  else
  begin
    writeStatusRead(lesenDateNichtGefundenFehler);
  end;

  // Liste freigeben, Speicher checken.
  DisposeList(First);
  writeln(speicherverbrauch);
  readln;

end.

