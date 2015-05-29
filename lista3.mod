/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Michal Robaszynski
 *********************************************/

//parametry
int m = ...; // liczba zadan
int n = ...; // liczba zasobow

range Task = 1..m;
range Resource = 1..n;

tuple Pred {
	int pred;
	int succ;
}

float z[Resource] = ...;
float d[Task] = ...; //d_ij czas wykonania zadania i
int u[Task][Resource] = ...; //wykorzystanie zasobow przez zadania
{Pred} pred = ...;

tuple TaskTask {
	int i;
	int j;
}

{TaskTask} Precedence = {<i,j> | i in Task, j in Task: i<j};

// zmienne decyzyjne
dvar float+ t[Task]; // zmienne moment rozpoczecia i-tego zadania 
dvar float+ ms; //zmienna czas zakonczenia wykonawania wszystkich zadan - makespan 
dvar boolean wspolne[Precedence];

// funckcja celu
minimize 
	ms; //minimalizacja czasu zakonczenia wszystkich zadan

subject to{
  // zaleznosci czasowe miedzy zadaniami
  // nie zaczynamy przed ukonczeniem poprzedniego
  forall(<i,j> in pred)
  	 poprzedzanie:
  	   t[j]>=t[i]+d[i];
  
  forall(<i,j> in Precedence)
    wsp:
    	( t[j] - t[i] >= d[i] ) == 1-wspolne[<i,j>];//j zaczyna sie pozniej 
  	   
   // ograniczenia zasobow
   forall(r in Resource)
   	zasoby:
   		(sum(i in Task,j in Task:i<j) wspolne[<i,j>]*u[i][r]) <= z[r];
  	 
  // ms rowna sie czas zakonczenia wszystkich zadan na ostatniej maszynie	  	   
  forall(i in Task)
  	dociskanie:
  	  t[i]+d[i]<=ms;   
}  

                            
                                                     