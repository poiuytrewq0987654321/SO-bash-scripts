wprowadzenie
skrypty do SO na zaliczenie II semestru

opis uzycia skryptow:
sciagnij cale repo poprzez wejscie w link: https://github.com/poiuytrewq0987654321/SO-bash-scripts/archive/master.zip
zaloguj sie w konsoli jako root (wpisz "su" i haslo uzytkownika). Przejdz do folderu "Pobrane" i wypakuj skrypty (dwukrotne kliknięcie na zipa).

uruchomienie skryptu w konsoli: wpisujemy "sh nazwaskryptu.sh" czyli np.: "sh repo.sh"

Skrypty powinny być uruchamiane w kolejności:
1. repo.sh
2. samba.sh
3. apache.sh
4. cups.sh

dodatkowo dla wygody mozna uzyc tylko jednego skryptu:
1. all.sh - ktory wywoluje wszystkie pozostale.

!WAZNE!
w trakcie instalacji cups.sh bedzie wymagana jedna interakcja ze skryptem, mianowicie trzeba ustalic haslo dla usera smbuser. 

opis plikow i co wykonuja:
1. repo.sh - dodaje wpisy linkow do repozytorium, uaktualnia wszystkie pakiety, instaluje sudo i dodaje uzytkownika "student" do grupy sudoers
2. apache.sh - instalacja serwera apache (strony www)
3. samba.sh - instalacja serwera wymiany plikow - skrypt konfiguruje restricted zasob poprzez autoryzacje usera (user: smbuser / haslo ustawione samemu poprzez interakcje w konsoli w trakcie instalacji skryptu)
4. cups.sh - instalacja serwera wydruku. z naszej strony zostaje tylko wejsc na localhost:631, utworzyc nowa drukarke i polaczyc sie z nia na Windows :-)
5. all.sh - skrypt wywyloujacy wszystkie pozostale skrypty 1-4 (jesli nie chce nam sie uruchamiac pierwszych 4 skryptow po kolei) 
