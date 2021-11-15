*----------------------------------------------------------------------*
*       Module ST_BILDFLAG_BLAETTERN                                   *
*----------------------------------------------------------------------*
* Wenn das Bildflag   u n d   Blätter-OK-CODE für die Steuern          *
* gesetzt ist, muß das Bildflag temporär zurückgenommen werden.        *
*----------------------------------------------------------------------*
MODULE ST_BILDFLAG_BLAETTERN.

  IF NOT BILDFLAG IS INITIAL AND
     ( RMMZU-OKCODE = FCODE_STFP OR
       RMMZU-OKCODE = FCODE_STPP OR
       RMMZU-OKCODE = FCODE_STNP OR
       RMMZU-OKCODE = FCODE_STLP ).
    CLEAR BILDFLAG.
  ENDIF.

ENDMODULE.                             " ST_BILDFLAG_BLAETTERN
