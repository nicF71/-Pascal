// Aufgabe 9
//Erstellt von: Justin Walger und Nic Frigius
//Erstellt am: 02.01.2022
//Zuletzt bearbeitet am: 05.01.2022
//Dieses Programm ist der Einstieg in das Arbeiten mit zeigern

{$APPTYPE CONSOLE}
{$R+,Q+,X-}
program ueb09_01;

uses
  System.SysUtils;

{
  16) Zeiger koennen auf alles moegliche zeigen - auch auf einen Record.
  Z.B. auch auf einen Record, der einen Bytewert und einen Zeiger vom Typ
  Zeiger auf diesen Record beinhaltet. Legt Euch einen passenden Typ dazu an!
  Der Typ Zeiger auf diesen Record muss dazu natuerlich vorab deklariert werden.
  Deklariert folgend zwei Variablen vom Typ Zeiger auf den Record.
}

type
  // 1)  Legt einen Typ fuer einen Zeiger auf eine Bytevariable an.
  PByteZeiger = ^Byte;

  // 16
  PList = ^TElement;

  TElement = record
    Value: Byte;
    Next: PList;

  end;

  // 7)  Legt nun einen Typ fuer einen Record mit 3 Bytewerten an.
  TDreiByteWerte = record
    wert1: Byte;
    wert2: Byte;
    wert3: Byte;
  end;

  // 11) Legt einen weiteren Typ fuer einen Record mit 3 Integerwerten sowie einen Typ
  // Zeiger auf integer an.
  PIntegerZeiger = ^Integer;

  TDreiIntWerte = record
    wert1Int: Integer;
    wert2Int: Integer;
    wert3Int: Integer;
  end;

var
  // 2)  Deklariert eine Variable vom Typ byte und 2 Variablen vom Typ Zeiger auf byte.
  byteVariable: Byte;
  byteZeiger1, byteZeiger2: PByteZeiger;

  // 8)  Deklariert Euch eine Variable von diesem Recordtyp und drei weitere Variablen vom Typ
  // Zeiger auf Byte.
  byteRecordVariable: TDreiByteWerte;
  byteZeiger3, byteZeiger4, byteZeiger5: PByteZeiger;

  // 12) Deklariert Euch eine Variable vom neuen Recordtyp und drei weitere Variablen vom Typ
  // Zeiger auf integer.
  integerRecordVariable: TDreiIntWerte;
  intZeiger1, intZeiger2, intZeiger3: PIntegerZeiger;

  // 16 Deklartiert folgend zwei Variablen vom Typ Zeiger auf den Record
  recordVariable1: PList;
  recordVariable2: PList;

  {
   15) Legt ueber dem Hauptprogramm drei kleine Prozeduren mal2_a, mal2_b und mal2_c an, die jeweils
    einen Parameter haben, dessen Wert im Rumpf mal 2 genommen wird.
    Die erste Prozedur soll dabei einen Bytewert als Wertparameter bekommen, die zweite Prozedur
    einen Bytewert als Referenzparameter und die dritte Prozedur einen Zeiger auf einen Bytewert.
    Ergaenzt danach dreimal nacheinander folgenden Code:
    - das Setzen einer Bytevariable auf den Wert 3
    - einen Aufruf einer der Prozeduren mit diesem Bytewert (jede 1x)
    - eine Ausgabe des Bytewertes nach dem Aufruf mit writeln

    FRAGE: Welche Erkenntnis kann man aus den ausgegebenen Werten ziehen?
    AW: Bei der ersten Funktion haben wir nur einen Werteparameter, deshalb wird dieser außerhalb der
    Funktion nicht verändert. Bei zwei haben wir jedoch einen Referenzparameter, deshalb wird dieser verändert.
    Aber auch bei Prozedur c ist der Wert verändert worden! Das heißt, wenn wir innerhalb einer Prozedur
    einen  Wert im Heap verändert, wird dieser auch außerhalb der Prozedur verändert.
  }

procedure mal2_a(a: Byte);
begin
  a := a * 2;
end;

procedure mal2_b(var b: Byte);
begin
  b := b * 2;
end;

procedure mal2_c(c: PByteZeiger);
begin
  c^ := c^ * 2;
end;

