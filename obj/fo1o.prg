*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : fo1o.prg
*+
*+
*+
*+     Sistema:
*+
*+     Linguagem: Harbour
*+
*+     Autor: jcassiano
*+
*+     Copyright (c) 2024,  jcassiano
*+
*+     
*+
*+
*+
*+    Documentado em 15-Out-2026 as 12:36 pm
*+
*+
*+
*+--------------------------------------------------------------------
*+

// **
// ** FO1O   .PRG  : Codigos SAT(INSS)
// ** Gerado em    : 17 de Julho de 1996
// ** Programador  :  jcassiano Sistemas
// ** Linguagem    : harbour

#include "BOX.CH"

PADRAO("FO_CSAT","FO_CSAT","' '+STR(mCODIGO,7)+' '+mDESCRICAO","mCODIGO","C¢digos SAT","C¢digo Descri‡„o",;
 {|| PEGCHAVE("mCODIGO",ULTIMOREG("FO_CSAT","CODIGO",.T.),"Codigo:")},{|| tFO1O()},{|| gFO1O()},{|| FO_FOR("GRUPO='FIRMA'")})
RETU .T.



// +--------------------------------------------------------------------
// +
// +
// +
// +    Function tFO1O()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNC tFO1O


hb_DispBox(3,0,23,79,B_DOUBLE+" ")
@  4,1 SAY "C¢digo Descri‡„o"+Space(58)+"G TX"         
RETU .T.


// +--------------------------------------------------------------------
// +
// +
// +
// +    Function gFO1O()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +

FUNC gFO1O


@  5,1  GET mCODIGO                       
@  5,10 GET mDESCRICAO PICT "@S65"        
@  5,76 GET mGRAU                         
@  5,78 GET mTAXA                         
READCUR()
RETU .T.


*+ EOF: fo1o.prg
*+
