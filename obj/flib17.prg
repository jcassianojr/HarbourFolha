*+--------------------------------------------------------------------
*+
*+
*+
*+    Programa  : flib17.prg
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

// !*****************************************************************************
// !
// !         Fun‡„o: ULTIMOREG() ABRE ARQUIVO PEGA ULTIMO REGISTRO CAMPO
// !
// !   Parametros  : PARAMETRO ARQUIVO,CAMPO,lSOMA
// !
// !*****************************************************************************

// +--------------------------------------------------------------------
// +
// +
// +
// +    Function ULTIMOREG()
// +
// +
// +
// +--------------------------------------------------------------------
// +
// +
// +
FUNCTION ULTIMOREG(ARQWORK,FIEWORK,lSOMA)


IF ValType(lSOMA) # "L"
   lSOMA := .F.
ENDIF
IF !NETUSE(ARQWORK)
   RETU
ENDIF
dbGoBottom()
RETORNO := &FIEWORK.
dbCloseAll()
IF lSOMA .AND. ValType(RETORNO) = "N"
   RETORNO ++
ENDIF
RETU RETORNO



// {|| PEGCHAVE("m",ULTIMOREG(cARQ,cCAMPO,.T.),":")}


*+ EOF: flib17.prg
*+
