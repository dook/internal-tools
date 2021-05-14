# internal-tools
### Lokalny setup

Projekt pozwala na proste generowanie raportów potrzebnych do rozliczania godzin pracy twórczej.
Aby narzędzie działało poprawnie należy spełnić podstawowe zależności:
 - Python 3
 - poprawnie uporządkowane katalogi projektowe (przykład w zakładce #WSF (Wymagana Struktura Folderów))

### WSF (Wymagana Struktura Folderów)
Do poprawnego działania skyptu wymagana jest następująca folderów:

```
    /folder-glowny (tutaj powinny znjdować się wszystkie projekty które chcemy uwzględnić w raporcie)
        /projekt1
        /projekt2
        ...
```

W `/folder-glowny` nie powinien znajdować się plik `.git` - taka sytuacja mogłaby wskazywać na złe umiejscowienie pliku skryptu.

### I w końcu - jak tego użyć :national_park:

Skopiuj zawartość repozytorium do katalogu głównego:

*Upewnij się, że jesteś w folderze głównym, a repozytorium `internal-tools` również zostało umieszczone pod nim.

```bash
$ pwd
/.../folder-glowny
$ cp -r internal-tools/. .
$ ls
projekt1 projekt2 my-work.sh ...
```

Opcjonalnie można też usunąć plik README.md:

```bash
$ pwd
/.../folder-glowny
$ rm -f README.md
```

### Uruchomienie skryptu

```bash
$ ./my-work.sh
```

### Gdzie znajdę raport :thinking:

Raporty będę dostępne w katalogu `my-work-reports` znajdującego się w katalogu `/folder-glowny`
