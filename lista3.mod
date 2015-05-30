/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Michal Robaszynski
 *********************************************/

//parametry
int iLiczbaZadan = ...; 										//!< liczba zadan
int iLiczbaZasobow = ...; 										//!< liczba zasobow

range rZadania = 1..iLiczbaZadan; 								//!< enumerator zadan
range rZasoby = 1..iLiczbaZasobow; 								//!< enumerator zasobow
float DUZA_LICZBA=100000; 										//!< potrzebna, aby nadac duza wage zmiennej binarnej

tuple KolejnoscZadan {											//!< okreslenie par, w ktorych <i,j> -> i musi byc wykonane przed j
	int najpierw;
	int nastepnie;
}

float DostepneZasoby[rZasoby] = ...; 							//!< ilosc dostepnych zasobow 
int CzasTrwania[rZadania] = ...; 								//!< czas wykonania zadania i
int WykorzystanieZasobu[rZadania][rZasoby] = ...; 				//!< wykorzystanie zasobu j przez zadanie i
{KolejnoscZadan} Kolejnosc = ...; 								//!< kolejnosc wykonywania zadan

int iMaxCzas = 1+sum(a in rZadania) CzasTrwania[a];				//!< czas potrzebny do wykonania zadan pesymistycznie (szeregowo) 
																//!  najwieksza mozliwa liczba dla czasu
range rZakresCzasu = 1..iMaxCzas;								//!< enumerator czasowy (zawiera kwanty czasu)

// zmienne decyzyjne
dvar int+ rozpoczecie[rZadania]; 								//!< moment rozpoczecia i-tego zadania 
dvar float+ ms; 												//!< zmienna czas zakonczenia wykonawania wszystkich zadan - makespan 
dvar boolean wykonywane[rZadania][rZakresCzasu]; 				//!< wykonywane[a][b] == zadanie b jest w trakcie wykonania w czasie b

// funkcja celu
minimize 
	ms; 														//!< minimalizacja czasu zakonczenia wszystkich zadan

subject to{
  /**
  * zaleznosci czasowe miedzy zadaniami
  * nie zaczynamy przed ukonczeniem poprzedniego
  */
  forall(<i,j> in Kolejnosc)
	poprzedzanie:
		rozpoczecie[j]>=rozpoczecie[i]+CzasTrwania[i];
  
  /**
  * ograniczenie zakresu trwania z dolu
  * wykonywane == 1 <=>  c >= t[i]
  */
  forall(i in rZadania, c in rZakresCzasu)
	ograniczenie_dolne:
		c + (1-wykonywane[i][c])*DUZA_LICZBA >= rozpoczecie[i];

  /**
  * ograniczenie zakresu trwania z gory
  * wykonywane == 1 <=> c <= t[i] + d[i]
  */
  forall(i in rZadania, c in rZakresCzasu)
	ograniczenie_gorne:
		c <= rozpoczecie[i] + CzasTrwania[i] + (1-wykonywane[i][c])*DUZA_LICZBA - 1;
	 
  /**
  * dlugosc trwania zadania
  */
  forall(i in rZadania)
	dlugosc_trwania:
	  (sum(c in rZakresCzasu) wykonywane[i][c]) == CzasTrwania[i];
	
  /**
  * ograniczenie zasoobw
  */
  forall(c in rZakresCzasu, a in rZasoby)
  	zasoby:
		sum(i in rZadania) wykonywane[i][c]*WykorzystanieZasobu[i][a] <= DostepneZasoby[a];
  	 
  /**
  * ms rowna sie czas zakonczenia wszystkich zadan
  */	  	   
  forall(i in rZadania)
  	dociskanie:
  	  rozpoczecie[i]+CzasTrwania[i]<=ms;   
}  

execute OUTPUT_NA_KONSOLE {
   writeln("\n Wykorzystanie zasobow w poszczegolnych kwantach czasu:\n");
	// ladne formatowanie wykorzystywanych zasobow dziala tylko dla liczb co najwyzej dwucyfrowych...
	write("Z|")
	for(var v in rZakresCzasu)
   	for(var a in rZasoby)
   	{
   		var s=0;
   		for(var i in rZadania)
   			s=s+wykonywane[i][v]*WykorzystanieZasobu[i][a];
    	write(s, " ");
    	if(s<10)
    	{
    		write(" ")    	
    	}
    	
   	}    	    
   	writeln(" ")	
   	for(var a in rZadania)
   	{
		write(a, "|")   	
   		for(var b in rZakresCzasu)
   		{
   			if(wykonywane[a][b]==1)
   				write("-  ")
   			else
   				write("   ")   		
   		}   	
   		writeln("")
   	}
}
                            
                                                     