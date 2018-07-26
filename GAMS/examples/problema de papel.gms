* Problema de producción de Papel

Sets
m maquinas /1*3/
p papel /1*4/;

parameters

demanda(p) demanda de papel p
/1 77
2 81
3 99
4 105/

precio (p) precio de venta del papel p
/1 30000
2 20000
3 12000
4 8000/

tiempomaq(m) tiempo disponible mensual de la maquina
/1 672
2 600
3 480/;

table tasaprod(p,m)
   1  2  3
1  53 52 49
2  51 49 44
3  52 45 47
4  42 44 40;

table costeprod(p,m)
   1  2  3
1  76 75 73
2  82 80 78
3  96 95 92
4  72 71 70;

variables
x(p,m) cantidad de papel p hecho en la maquina m
beneficio costo total;

Positive Variable x ;



Equations
       benef        define objective function
       capacmaq(m)  capacidad de la maquina m
       demandap(p)  demanda de cada papel ;

benef..    beneficio =e= sum((p,m), (precio(p)- costeprod(p,m))*x(p,m)) ;
capacmaq(m).. sum(p,x(p,m)/tasaprod(p,m))  =l= tiempomaq(m) ;
demandap(p).. sum(m,x(p,m)) =g=  demanda(p);

Model ProblemaPapel /all/ ;

Solve ProblemaPapel using lp maximizing beneficio ;

*X.l hace que se se muestre los valores de las variables de desicion en tablas
*X.m hace que se se muestre los valores de las variables duales o precios sombra en tablas
Display x.l, x.m ;

*Abre archivo "Resultados.out" para poner los resultados en la forma que lo desee.

FILE Resul/Resultados.out /;
put Resul;
*/ hace que se pase 1 linea sin texto


put //;
put '"TURBINAS "'//;
loop ((p,m),
      put   p.tl;
         put x.l(p,m) /
);



put //;
put '"PRODUCCION OPTIMA "'//;
loop (p,
      put   /'Produccion del papel ', ord(p),
      put /;
      put @20,'maquina'
      put @40, 'produccion' //;
      loop (m,
          if(x.l(p,m)>=0.00000001,
             put @20,m.tl
                 @40,x.l(p,m)
                 /
             ;
           );
     );
);
