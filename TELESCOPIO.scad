/****************
Armado del TELESCOPIO
Asociación Amigos de la Astronomía
Dimensionamiento según apunte de Teoría de construccion de telescopios.
Copy Left.
twitter@juanmiguells
****************/

// Todas las medidas son en milímietros
// Valores que se obtienen de las partes fabricadas MODIFICAR SEGUN CORRSPONDA

// Datos Espejo
DistanciaFocal = 1237.5; // Distancia Focal "F" se obtiene con el Foucault
DiametroEspejoPrimario = 120; // Diámetro del espejo Primario se obtiene midiendo el espejo
// Datos Constructivos
ValorA = 100; // Valor "A" no tiene real importancia A = 100 / 150 
ValorB = 100; // Valor "B" Desde el punto de fijación de la araña hasta el centro del espejo secundario con el tornillo central de la araña al %50
ValorC = 50; // Valor "C" Desde el punto de fijación de la celda hasta el borde del espejo primario
ValorD = 60; // Valor "D" para que los tornillos de la celda no sobresalgan del tubo.
ValorE = 90; // Valor "E" es la distancia entre la base del enfocador hasta la parte superior de su tubo porta ocular cuando este se encuentra a la mitad de su recorrido de enfoque. 
// Medidas del Tubo
PerimetroExteriorDelTubo = 658; // Perímetro exterior del tubo
EspesorDeLaParedDelTubo = 1;
// Medidas de PortaOcular
LargoDelPortaOcular = 80; 
RadioDelPortaOcular = 33;
EspesorDeLaParedDelPO = 1; // Espesor de la pared del Tubo es la medida del ancho del material del tubo


/**********************************************/
/* NO MODIFICAR NADA DEBAJO DE ESTE COMENTARIO*/
/* NO MODIFICAR NADA DEBAJO DE ESTE COMENTARIO*/
/* NO MODIFICAR NADA DEBAJO DE ESTE COMENTARIO*/
/* NO MODIFICAR NADA DEBAJO DE ESTE COMENTARIO*/
/* NO MODIFICAR NADA DEBAJO DE ESTE COMENTARIO*/
/* NO MODIFICAR NADA DEBAJO DE ESTE COMENTARIO*/
/**********************************************/

/************************/
/* Datos de los ESPEJOS */
/************************/

// PRIMARIO
F = DistanciaFocal;
DeP = DiametroEspejoPrimario; 
ReP = DeP / 2;  // Radio Espejo Primario "ReP"

// SECUNDARIO

/******************/
/* Datos del TUBO */
/******************/

Et = EspesorDeLaParedDelTubo;
Pt = PerimetroExteriorDelTubo; 
Dt = Pt / 3.14159265359; // Diámetro exterior del Tubo
Rt = Dt / 2; // Radio exterio del tubo "Rt" Diametro Sobre 2

A = ValorA;
B = ValorB; 
C = ValorC; 
D = ValorD; 
E = ValorE; 

// Con "F", "Rt" y "E" podemos calcular "S" que es la separación entre ambos espejos.
S = F - Rt - E;

// Largo Total del Tubo "Lt" = "A" + "B" + "C" + "D" + "S"
Lt = A + B + C + D + S;

/******************/
/* Datos del PORTA OCULAR */
/******************/

LargoPO = LargoDelPortaOcular;
RPO = RadioDelPortaOcular;
EPO = EspesorDeLaParedDelPO;

/************/
/* CALCULOS */
/************/
alfa = atan(ReP / F); // Cálculo del ángulo "alfa" que forma la altura del cono de luz con el borde "Tangente(alfa)" = altura del cono sobre el radio del espejo Entonces arco tangente de alfa me da alfa.
RbS = tan(alfa) * (F - S); // Cáculo del radio de la base del cono de luz que se proyecta desde el espejo Secundario





// Cono de Luz
module conoDeLuz (DistanciaFocal, RadioEspejoPrimario){
// Traslación correspondiente al espacio que ocupa la celda y el espacio debajo de la celda
translate ([0,0, C + D])
color ("PaleTurquoise")
cylinder
(DistanciaFocal
,RadioEspejoPrimario
,0
,center = false);
}

// Cono de Luz Con espejo Secundario
module conoDeLuzSecundario (DistanciaFocal, BaseSecundario){
// Traslación correspondiente a la Separación entre los espejos.
    translate ([0,0, C + D + S])
        rotate ([0,90,0]){
        color ("white")
        cylinder
        (DistanciaFocal - S
        ,BaseSecundario
        ,0
        ,center = false);
    }
}

/********/
/* TUBO */
/********/

module cilindroTubo (){
    color ("MediumSlateBlue")
    cylinder
    (Lt
    ,Rt
    ,Rt
    ,center = false);
}

module cilindroInteriorTubo (){
    color ("black")
    cylinder
    (Lt + Et*2
    ,(Rt - Et)
    ,(Rt - Et)
    ,center = false);
}


module tubo (){
    difference () {
        cilindroTubo();
        translate ([0,0, -Et]) 
            cilindroInteriorTubo();
            // Orificio Porta Ocular
       translate ([Rt -10, 0 ,C + D + S]) 
           rotate ([0,90,0]){
            cylinder
                (LargoPO
                ,RPO
                ,RPO
                ,center = false
                );
           }
    }   
}


module portaOcular()
{
    
    translate ([Rt - Et, 0 ,C + D + S])
        difference() {
            cube([10, (RPO * 2.5), (RPO * 3)], true);
            translate ([-Rt + Et, 0 , -S])
                cilindroTubo();
            rotate ([0,90,0]){
                cylinder
                (LargoPO + EPO*2
                ,RPO - EPO
                ,RPO - EPO
                ,center = true
                );            
            }
        }
    translate ([Rt, 0 ,C + D + S])
        rotate ([0,90,0]){
            difference() {
                cylinder
                (LargoPO
                ,RPO
                ,RPO
                ,center = false
                );
                translate ([0,0, -EPO]) 
                cylinder
                (LargoPO + EPO*2
                ,RPO - EPO
                ,RPO - EPO
                ,center = false
                );            
            }
        }
}

module textos(tamFuente)
{
    oraciones=["TELESCOPIO"
        ,str("Distancia Focal F = ", F , "mm")
        ,str("Distancia S = ", S , "mm")
        ,str("Distancia S + D Desde las fijaciones de la celda al centro del Porta Ocular = ", S+D , "mm")
        ,str("Distancia D de la base del Tubo a las fijaciones de la celda = ", D , "mm" )
        ,str("Distancia C de las fijaciones de la Celda al Borde del Espejo Primario = ", C , "mm" )
        ,str("Distancia B de la fijación de la araña al centro del Espejo Secundario = ", B , "mm" )
        ,str("Distancia A es arbitraria entre 100 y 150 = ", A , "mm" )
    ];
    for(a = [0:len(oraciones)-1])
    {
        translate([0, Dt, Lt - (tamFuente*1.5)*a])
        rotate([90,0,90]){
        color("black"){
            text(str(oraciones[a]), tamFuente);
        }    
    }
        
        }
    
 }



// Render Comentar o descomentar las funciones para ver piezas

tubo();
portaOcular();
conoDeLuz(F, ReP);
conoDeLuzSecundario(F, RbS);
textos(10);




