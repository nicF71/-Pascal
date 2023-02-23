program ueb5_korrigiert;

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses
  System.SysUtils;

var
  input: char;
  stringA: string;
  stringALower: string;
  satzEingegeben: boolean;
  stringAUpper: string;
  anzahlGrossbuchstaben: integer;
  stringAD: string;
  i, pos: integer;
  stelleLeerzeichen: integer;
  laengeWort: integer;

begin
  repeat // Schleife, die l�uft, bis Nutzer X dr�ckt
  begin
    writeln('Welche Aktion willst du ausf�hren?', #13#10, 'A) Satz eingeben',
      #13#10, 'B) Anzahl Gro�buchstaben im Satz bestimmen', #13#10,
      'C) Gro�-/Kleinschreibung im Satz vertauschen', #13#10,
      'D) Alle W�rter eink�rzen', #13#10, 'X) Ende');
    readln(input);
    input := upcase(input);

    case input of // Mehrfachauswahl einer der Buchstaben
      'A':
        begin // Aufforderung den Satz einzugeben
          writeln('Gib bitte einen Satz ein');
          readln(stringA);
          satzEingegeben := True;
        end;
    end;

    if satzEingegeben then // Falls er einen Satz eingegben hat
    begin
      case input of
        'B':
          begin // Hier werden die Gro�buchstaben gez�hlt.
            anzahlGrossbuchstaben := 0;

            for i := 1 to length(stringA) do
              if uppercase(stringA[i]) <> lowercase(stringA[i]) then
              // wenn der Buchstabe gro� <> dem Buchstaben klein ist (also keine Sonderzeichen etc.
              begin

                begin
                  if stringA[i] = uppercase(stringA[i]) then
                  // Wenn Buchstabe gro� ist, +1 Anzahl GRo�buchstaben
                  begin
                    inc(anzahlGrossbuchstaben);
                  end;
                end;
              end;
            writeln(anzahlGrossbuchstaben, ' Gro�buchstaben im Satz gefunden');
          end;

        'C':
          begin
            stringALower := lowercase(stringA);
            stringAUpper := uppercase(stringA);
            for i := 1 to length(stringA) do
            // F�r jeden Buchstaben im String, falls er gro� ist wird er klein und andersrum
            begin
              if stringA[i] = stringAUpper[i] then
              begin
                stringA[i] := stringALower[i];

              end
              else if stringA[i] = stringALower[i] then
              begin
                stringA[i] := stringAUpper[i];
              end;

            end;
            writeln(stringA);
          end;

        'D':
          begin
            stringAD := stringA; // String kopieren
            stelleLeerzeichen := 2;
            // An welcher Stelle ist das erste Leerzeichen fr�hstens
            pos := 1; // An welcher Position ist der erste Buchstabe fr�hstens?
            stringAD := stringAD + '  ';

            repeat // Bis wir mit der stelleLeerzeichen am Ende des Strings sind:

              if (stringAD[stelleLeerzeichen] = ' ') then
              // falls es ein Leerzeichen an der stelle gibt.
              begin
                laengeWort := stelleLeerzeichen - pos; // L�nge Wort bestimmen

                if laengeWort < 2 then // Falls Wort <2 wird nichts gel�scht.
                begin
                  pos := pos + 2; // Zum n��chsten Wortanfang gehen

                end;

                if laengeWort >= 2 then
                // falls >2 muss auch SCH getestet werden
                begin

                  if (uppercase(copy(stringAD, pos, 2)) = 'SP') or
                    (uppercase(copy(stringAD, pos, 2)) = 'ST') then
                  begin
                    delete(stringAD, pos + 2, laengeWort - 2);
                    pos := pos + 3;
                  end

                  else
                  begin
                    if uppercase(copy(stringAD, pos, 3)) = 'SCH' then
                    // test nach sch
                    begin
                      delete(stringAD, pos + 3, laengeWort - 3);
                      pos := pos + 4;
                    end
                    else
                    begin
                      delete(stringAD, pos + 1, laengeWort - 1);
                      pos := pos + 2;
                    end;
                  end;
                end;

                stelleLeerzeichen := pos;
              end
              else
              begin
                inc(stelleLeerzeichen);
                // falls kein Leerzeichen bei stringAD[stelleLeerzeichen] -> +1
              end;

            until stelleLeerzeichen >= length(stringAD);
            writeln(stringAD);
          end;

      end;
    end;
  end;

  until input = 'X'; // Abbruchbedingung

end.
