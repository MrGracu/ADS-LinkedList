program ADS_Linkedlist;

uses crt;

type
  lista = ^tlista;
  tlista = record
    imie:string[25];
    nazwisko:string[35];
    wiek:byte;
    pesel:string;
    wsk:lista;
  end;

function empty(pocz:lista):boolean;
begin
  if(pocz = nil) then empty:=true else empty:=false;
end;

procedure dodaj(var pocz, kon:lista);
var
  nowy:lista;
  temp:lista;
begin
  ClrScr;
  writeln('-------------------- DODAJ -------------------');
  nowy := new(lista);
  if(nowy = nil) then
  begin
    writeln('NIE UDALO SIE ZAREZERWOWAC PAMIECI');
    writeln('Wcisnij ENTER, aby wrocic do MENU...');
    readln();
    exit;
  end;
  writeln('+ Podaj imie');
  readln(nowy^.imie);
  writeln('+ Podaj nazwisko');
  readln(nowy^.nazwisko);
  repeat
    writeln('+ Podaj wiek');
    readln(nowy^.wiek);
  until (nowy^.wiek > 0);
  repeat
    writeln('+ Podaj pesel');
    readln(nowy^.pesel);
    temp:=pocz;
    while (temp <> nil) do
    begin
      if(temp^.pesel = nowy^.pesel) then
      begin
        writeln('+ Podany PESEL juz istnieje!');
        nowy^.pesel:='1';
      end;
      temp:=temp^.wsk;
    end;
  until (length(nowy^.pesel) = 11);
  nowy^.wsk:=nil;
  if(pocz = nil) then pocz:=nowy;
  if(kon <> nil) then kon^.wsk:=nowy;
  kon:=nowy;
  writeln('Dodano!');
  writeln('Wcisnij ENTER, aby wrocic do MENU...');
  readln();
end;

procedure usunWszystko(var pocz, kon:lista);
var
  doUsuniecia:lista;
begin
  while (pocz <> nil) do
  begin
    doUsuniecia:=pocz;
    pocz:=pocz^.wsk;
    dispose(doUsuniecia);
  end;
  kon:=nil;
end;

procedure usun(var pocz, kon:lista);
var
  doUsuniecia:lista;
begin
  ClrScr;
  writeln('-------------------- USUN --------------------');
  if(empty(pocz)) then
  begin
    writeln('Lista jest pusta!');
    writeln('Wcisnij ENTER, aby wrocic do MENU...');
    readln();
    exit;
  end;
  doUsuniecia:=pocz;
  pocz:=pocz^.wsk;
  writeln('Usunieto element:');
  writeln();
  writeln(doUsuniecia^.imie,' ',doUsuniecia^.nazwisko);
  writeln('Wiek: ',doUsuniecia^.wiek,' lat');
  writeln('PESEL: ',doUsuniecia^.pesel);
  writeln();
  dispose(doUsuniecia);
  if(pocz = nil) then kon:=nil;
  writeln('Wcisnij ENTER, aby wrocic do MENU...');
  readln();
end;

procedure wypisz(pocz:lista);
var
  i:integer;
begin
  ClrScr;
  writeln('------------------- WYPISZ -------------------');
  if(empty(pocz)) then
  begin
    writeln('Lista jest pusta!');
    writeln('Wcisnij ENTER, aby wrocic do MENU...');
    readln();
    exit;
  end;
  i:=0;
  while (pocz <> nil) do
  begin
    if(i > 3) then
    begin
      writeln('Wcisnij ENTER, aby przejsc dalej...');
      readln();
      ClrScr;
      writeln('------------------ WYPROWADZ -----------------');
      i:=0;
    end;
    writeln('----------------------------------------------');
    writeln(pocz^.imie,' ',pocz^.nazwisko);
    writeln('Wiek: ',pocz^.wiek);
    writeln('PESEL: ',pocz^.pesel);
    writeln('----------------------------------------------');
    pocz:=pocz^.wsk;
    inc(i);
  end;
  writeln('Wcisnij ENTER, aby wrocic do MENU...');
  readln();
end;

procedure zapisz(pocz:lista);
var
  f:textFile;
  tab:Array of tlista;
  s:string;
  i,j:integer;
  temp:tlista;
