/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Michal Robaszynski
 *********************************************/

//parametry
int m = ...; // liczba zadan
int n = ...; // liczba zasobow

range Zadanie = 1..m; // zadania
range Zasob = 1..n; //zasoby
float B=100000;


tuple Pred {
	int pred;
	int succ;
}

float z[Zasob] = ...;
int d[Zadanie] = ...; //d_ij czas wykonania zadania i
int u[Zadanie][Zasob] = ...; //wykorzystanie zasobow przez zadania
{Pred} pred = ...; //kolejnosc wykonywania zadan

tuple ZadanieZadanie {
	int i;
	int j;
}

int maxCzas = 1+sum(a in Zadanie) d[a];
range zakresCzasu = 1..maxCzas;

{ZadanieZadanie} Kolejnosc = {<i,j> | i in Zadanie, j in Zadanie: i<j};

// zmienne decyzyjne
dvar int+ t[Zadanie]; // moment rozpoczecia i-tego zadania 
dvar float+ ms; //zmienna czas zakonczenia wykonawania wszystkich zadan - makespan 
dvar boolean wspolne[Kolejnosc]; // wspolne[<a,b>] == zadania a,b posiadaja czesc wspolna
dvar boolean wykonywane[Zadanie][zakresCzasu]; // wykonywane[a][b] == zadanie b jest w trakcie wykonania w czasie b

// funckcja celu
minimize 
	ms; //minimalizacja czasu zakonczenia wszystkich zadan

subject to{
  
  // zaleznosci czasowe miedzy zadaniami
  // nie zaczynamy przed ukonczeniem poprzedniego
  forall(<i,j> in pred)
  	 poprzedzanie:
  	   t[j]>=t[i]+d[i];
  
  // ograniczenie zakresu trwania z dolu
  // wykonywane == 1 <=>  c >= t[i]
  forall(i in Zadanie, c in zakresCzasu)
    ograniczenie_gorne:
	  c + (1-wykonywane[i][c])*B >= t[i];
	  //t[i] <= (1-wykonywane[i][c])*B + c;
	
	// ograniczenie zakresu trwania z gory
	// wykonywane == 1 <=> c <= t[i] + d[i]
	forall(i in Zadanie, c in zakresCzasu)
	  ograniczenie_dolne:
		c <= t[i] + d[i] + (1-wykonywane[i][c])*B;
		//t[i] + d[i] <= c + wykonywane[i][c]*B;
		//(c <= t[i] + d[i]) == wykonywane[i][c];
	 
//	// dlugosc trwania zadania
	forall(i in Zadanie)
	  dlugosc_trwania:
	  (sum(c in zakresCzasu) wykonywane[i][c]) == d[i];
	
	// ograniczenie zasoobw
	forall(c in zakresCzasu, a in Zasob)
	  	zasoby:
	  	sum(i in Zadanie) wykonywane[i][c]*u[i][a] <= z[a];
  	 
  // ms rowna sie czas zakonczenia wszystkich zadan na ostatniej maszynie	  	   
  forall(i in Zadanie)
  	dociskanie:
  	  t[i]+d[i]<=ms;   
}  

                            
                                                     