* Problema de call center

Sets
s servidor /1*2/
a area /1*3/;

parameters

demanda(a) demanda de area geografica
/1 325
2 300
3 275/

oferta (s) oferta capacidad procesamiento
/1 350
2 600/

table costotransporte(a,s)
   1   2
1  225 225
2  153 162
3  162 126;

variables
x(s,a) terabytes en el servidor s del area geografica a
z costo total;

Positive Variable x ;


Equations
       fo        define objective function
       ofertas(s)  oferta de servidores s
       demandaa(a)  demanda de cada area geografica a;

fo..    z =e= sum((s,a), costotransporte(a,s)*x(s,a));
ofertas(s).. sum(a,x(s,a)) =l=  oferta(s);
demandaa(a).. sum(s,x(s,a)) =g=  demanda(a);

Model ProblemaCallcenter /all/ ;

Solve ProblemaCallcenter using lp minimizing z ;

*X.l hace que se se muestre los valores de las variables de desicion en tablas
*X.m hace que se se muestre los valores de las variables duales o precios sombra en tablas
*Display x.l, x.a ;

*Abre archivo "Resultados.out" para poner los resultados en la forma que lo desee.

FILE Resul/Resultados.out /;
put Resul;
*/ hace que se pase 1 linea sin texto


