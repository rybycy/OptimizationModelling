/*********************************************
 * OPL 12.3 Model
 * Author: Michal Robaszynski
 *********************************************/

//parametry
int m = ...; // liczba zadan
int n = ...; // liczba maszyn

range Task = 1..m;
range Resource = 1..n;

float d[Task][Resource] = ...; //d_ij czas wykonania zadania i na j-tej maszynie

// zmienne decyzyjne
dvar float+ t[Task][Resource]; // zmienne moment rozpoczecia i-tego zadania na j-tej maszynie
dvar float+ ms; //zmienna czas zakonczenia wykonawania wszystkich zadan - makespan 
 
 // funckcja celu
minimize 
	ms; //minimalizacja czasu zakonczenia wszystkich zadan

subject to{
  // ms rowna sie czas zakonczenia wszystkich zadan na ostatniej maszynie	  	   
  forall(i in Task)
  	dociskanie:
  	  t[i][n]+d[i][n]<=ms;   
}  

                            
                                                     