begin
  ClrScr;
  writeln('------------------- ZAPISZ -------------------');
  if(empty(pocz)) then
  begin
    writeln('Lista jest pusta!');
    writeln('Wcisnij ENTER, aby wrocic do MENU...');
    readln();
    exit;
  end;
  i:=0;
  while (pocz <> nil) do
  begin
    SetLength(tab,length(tab)+1);
    tab[i]:=pocz^;
    pocz:=pocz^.wsk;
    inc(i);
  end;

  for i:=0 to (length(tab)-1) do
  begin
    for j:=1 to (length(tab)-1-i) do
    begin
      if(tab[j-1].pesel > tab[j].pesel) then
      begin
        temp:=tab[j-1];
        tab[j-1]:=tab[j];
        tab[j]:=temp;
      end;
    end;
  end;

  assignFile(f,'osoby.txt');
  rewrite(f);
  for i:=0 to (length(tab)-1) do
  begin
    Str(tab[i].wiek,s);
    s:=tab[i].imie+' '+tab[i].nazwisko+' '+s+' '+tab[i].pesel;
    writeln(f,s);
  end;
  closeFile(f);
  writeln('Zapisano do pliku: osoby.txt');
  writeln();
  writeln('Wcisnij ENTER, aby wrocic do MENU...');
  readln();
end;

procedure wpiszDyn(pocz:lista);
var
  dyn:Array of tlista;
  i:integer;
begin
  ClrScr;
  writeln('-------------------- WPISZ -------------------');
  if(empty(pocz)) then
  begin
    writeln('Lista jest pusta!');
    writeln('Wcisnij ENTER, aby wrocic do MENU...');
    readln();
    exit;
  end;
  i:=0;
  while (pocz <> nil) do
  begin
    SetLength(dyn,length(dyn)+1);
    dyn[i]:=pocz^;
    pocz:=pocz^.wsk;
    writeln('[',i,'] ',dyn[i].imie,' ',dyn[i].nazwisko,' wiek ',dyn[i].wiek,' lat, PESEL: ',dyn[i].pesel);
    inc(i);
  end;
  writeln();
  writeln('Wcisnij ENTER, aby wrocic do MENU...');
  readln();
end;

procedure usunPoImieniu(var pocz,kon:lista);
var
  imie:string[25];
  czyCosUsunieto:boolean;
  temp,nast,poprz:lista;
begin
  ClrScr;
  writeln('-------------------- USUN --------------------');
  if(empty(pocz)) then
  begin
    writeln('Lista jest pusta!');
    writeln('Wcisnij ENTER, aby wrocic do MENU...');
    readln();
    exit;
  end;
  writeln('+ Podaj imie');
  readln(imie);
  czyCosUsunieto:=false;
  nast:=pocz;
  poprz:=nil;
  while (nast <> nil) do
  begin
    if(pocz^.imie = imie) then
    begin
      temp:=pocz;
      nast:=pocz^.wsk;
      pocz:=pocz^.wsk;
      if(pocz = nil) then kon:=nil;
      dispose(temp);
      czyCosUsunieto:=true;
    end else
    begin
      if(nast^.imie = imie) then
      begin
        temp:=nast;
        nast:=nast^.wsk;
        poprz^.wsk:=nast;
        if(nast = nil) then kon:=poprz;
        dispose(temp);
        czyCosUsunieto:=true;
      end else
      begin
        poprz:=nast;
        nast:=nast^.wsk;
      end;
    end;
  end;
  if(czyCosUsunieto) then writeln('Znaleziono i usunieto osoby o podanym imieniu') else writeln('Nie znaleziono elementow o podanym imieniu');
  writeln();
  writeln('Wcisnij ENTER, aby wrocic do MENU...');
  readln();
end;

var
  pocz:lista;
  kon:lista;
  n:integer;
begin
  pocz:=nil;
  kon:=nil;
  repeat
    ClrScr;
    writeln('-------------------- MENU --------------------');
    writeln('Czy lista jest pusta? ',empty(pocz));
    writeln();
    writeln('[1] Dodaj element na koniec kolejki');
    writeln('[2] Usun element z poczatku kolejki');
    writeln('[3] Wypisz zawartosc kolejki');
    writeln('[4] Usun wszystkie elementy kolejki');
    writeln('[5] Zapisz do pliku elementy wedlug nr PESEL');
    writeln('[6] Wpisz do tablicy dynamicznej');
    writeln('[7] Usun wszystkich uzytkownikow o danym imieniu');
    writeln();
    writeln('[0] Wyjscie');
    readln(n);
    case n of
    1: dodaj(pocz,kon);
    2: usun(pocz,kon);
    3: wypisz(pocz);
    4: usunWszystko(pocz, kon);
    5: zapisz(pocz);
    6: wpiszDyn(pocz);
    7: usunPoImieniu(pocz,kon);
    end;
  until (n = 0);
  if(pocz <> nil) then usunWszystko(pocz, kon);
  ClrScr;
  writeln('------------------- WYJSCIE ------------------');
  writeln('Czy lista jest pusta? ',empty(pocz));
  writeln();
  writeln('Wcisnij ENTER, aby wyjsc...');
  readln();
end.

