{
  Uebung 07
  Erstellt von: Justin Walger und Nic Frigius
  Erstellt am: 07.12.2021

}

program Ueb07_fertig;

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses
  SysUtils,
  windows;

const
  FIELDSIZE = 6;
  sLineBreak = {$IFDEF LINUX} AnsiChar(#10) {$ENDIF}
{$IFDEF MSWINDOWS} AnsiString(#13#10) {$ENDIF};
  FARBEROT = 4;
  FARBEBLAU = 1;
  FARBEGRAU = 7;

Type
  TSize = 1 .. FIELDSIZE;
  TState = (stLeer, stSpielerRot, stSpielerBlau);
  TField = array [TSize, TSize] of integer;
  TDIR = (dirNord, dirNordOst, dirOst, dirSüdOst, dirSüd, dirSüdWest, dirWest,
    dirNordWest);

const
  OFFSET_X: array [TDIR] of integer = (0, 1, 1, 1, 0, -1, -1, -1);
  OFFSET_Y: array [TDIR] of integer = (1, 1, 0, -1, -1, -1, 0, 1);

  // Setzt die Ausgabeposition der Konsole auf die angegebene Koordinate.
  // @param
  // x,y - zu setzende Position in der Konsole ab 0/0 = oben links
procedure setConsolePosition(x, y: byte);

var
  coord: _COORD;
begin
  coord.x := x;
  coord.y := y;
  if SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord) then;
end;

// Setzt die Textfarbe der Konsole.
// @param
// color - zu setzender Farbwert
procedure setTextColor(color: word);

begin
  if SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color) then;
end;

// Erstellt das Feld mit je zwei blauen- und roten Steinen in der Mitte gespiegelt angeordnet.
// @param
// field - Tfield, das (noch) leere Spielfeld.
// @out
// Das Spielfield mit den Dimensionen FIELDSIZE und 4 Steinen.
procedure initField(var field: TField);

var
  x, y: integer;
begin
  for x := 1 to FIELDSIZE do
  begin
    for y := 1 to FIELDSIZE do
    begin
      field[x, y] := 0;
    end;
  end;

  field[FIELDSIZE div 2, FIELDSIZE div 2] := 1;
  field[FIELDSIZE div 2 + 1, FIELDSIZE div 2 + 1] := 1;

  field[FIELDSIZE div 2, FIELDSIZE div 2 + 1] := 2;
  field[FIELDSIZE div 2 + 1, FIELDSIZE div 2] := 2;

end;

// Gibt das aktuelle Spielfeld aus
// @param
// field - Tfield, das (nicht mehr leere) Spielfeld.
procedure printField(field: TField);
var
  x, y, i, j: integer;

begin

  // Mit diesem Teil wird die Console bereinigt
  for i := 1 to 16 + FIELDSIZE do
  begin
    setConsolePosition(0, i);
    for j := 1 to 120 do
      write(' ');
    writeln;
  end;
  setConsolePosition(0, 0);

  for x := low(TSize) to FIELDSIZE do
  begin
    for y := low(TSize) to FIELDSIZE do
    begin
      case field[x, y] of
        0:
          begin
            setTextColor(FARBEGRAU);
            write('▓');
          end;
        1:
          begin
            setTextColor(FARBEROT);
            write('▓');
          end;
        2:
          begin
            setTextColor(FARBEBLAU);
            write('▓');
          end;
      end;
    end;
    writeln;
  end;
  writeln;
  setTextColor(7);
end;

// Prüft, ob eine Koordinate valide ist, also ob sie im Feld mit den Dimensionen FIELDSIZE existiert.
// @param
// x,y - Die beiden Integer Koordinaten
// @return
// Einen Wahrheitswert, ob x und y valide Koordinaten sind.
function isValidCoord(x, y: integer): boolean;
begin
  isValidCoord :=  (x >= 1) and (y >= 1) and (x <= FIELDSIZE) and (y <= FIELDSIZE);
end;

// Fragt den Nutzer nach einer x- und einer y Koordinate. Falls der Nutzer 'x' drückt, wird das Spiel beendet.
// @param
// x,y - Die beiden Koordinaten
// cancel - Ein Wahrheitswert, der angibt, ob der Nutzer x gedrückt hat.
// @out
// x,y - Die beiden Koordinaten
// cancel - True, wenn der Nutzer x gedrückt hat
// @return
// Wahrheitswert, ob x und y valide Koordinaten sind
function readInput(var x, y: TSize; var cancel: boolean): boolean;
var
  eingabeX, EingabeY: String;
  code1, code2: integer;

begin

  begin
    setTextColor(7);
      writeln('Bitte eine Zahl zwischen 1 und ', FIELDSIZE,
        ' für die Zeile eingeben oder "X" zum Abbrechen drücken:');
      readln(eingabeX);
      cancel := (lowercase(eingabeX) = 'x');
      val(eingabeX, x, code1);

      // Nur falls für die Zeile kein x eingegeben wurde und x eine valide Koordinate ist wird nach Spalte gefragt.
      if (not cancel) and isValidCoord(x, x) then
      begin
        writeln('Bitte eine Zahl zwischen 1 und ', FIELDSIZE,
          ' für die Spalte eingeben oder "X" zum Abbrechen drücken:');
        readln(EingabeY);
        val(EingabeY, y, code2);
      end;

      cancel := (lowercase(eingabeX) = 'x') or (lowercase(EingabeY) = 'x');
      readInput := (not cancel) and (isValidCoord(x, y));

    end;

end;

