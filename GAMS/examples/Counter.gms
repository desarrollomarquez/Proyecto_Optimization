*problema del counter

sets
*Franjas horarias
i franjas /1,2,3,4,5,6,7,8,9,10/
*turnos de trabajo
j turnos /t1,t2,t3,t4,t5/;
*Tambien se puede poner /1*5/

parameters
*varios parametros
c(j) costo de los agentes contratados en el turno j
/t1  170
 t2  160
 t3  175
 t4  180
 t5  195 /

n(i) necesidades de personal den la franja i
/ 1  48
  2  79
  3  65
  4  87
  5  64
  6  73
  7  82
  8  43
  9  52
  10 15 /;

table d(i,j) disponibilidad de los trabajadores del turno j para la franja i
*i filas, j columnas
    t1 t2 t3 t4 t5
1    1  0  0  0  0
2    1  1  0  0  0
3    1  1  0  0  0
4    1  1  1  0  0
5    0  1  1  0  0
6    0  0  1  0  0
7    0  0  1  1  0
8    0  0  0  1  0
9    0  0  0  1  1
10   0  0  0  0  1  ;

variables
x(j) agentes que se contrataran para el turno j
z costo total de la nomina;

positive variable x;

equations
fo funcion objetivo
necesidades(i) necesidades de personal en la franja i;

fo .. z=e=sum(j,c(j)*x(j));
* igual(=) se escribe =e=
necesidades(i) .. sum(j,d(i,j)*x(j))=g=n(i);
* mayor o igual(>=) se escribe =g=

model moni /all/ ;
solve moni using lp minimizing z ;
*lp categoriza el problema como lineal