begin
  // 3)  Belegt die Bytevariable mit dem Wert 3 und lasst beide Zeiger auf diese Variable zeigen.
  // Hinweis: Ein new ist hier nicht erforderlich!
  byteVariable := 3;
  byteZeiger1 := @byteVariable;
  byteZeiger2 := @byteVariable;

  // 4)  Gebt mit writeln die Bytevariable, die dereferenzierten Zeigervariablen sowie die Adressen,
  // auf die die Zeigervariablen zeigen durch Leerzeichen getrennt aus (insg. also 5 Werte).
  writeln('AUFGABE 4');
  writeln(byteVariable, ' ', byteZeiger1^, ' ', byteZeiger2^, ' ',
    uint64(byteZeiger1), ' ', uint64(byteZeiger2));
  // readln;

  // 5)  Setzt jetzt den Wert, auf den die erste Zeigervariable zeigt, von 3 auf 5.
  new(byteZeiger1);
  byteZeiger1^ := 5;

  // 6)  Wiederholt dieselbe Ausgabe der 5 Werte wie in Schritt 4.
  // FRAGE: Was hat sich in der Ausgabe geaendert?
  // ANTWORT: byteZeiger1 ist jetzt 5, uint64(byteZeiger1) verweist auf einen anderen Speicherplatz
  // FRAGE: Warum haben sich genau diese Werte geaendert?
  // AW: Wegen der Dereferenzierung. byteZeiger1 verweist nun auf einen neuen Speicherplatz, der nicht mehr den Wert 3 hat.
  writeln;
  writeln('AUFGABE 6');
  writeln(byteVariable, ' ', byteZeiger1^, ' ', byteZeiger2^, ' ',
    uint64(byteZeiger1), ' ', uint64(byteZeiger2));
  // readln;
  dispose(byteZeiger1);

  // 9)  Lasst die drei neuen Zeiger jetzt jeweils auf einen der drei Bytewerte aus dem Record zeigen.
  byteZeiger3 := @byteRecordVariable.wert1;
  byteZeiger4 := @byteRecordVariable.wert2;
  byteZeiger5 := @byteRecordVariable.wert3;

  // 10) Lasst Euch die Adressen und die Inhalte der drei Zeiger jeweils durch Leerzeichen getrennt
  // ausgeben (also insg. 6 Werte).
  // FRAGE: Was faellt bei den Adressen auf?
  // AW: Die Adressen sind alle genau 1 voneinander entfernt
  // FRAGE: Welche Inhalte werden ausgegeben? Warum genau diese?
  // AW: Der Wert der drei Zeiger ist 0, da der entsprechende Record Wert noch nicht initialisiert wurde (?)
  // Dann werden die Adressen des Speichers im Heap aúsgegeben
    writeln;
  writeln('AUFGABE 10');
  writeln(byteZeiger3^, ' ', byteZeiger4^, ' ', byteZeiger5^, ' ',
    uint64(byteZeiger3), ' ', uint64(byteZeiger4), ' ', uint64(byteZeiger5));
  // readln;

  // 13) Lasst dann die drei neuen Zeiger jeweils auf einen der drei Integerwerte aus dem Record zeigen.
  intZeiger1 := @integerRecordVariable.wert1Int;
  intZeiger2 := @integerRecordVariable.wert2Int;
  intZeiger3 := @integerRecordVariable.wert3Int;

  // 14) Lasst Euch die Adressen, auf die die drei Integer-Zeiger zeigen jeweils durch Leerzeichen getrennt ausgeben
  // (also insg. 3 Werte).
  // FRAGE: Was faellt bei den Adressen diesmal auf, auch im Vergleich zu vorher?
  // AW: Die Adressen haben nun einen Abstand von 4, weil ja jetzt jeweils Platz für einen Integer im Heap reserviert wird.
    writeln;
  writeln('AUFGABE 14');
  writeln(uint64(intZeiger1), ' ', uint64(intZeiger2), ' ', uint64(intZeiger3));
  // readln;

  // 15 Fortsetzung
    writeln;
  writeln('AUFGABE 15');
  byteVariable := 3;
  mal2_a(byteVariable);
  writeln(byteVariable);
  // readln; //3

  byteVariable := 3;
  mal2_b(byteVariable);
  writeln(byteVariable);
  // readln; //6

  byteVariable := 3;
  byteZeiger1 := @byteVariable;
  mal2_c(byteZeiger1);
  writeln(byteZeiger1^);
  // readln;   //6

  {
    16)
    Holt Euch dann mit der Funktion new(...) jeweils Speicher fuer den Record, auf den die Zeiger zeigen.
    Belegt bei beiden Zeigern auf die Records den Bytewert mit einer beliebigen (aber verschiedenen) Zahl.
    Lasst dann den im Record enthaltenen Zeiger der ersten Variable auf den zweiten Record zeigen und
    den Zeiger der zweiten Variable auf nil. Schon haben wir unsere erste kleine Liste gebaut!
  }
  new(recordVariable1);
  new(recordVariable2);
  recordVariable1^.Value := 1;
  recordVariable2^.Value := 2;
  recordVariable1^.Next := recordVariable2;
  recordVariable2^.Next := nil;

  {
    17) Lasst Euch mit writeln die beiden Bytewerte ausgeben. Ihr duerft dabei allerdings nur den ersten Zeiger
    benutzen!!
    FRAGE: Koennte man auch beide Bytewerte ausgeben, wenn man nur den zweiten Zeiger benutzen duerfte?
    Falls ja: Wie? Falls nein: Warum nicht?
    AW: Nein, weil der Zeiger nur in eine Richtung zeigt. Man kann nur den Wert des aktuellen Zeigers und aller
    weiteren ausgeben (in diesem Fall gibt es keine weiteren mehr).
  }
      writeln;
  writeln('AUFGABE 16 UND 17');
  writeln(recordVariable1.Value);
  writeln(recordVariable1^.Next.Value);
  readln;
  dispose(recordVariable1);
  dispose(recordVariable2);

end.
