{
  Programm Ueb08
  Erstellt am: 20.12.2021
  Zuletzt bearbeitet: 23.12.2021
  Erstellt von: Justin Walger und Nic Frigius
  Zweck: Dieses Programm soll Informationen über Tiere aufnehmen, Speichern und Zusammengefasst wiedergeben.
  Der Benutzer wird gefragt, wie das Tier heißt, ob es gefährlich ist und welche Eigenschaften es hat. Diese
  Informationen werden in einem Record gespeichert und die Records verschiedenener Tiere werden in einem Array
  gespeichert.
}

{
  TODOs
  - DONE Denglisch
  - DONE ueberfluessige Variablen aus Main raus
  - DONE Mengen Operationen nur bei min 2 Tieren
  - DONE Attributes als String nutzen


}

program Ueb8_korrigiert;

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses
  System.SysUtils;

type
  TAttribute = (ATTgross, ATThungrig, ATTniedlich, ATTpelzig, ATTschnell);
  TAttributeSet = set of TAttribute;

  // TTier ist ein einzlnes Tier, die Eigenschaften bestehen aus der Menge TAttributeSet
  TTier = record
    name: string;
    istGefaehrlich: boolean;
    eigenschaften: TAttributeSet;
  end;

const
  ATTRIBUTE_NAMES: array [TAttribute] of string = ('gross', 'hungrig',
    'niedlich', 'pelzig', 'schnell');
  NO_OF_ANIMALS = 2;

type
  // Alle Tiere werden in dem Array TTiere gespeichert, welches aus TTier Werten besteht.
  TTiere = array [1 .. NO_OF_ANIMALS] of TTier;

  // Zum Einlesen des Namens eines Tieres
  // @param
  // Tiername: der Name des Tieres
  // TierNummer: die Nummer des Tieres n(beim ersten Tier 1, beim zweiten 2...)
  // istAbgebrochen: wrid True wenn der Nutzer x drückt
  // @return
  // Ein Wahrheitswert, ob die Eingabe richtig erfolgt ist
  // @out
  // Einen String, mit dem Namen des Tiers, und einen Wahrheitswert, ob abgebrochen wurde.
function readName(var tierName: string; tierNummer: byte;
  var istAbgebrochen: boolean): boolean;
begin
  writeln('Bitte den Namen des Tiers Nummer ', tierNummer, ' eingeben');
  readln(tierName);
  istAbgebrochen := lowercase(tierName) = 'x';
  if not(length(tierName) > 4) and not istAbgebrochen then
  begin
    writeln('Bitte gib einen Namen mit mindestens 5 Zeichen ein oder drücke x zum beenden');
  end
  else if not istAbgebrochen then
  begin
    writeln('alles klar, Tier Nummer ', tierNummer, ' heißt jetzt ', tierName);
    readName := true;
    writeln;
  end;
end;

// Zum Einlesen des Gefaehrlichkeitsstatus des Tiers
// @param
// istGefaehrlich: Gibt an, ob die Eingabe gültig war
// TierNummer: die Nummer des Tieres n(beim ersten Tier 1, beim zweiten 2...)
// istAbgebrochen: wrid True wenn der Nutzer x drückt
// @return
// Ein Wahrheitswert, ob das Tier gefährlich ist oder nicht
// @out
// Ein boolean, ob das Tier gefährlich ist, ein boolean, der angibt, ob abgebrochen wurde, und die Anzahl der Tiere als byte .
function isDangerous(var istGefaehrlich: boolean; tierNummer: byte;
  var istAbgebrochen: boolean; var anzahl: byte): boolean;
var
  eingabe: string;

