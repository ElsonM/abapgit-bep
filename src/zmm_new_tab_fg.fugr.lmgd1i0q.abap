*-----------------------------------------------------------------------
*  Module MARA-KUNNR
*  Prüfung des Wettbewerbers gegen den Kundenstamm. Das Kennzeichen
*  'Debitor ist Wettbewerber' muß gesetzt sein
*-----------------------------------------------------------------------
MODULE MARA-KUNNR.

  CHECK BILDFLAG = SPACE.
  CHECK T130M-AKTYP NE AKTYPA AND T130M-AKTYP NE AKTYPZ.

  CALL FUNCTION 'MARA_KUNNR'
       EXPORTING
            P_MARA_KUNNR = MARA-KUNNR.
*      EXCEPTIONS
*           ERROR_KUNNR  = 01.

ENDMODULE.
