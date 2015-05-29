/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Michal Robaszynski
 *********************************************/

//parametry
int m = ...; // liczba zadan
int n = ...; // liczba zasobow

range Zadanie = 1..m; // zadania
range Zasob = 1..n; //zasoby

tuple Pred {
	int pred;
	int succ;
}

float z[Zasob] = ...;
float d[Zadanie] = ...; //d_ij czas wykonania zadania i
int u[Zadanie][Zasob] = ...; //wykorzystanie zasobow przez zadania
{Pred} pred = ...; //kolejnosc wykonywania zadan

tuple ZadanieZadanie {
	int i;
	int j;
}

{ZadanieZadanie} Kolejnosc = {<i,j> | i in Zadanie, j in Zadanie: i<j};

// zmienne decyzyjne
dvar float+ t[Zadanie]; // moment rozpoczecia i-tego zadania 
dvar float+ ms; //zmienna czas zakonczenia wykonawania wszystkich zadan - makespan 
dvar boolean wspolne[Kolejnosc]; // wspolne[<a,b>] == zadania a,b posiadaja czesc wspolna

// funckcja celu
minimize 
	ms; //minimalizacja czasu zakonczenia wszystkich zadan

subject to{
  // zaleznosci czasowe miedzy zadaniami
  // nie zaczynamy przed ukonczeniem poprzedniego
  forall(<i,j> in pred)
  	 poprzedzanie:
  	   t[j]>=t[i]+d[i];
  
  // sprawdzenie, czy zadania posiadaja czesc wspolna
  forall(<i,j> in Kolejnosc)
    rownlolegle:
    	( t[j] - t[i] >= d[i] ) == 1-rownlolegle[<i,j>]; // j zaczyna sie pozniej 
  	   
   // ograniczenia zasobow
   forall(r in Zasob)
   	zasoby:
   		(sum(i in Zadanie,j in Zadanie:i<j) wspolne[<i,j>]*u[i][r]) <= z[r];
  	 
  // ms rowna sie czas zakonczenia wszystkich zadan na ostatniej maszynie	  	   
  forall(i in Zadanie)
  	dociskanie:
  	  t[i]+d[i]<=ms;   
}  

                            
                                                     