begin
  writeln('Ist das Tier Nummer ', tierNummer, ' gefährlich?');
  readln(eingabe);
  istAbgebrochen := lowercase(eingabe) = 'x';
  if (uppercase(eingabe) = 'JA') or (uppercase(eingabe) = 'NEIN') then
  begin
    istGefaehrlich := uppercase(eingabe) = 'JA';
    writeln('Alles klar, Tier Nummer ', tierNummer,
      ': Gefährlichkeitsstatus: ', eingabe);
    inc(anzahl);
    isDangerous := true;
  end
  else if not istAbgebrochen then
  begin
    writeln('Das war leider keine gültige Eingabe! Gib JA oder NEIN ein oder drücke x zum beenden.');
    isDangerous := false;
  end;
  writeln;
end;

// Zum Einlesen der Attribute eines Tieres
// @param
// tierEigenschaften: Die Eigenschaften an sich, diese sind in TAttributes vordefiniert
// TierNummer: die Nummer des Tieres n(beim ersten Tier 1, beim zweiten 2...)
// @return
// Gibt True zurück, sobald der Nutzer ein Attribut hinzugefügt und dann 'x' gedrückt hat
// @out
// Eine Menge an Eigenschaften des Tieres
function readAttributes(var tierEigenschaften: TAttributeSet;
  tierNummer: byte): boolean;
var
  eingabe: string;
  alleEigenschaften: TAttributeSet;
  i: TAttribute;
  oper: char;

begin
  repeat

    alleEigenschaften := [ATTgross, ATThungrig, ATTniedlich, ATTpelzig,
      ATTschnell];
    oper := ' ';
    writeln('Welches Attribut möchtest du für Tier Nummer ', tierNummer,
      ' eingeben?');
    writeln('Bitte x drücken, wenn du keine Eigenschaften (mehr) eingeben willst');
    writeln('Zur Verfügung stehen Gross, Hungrig, Niedlich, Pelzig und Schnell.');
    writeln('Mit einem + fügst du Eigenschaften hinzu, mit einem - entfernst du welche.');
    readln(eingabe);
    if length(eingabe) > 0 then
    begin
      oper := eingabe[1];
      delete(eingabe, 1, 1);

      for i := ATTgross to ATTschnell do
      begin
        if lowercase(ATTRIBUTE_NAMES[i]) = lowercase(eingabe) then
        begin

          case oper of
            '+':
              begin
                tierEigenschaften := tierEigenschaften + [i];
                writeln('Alles klar, Tier Nummer ', tierNummer,
                  ' hat jetzt die Eigenschaft ', ATTRIBUTE_NAMES[i]);
                writeln;
              end;
            '-':
              begin
                tierEigenschaften := tierEigenschaften - [i];
                writeln('Alles klar, Tier Nummer ', tierNummer,
                  ' hat jetzt nicht mehr die Eigenschaft ', ATTRIBUTE_NAMES[i]);
                writeln;
              end
          else
            writeln('Bitte gib + oder - zu Beginn an');
          end;
        end;
      end;
    end;
  until lowercase(oper) = 'x';
  readAttributes := true;
  writeln;
end;

// Steuert das gesammte Einlesen und fügt die Tiere dem Array hinzu
// @param
// alleTiere: Array mit allen Tieren
// @return
// Anzahl der Tiere in Byte
// @out
// Ein Typ TTiere, der alle Tiere als Record hat
function readAll(var alleTiere: TTiere): byte;
var
  i, anzahl: byte;
  istAbgebrochen: boolean;

begin
  anzahl := 0;
  istAbgebrochen := false;
  for i := 1 to NO_OF_ANIMALS do
  begin

    while not istAbgebrochen and (not readName(alleTiere[i].name, i, istAbgebrochen)) do
      writeln;

    while not istAbgebrochen and not isDangerous(alleTiere[i].istGefaehrlich, i, istAbgebrochen,
      anzahl) do
      writeln;

    while not istAbgebrochen and (not readAttributes(alleTiere[i].eigenschaften, i)) do
      writeln;

  end;
  if istAbgebrochen then
    writeln('Alles klar, die Eingabe wurde abgebrochen');
  readAll := anzahl;
end;

