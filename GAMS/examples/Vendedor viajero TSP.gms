*Problema del vendedor viajero TSP

set i/1*7/;

alias (i,j,k);

set arcos(i,j) ;

arcos(i,j)=no;


Parameter dist(i,j) distancia entre nodos


         / 1.2  15
           1.3  10
           2.4  6
           2.5  7
           2.6  6
           2.7  17
           3.2  8
           3.5  4
           3.6  2
           4.5  4
           4.7  5
           5.6  2
           5.7  3
           6.7  6 /

;

dist(i,j)  $= dist(j,i);
arcos(i,j)$(dist(i,j)<>0)=yes;

display arcos;

Variables x(i,j) arco que pertenece o no a la distancia optima
          z    costo de la ruta optima ;

binary variable x;

*Ajustar el valor x=0 a los arcos que no son factibles

x.fx(i,j)$(not arcos(i,j)) = 0;


Equations
RutaMasOptima
origen
destino
*balance
;

RutaMasOptima.. z =e= sum((i,j)$(arcos(i,j)),dist(i,j)*x(i,j));

origen(i)..  sum(j$(arcos(i,j)),x(i,j))=e=1;
destino(j)..  sum(i$(arcos(i,j)),x(i,j))=e=1;
*balance(i)$(ord(i) > 1).. sum(j,x(j,i)) =e= sum(k,x(i,k))

*ciclo(i,j)$(arco(i,j).. x(i,j)+x(j,i)=l=1  ;


model TSP /all/;

solve TSP using MIP minimizing z ;



FILE RutaOptimaTSP / Rutas.out /;


PUT RutaOptimaTSP;

RutaOptimaTSP.nw=8;
RutaOptimaTSP.lw=3;

PUT // 'RUTA OPTIMA TSP' ;
Loop((i,j)$(arcos(i,j)),
if(x.l(i,j),
put "de", i.tl, "a", j.tl);
);

$ontext
ser aux(i);


sets
 aux(i)
 aux2(i);

*aux indica en cual nodo va el loop
*aux2 indica si el loop ya paso por el nodo i

aux(i)=no;
aux('1')=yes;

aux2(i)=no;
aux2('1')=yes;

while(not aux('7'),
      loop(i$aux(i),
           loop((j)$(not aux(j)),
               if(x.l(i,j), put i.tl 'a -> ' j.tl /;
                  aux(i)=no;
                  aux(j)=yes;
                  aux2(j)=yes;
               );
           );

       );
 );

$offtext
put / 'RutaOptima: '
@25,  (sum((i,j)$(arcos(i,j)),dist(i,j)*x.l(i,j)))  ;

putclose RutaOptimaTSP ;

Execute_unload "datos.gdx", x;
Execute_load "datos.gdx", x;
display x.l;



