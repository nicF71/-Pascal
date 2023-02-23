{ Uebung 04
  Erstellt von: Justin Walger, Nic Frigius
  Erstellt am: 11.11.2021
  Das Programm soll zu Zahlen (die durch 2 Grenzen bestimmt werden) berechnungen anstellen und diese dann ausgeben.
}

program ueb_04;

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses
  System.math;

const
  { Hier werden die Grenzen definiert }
  LOWER_BORDER = 112233;
  UPPER_BORDER = 112299;

var
  aktuelleZahl: cardinal; { Was ist die aktuellle Zahl? }
  gerade: Boolean; { Ist eine Zahl gerade? }
  aktuelleZahlSpeicher: cardinal; { Wird für VOllkommenheit benötigt }
  vollkommen: Boolean; { Ist eine Zahl vollkommen? }
  teiler: cardinal; { Für die Berechnung, ob eine Zahl gerade ist }
  vorkommenInsgesamt: Boolean;  //kommt eine Zahl überhaupt mehfach vor?
  ziffer: byte;
  kopieZahl: cardinal;
  vorkommen: byte;
  rest: cardinal;
  countZiff: byte;
  dezimalstelle: cardinal;
  anfang: cardinal;

  // TODO DONE: Schleifen sinnvoll verwenden, LOWER-UPPER in for-Schleife

begin
  for aktuelleZahl := LOWER_BORDER to UPPER_BORDER do
  begin
    // Es wird geprüft, ob die aktuelle Zahl gerade ist. Dieser Wert wird als Boolean gespeichert.
    gerade := aktuelleZahl mod 2 = 0;

    // Hier wird geprüft, ob eine Zahl vollkommen ist. Auch das wird alls Boolean gespeichert.
    teiler := 1;
    aktuelleZahlSpeicher := 0;

    while teiler < aktuelleZahl do
    begin
      if aktuelleZahl mod teiler = 0 then
      begin
        aktuelleZahlSpeicher := aktuelleZahlSpeicher + teiler;
      end;
      teiler := teiler + 1;
    end;
    vollkommen := aktuelleZahlSpeicher = aktuelleZahl;

    // Ausgabe der ersten beiden Berechnungen
    write(aktuelleZahl:3, ' Ist gerade: ', gerade:5, ', vollkommen: ',
      vollkommen:5);



    // Man geht dei Zahlen von 0-9 durch und schaut, ob eine doppelt vorkommt. Wenn ja, gibt man diese direkt aus


    write(', mehrfache Zahlen:');
      vorkommenInsgesamt := false;
      for ziffer := 0 to 9 do
      begin
        kopieZahl := aktuelleZahl;
        vorkommen := 0;
        repeat
        begin
          rest := (kopieZahl mod 10);
          kopieZahl := kopieZahl div 10;
          if rest = ziffer then
            inc(vorkommen);
        end;
        until kopieZahl = 0;
        if vorkommen > 1 then
        begin
          write(ziffer);
          vorkommenInsgesamt := True;
        end;

      end;
      if not vorkommenInsgesamt then

        write('-');

         writeln('');
    end;

  { TODO DONE: Mehrfachvorkommen vereinfachen
    vorkommenInsgesamt = false
    Schleife ziffer von 0 bis 9
    kopieZahl = zahl
    vorkommen = 0

    Schleife bis kopieZahl = 0
    kopieZahl mod 10 -> Rest
    Rest wird mit ziffer verglichen, wenn rest = ziffer inc(vorkommen)
    kopieZahl div 10 -> letzte Ziffer wird abschnitten

    wenn vorkommen > 1 gebe ziffer aus und vorkommenInsgesamt auf true setzen

    wenn nicht vorkommenInsgesamt dann write(-)
  }

  readln;

end.
