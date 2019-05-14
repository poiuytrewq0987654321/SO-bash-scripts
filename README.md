wprowadzenie
skrypty do SO na zaliczenie II semestru

opis uzycia skryptow
wejsc na maszynie wirtualnej przez przegladarke do tego repozytorium, skopiowac zawartosc danego skryptu (na wirtualkach 
pojawia sie blad i nie da sie pobrac pliku), zalogowac sie w konsoli na roota (wpisac "su" i podac haslo do kompa)
nastepnie obojetnie gdzie utworzyc nowy plik poleceniem: "touch repo.sh", wejsc w jego edycje ("nano repo.sh")
w lewym gornym rogu wybrac z edycja->wklej, zapisac plik.
na koniec wpisac w konsoli "sh repo.sh"

opis plikow i co wykonuja:
1. repo.sh - dodaje wpisy linkow do repozytorium, uaktualnia wszystkie pakiety, instaluje sudo i dodaje uzytkownika "student" do grupy sudoers
