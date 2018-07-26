*problema del aeropuerto hub

sets
*Ciudades
i ciudades /ATL,BOS,ORD1,DEN,IAH,LAX,MSY,JFK,PIT,SLC,SFO,SEA/;

alias (i,j);

table ruta(i,j)
         ATL BOS ORD1 DEN IAH LAX MSY JFK PIT SLC SFO SEA
ATL      1   0   1    0   1   0   1   1   1   0   0   0
BOS      0   1   0    0   0   0   0   1   1   0   0   0
ORD1     1   0   1    0   0   0   1   1   1   0   0   0
DEN      0   0   0    1   0   0   0   0   0   1   0   0
IAH      1   0   0    0   1   0   1   0   0   0   0   0
LAX      0   0   0    0   0   1   0   0   0   1   1   0
MSY      1   0   1    0   1   0   1   0   0   0   0   0
JFK      1   1   1    0   0   0   0   1   1   0   0   0
PIT      1   1   1    0   0   0   0   1   1   0   0   0
SLC      0   0   0    1   0   1   0   0   0   1   1   1
SFO      0   0   0    0   0   1   0   0   0   1   1   1
SEA      0   0   0    0   0   0   0   0   0   1   1   1;

variables
x(i)
z ruta optima

binary variable x;

equations
fo
Disp(i);


fo .. z=e=sum(i,x(i));
* igual(=) se escribe =e=
Disp(i) .. sum(j,ruta(i,j)*x(j))=g=1;
* mayor o igual(>=) se escribe =g=

model hub /all/ ;
solve hub using MIP minimizing z ;
*lp categoriza el problema como lineal