// Prüft, ob auf dieses Feld ein Stein gelegt werden kann, indem geschaut wird, ob ein Nachbarfeld belegt ist.
// @param
// x,y - Die beiden Koordinaten, wo der Stein gelegt werden soll
// field - Das Spielfeld, auf das der Stein gelegt werden soll
// @return
// Wahrheitswert, ob an der Stelle x|y ein Stein gelegt werden kann.
function isCellPossible(field: TField; x, y: TSize): boolean;
var
  dir: TDIR;
  xNachbar, yNachbar: integer;

begin
  isCellPossible := false;
  if isValidCoord(x, y) then
  begin
    if field[x, y] = 0 then
    begin
      for dir := low(TDIR) to high(TDIR) do
      begin
        xNachbar := x + OFFSET_X[dir];
        yNachbar := y + OFFSET_Y[dir];

        if (isValidCoord(xNachbar, yNachbar)) and (field[xNachbar, yNachbar] <> 0) then
         isCellPossible :=True;

      end;

    end;
  end;

end;

// Legt einen Stein an der Stelle x|y
// @param
// x,y - Die beiden Koordinaten
// field - das Spielfeld, auf das der Stein gelegt werden soll.
// player - TState, gibt an, welcher der beiden Spieler dran ist.
// @out
// field - Das Spielfeld mit einem Stein mehr

procedure setStone(var field: TField; x, y: TSize; player: TState);
begin
  if isCellPossible(field, x, y) and (field[x, y] = 0) then
  begin
    if player = stSpielerRot then
      field[x, y] := 1;
    if player = stSpielerBlau then
      field[x, y] := 2;
  end;

end;

// Tauscht alle umliegenden Steine um die Stelle x|y
// @param
// x,y - Die beiden Koordinaten
// field - das Spielfeld, auf dem die Steine getauscht werden sollen
// @out
// field - Das Spielfeld mit den getauschten Steinen.
procedure switchStones(var field: TField; x, y: TSize);
var
  dir: TDIR;
  xNachbar, yNachbar: integer;
begin

  for dir := low(TDIR) to high(TDIR) do
  begin
    xNachbar := x + OFFSET_X[dir];
    yNachbar := y + OFFSET_Y[dir];

    if isValidCoord(xNachbar, yNachbar) and (field[x, y] = 0) then
    begin

      if field[xNachbar, yNachbar] = 1 then
      begin
        field[xNachbar, yNachbar] := 2;
      end
      else if field[xNachbar, yNachbar] = 2 then
        field[xNachbar, yNachbar] := 1;

    end;

  end;
end;

// Prüft, ob das Spielfeld komplett voll ist.
// @param
// field - das Spielfeld, das geprüft werden soll
// @return
// Wahrheitswert, der sagt, ob das Feld voll ist.
function isFieldFull(field: TField): boolean;

var
  x, y, count: integer;
begin
  count := 0;
  for x := low(TSize) to FIELDSIZE do
  begin
    for y := low(TSize) to FIELDSIZE do
    begin
      if field[x, y] = 0 then
        inc(count);
    end;
  end;

  isFieldFull := count = 0;


end;

// Zählt die Anzahl der blauen und roten Steine und gibt den Gewinner zurück.
// @param
// red, blue - byte, mit Anzahl der roten bzw. blauen Steine
// field - das Spielfeld, auf dem die Steine gezählt werden sollen
// @out
// red,blue- die Anzahl der Steine
// @ return
// Einen TState Wert, der den Gewinner angibt.
function countStones(var red, blue: byte; field: TField): TState;
var
  x, y: byte;

begin
  for x := low(TSize) to FIELDSIZE do
  begin
    for y := low(TSize) to FIELDSIZE do
    begin
      if field[x, y] = 1 then
        inc(red);

      if field[x, y] = 2 then
        inc(blue);

    end;

    if red = blue then
      countStones := stLeer;
    if red > blue then
      countStones := stSpielerRot;
    if red < blue then
      countStones := stSpielerBlau;

  end;

end;

var
  field: TField;
  x, y: TSize;
  cancel, valide: boolean;
  red, blue: byte;
  aktuellerSpieler: TState;

begin

  aktuellerSpieler := stSpielerRot;
  initField(field);
  printField(field);
  writeln('Spieler Rot beginnt!');

  valide := false;

  while not isFieldFull(field) do
  begin
    while not valide do
    begin
    valide := readInput(x, y, cancel);

      if not cancel then
      begin
        if isCellPossible(field, x, y) then
        begin
          switchStones(field, x, y);
          setStone(field, x, y, aktuellerSpieler);
          if aktuellerSpieler = stSpielerRot then
          begin
            aktuellerSpieler := stSpielerBlau;
            printField(field);
            writeln('Spieler Rot hat einen Stein auf die Position ', x, '|', y,
              ' gesetzt.', sLineBreak, sLineBreak,
              'Spieler Blau ist nun an der Reihe!');

          end
          else
          begin
            aktuellerSpieler := stSpielerRot;
            printField(field);
            writeln('Spieler Blau hat einen Stein auf die Position ', x, '|', y,
              ' gesetzt.', sLineBreak, 'Spieler Rot ist nun an der Reihe!');
          end;

        end
        else
        begin
          printField(field);
          writeln('Das ist leider kein valides Feld! Gib bitte valide Koordinaten an!', sLineBreak);
        end;


        valide := isFieldFull(field);;

      end
      else
      if cancel and (not valide) then
      begin
        writeln('Das Spiel wurde abgebrochen!');
        valide := True;

      end;
    end;
  end;

printField(field);
  case countStones(red, blue, field) of

    stSpielerBlau:
      begin
        writeln('Blau hat mit ', blue, ' zu ', red, ' gewonnen');
      end;

    stSpielerRot:
      begin
        writeln('Rot hat mit ', red, ' zu ', blue, ' Steinen gewonnen');
      end;
    stLeer:
      begin
        writeln('Untentschieden! Beide haben ', red, ' Steine auf dem Feld.');
      end;

  end;
  readln;

end.