// Wandelt die Menge der Eigenschaften in einen String um
// @param
// mengeEigenschaften: Die Eigenschaften an sich, diese sind in TAttributes vordefiniert
// @return
// Gibt ein String mit allen Eigenschaften der Tiere zurück
function attributeSetToString(mengeEigenschaften: TAttributeSet): string;
var
  i: TAttribute;
  eigstring: string;
begin
  for i := ATTgross to ATTschnell do
  begin
    if i in mengeEigenschaften then
    begin
      eigstring := eigstring + (ATTRIBUTE_NAMES[i]) + ', ';
    end;
    attributeSetToString := eigstring;
  end;

end;

// Ausgabe eines Tieres
// @param
// tier: Das Tier an sich mit Name, Gefaehrlichkeitsstatus und den Eigenschaften, in einem Record gespeichert

procedure printAnimal(tier: TTier);
var
  i: TAttribute;
begin
  write('Name: ');
  writeln(tier.name);
  write('gefährlich: ');
  writeln(tier.istGefaehrlich);
  write('Eigenschaften: ');
  writeln(attributeSetToString(tier.eigenschaften));
  writeln;
  writeln;

end;

// Ausgabe aller Tiere
// param
// alleTiere: Alle Tiere in einem Array
// anzahlTiere: Anzahl der eingegebenen Tiere
procedure printAllAnimals(alleTiere: TTiere; anzahlTiere: byte);
var
  i: byte;
begin

  for i := 1 to anzahlTiere do
  begin
    writeln(i, '. EINGEGEBENES TIER:');
    printAnimal(alleTiere[i]);
  end;

end;

// Ausgabe aller Attribute die nicht benutzt wurden
// @param
// alleTiere:  Alle Tiere mit ihren Attributen
// anzahlTiere: Die Anzahl der tiere im Aray
// @return
// Gibt zurück welche Attribute kein Tier hat
function calcUnusedAttributes(alleTiere: TTiere; anzahlTiere: byte)
  : TAttributeSet;
var
  alleEigenschaften: TAttributeSet;
  i: byte;

begin
  alleEigenschaften := [ATTgross, ATThungrig, ATTniedlich, ATTpelzig,
    ATTschnell];
  for i := 1 to anzahlTiere do
  begin
    alleEigenschaften := alleEigenschaften - alleTiere[i].eigenschaften;
  end;
  calcUnusedAttributes := alleEigenschaften;

end;

// Ausgabe aller Attribute die mehrere Tiere haben
// @param
// alleTiere:  Alle Tiere mit ihren Attributen
// anzahlTiere: Die Anzahl der tiere im Aray
// @return
// Alle Attribute die mindestens 2 Tiere haben
function calcReusedAttributes(alleTiere: TTiere; anzahlTiere: byte)
  : TAttributeSet;
var
  mehrfacheEigenschaften: TAttributeSet;
  i, j: byte;

begin
  mehrfacheEigenschaften := [];
  for i := 1 to anzahlTiere do
  begin
    for j := 1 to anzahlTiere do
    begin
      if i <> j then
      begin
        mehrfacheEigenschaften := mehrfacheEigenschaften +
          (alleTiere[i].eigenschaften * alleTiere[j].eigenschaften);

      end;
    end;

  end;
  calcReusedAttributes := mehrfacheEigenschaften;

end;

var
  alleTiere: TTiere;
  anzahlTiere: byte;

begin
  anzahlTiere := readAll(alleTiere);
  printAllAnimals(alleTiere, anzahlTiere);
  if anzahlTiere >= 1 then
  begin
    writeln('Ungenutze Attribute: ',
      attributeSetToString(calcUnusedAttributes(alleTiere, anzahlTiere)));
  end;
  if anzahlTiere > 1 then
  begin
    writeln('Mehrfach genutze Attribute: ',
      attributeSetToString(calcReusedAttributes(alleTiere, anzahlTiere)));
  end;

  readln;

end.
