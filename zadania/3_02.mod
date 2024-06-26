option solver cplex;
reset;

# Parametry
set zboza; # Zbiór zbóż
param cena{zboza}; # Cena za tonę zbóż
param popyt{zboza}; # Popyt na dane zboże
param praca{zboza}; # Wymagany czas pracy na hektarze dla danego zboża
param wydajnosc{zboza}; # Wydajność zboża na hektarze
param rozmiar_pola; # Rozmiar pola w hektarach
param limit_pracy; # Limit czasu pracy

# Zmienna decyzyjna - Ilość obsianych hektarów dla każdego zboża
var ilosc_hektarow{zboza} >= 0;

# Funkcja celu - Maksymalizacja całkowitego zysku. W tym przypadku maksymalizowana jest wartość zysku poprzez sumowanie wartości sprzedaży każdego zboża.
maximize zysk: sum{z in zboza} cena[z] * wydajnosc[z] * ilosc_hektarow[z];

# Ograniczenia
# Określa, że suma iloczynów wymaganego czasu pracy i ilości obsianych hektarów dla każdego zboża nie może przekroczyć limitu czasu pracy.
o_pracy: sum{z in zboza} praca[z] * ilosc_hektarow[z] <= limit_pracy; 	
# Określa, że iloczyn ilości obsianych hektarów i wydajności każdego zboża nie może przekroczyć popytu na to zboże
o_popyt{z in zboza}: ilosc_hektarow[z] * wydajnosc[z] <= popyt[z]; 		
# Określa, że suma ilości obsianych hektarów dla każdego zboża nie może przekroczyć rozmiaru pola.
o_pole: sum{i in zboza} ilosc_hektarow[i] <= rozmiar_pola; 				

data;
param rozmiar_pola := 100;
param limit_pracy := 1400;
param: zboza: popyt cena wydajnosc praca := "Zyto" 560 300 10 12 "Pszenica" 480 500 8 20 "Kukurydza" 500 400 5 7 "Owies" 600 0 7 10;	
												
solve;
display zysk, ilosc_hektarow;
#display ilosc_hektarow.down, ilosc_hektarow.up, ilosc_hektarow.current;
end;