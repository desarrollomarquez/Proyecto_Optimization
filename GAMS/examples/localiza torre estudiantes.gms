*  LOcalizacion de torre

Sets
i /ciudad1*ciudad4/
j /cx,cy/ ;

table xy(i,j)

               cx       cy
Ciudad1        5         45
Ciudad2        12        21
Ciudad3        52        21
Ciudad4        17        5

;

variables
coor(j) coordenadas de la nueva torre
z
;

positive variable coor(j);


equations
fo funcion objetivo
ciudad(i) cercania a ciudad i;

fo .. z=e=sum(i,sqr(xy(i,'cx') - coor('cx')) + sqr(xy(i,'cy') - coor('cy'))) ;
* igual(=) se escribe =e=
ciudad(i) .. sqr((xy(i,'cx') - coor('cx'))) + sqr((xy(i,'cy') - coor('cy'))) =l=40**2;
* mayor o igual(>=) se escribe =g=

model localiza /all/ ;
solve localiza using nlp minimizing z ;
*lp categoriza el problema como lineal
