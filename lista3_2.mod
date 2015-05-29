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
	key int pred;
	int succ;
}

float z[Resource] = ...;
float d[Task] = ...; //d_ij czas wykonania zadania i
float u[Task][Resource] = ...; //wykorzystanie zasobow przez zadania
{Pred} pred = ...;



tuple ResourceTaskTask {
  int j;
  int i;
  int k;
}

// zmienne decyzyjne
dvar float+ t[Task]; // zmienne moment rozpoczecia i-tego zadania 
dvar float+ ms; //zmienna czas zakonczenia wykonawania wszystkich zadan - makespan 
 
 // funckcja celu
minimize 
	ms; //minimalizacja czasu zakonczenia wszystkich zadan

subject to{
  // moment rozpoczecia i-tego zadania na j+1-szej maszynie 
  // musi >= od momentu zakonczenia i-tego zadania na j-tej maszynie   
  // chcemy z tego zrobic zaleznosc miedzy zadaniami
  forall(<i,j> in pred)
  	 poprzedzanie:
  	   t[j]>=t[i]+d[i]; 
  	   
  // t_ij>=t_kj+d_kj lub t_kj>=t_ij+d_ij 
  // ograniczenia zosobowe tj,. tylko jedno zadanie wykonywane jest
  // w danym momencie na j-tej maszynie 	   
//  forall(<j,i,k> in Precedence) 
//  	zasoby1:
//  	   t[i]-t[k]+B*y[<j,i,k>]<=d[k];
//  forall(<j,i,k> in Precedence) 	   
//  	zasoby2:
//  	  	 t[k][j]-t[i][j]+B*(1-y[<j,i,k>])>=d[i][j]; 
  	  	 
  // ms rowna sie czas zakonczenia wszystkich zadan na ostatniej maszynie	  	   
  forall(i in Task)
  	dociskanie:
  	  t[i]+d[i]<=ms;   
}  

                            
                                                     