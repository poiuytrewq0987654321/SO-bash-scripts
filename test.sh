#!/bin/bash
# dodanie repo do pliku sources.list

echo -e "\e[42mwykonac szukanie 'dev' w nazwach plikow? (napisz duza litera: T dla TAK i N dla NIE\e[0m"
read str1

if [ "$str1" == "T" ] ; then
mkdir /home/administrator/Pobrane/testowiec
find / -type f -name "*dev*" > /home/administrator/Pobrane/testowiec/wynik
else
echo -e "wybrales \e[32mNIE\e[0m tworzyc pliku 'Nowy' i zapisania w nim wyszukiwania 'dev'"
fi