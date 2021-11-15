*-----------------------------------------------------------------------
*  Module MARA-MHDRZ
* Verprobungen zu Mindestrestlaufzeit/Gesamthaltbarkeit/Lagerprozentsatz
*-----------------------------------------------------------------------
MODULE MARA-MHDRZ.

  CHECK BILDFLAG = SPACE.
  CHECK T130M-AKTYP NE AKTYPA AND T130M-AKTYP NE AKTYPZ.

  CALL FUNCTION 'MARA_MHDRZ'
       EXPORTING
            P_MARA_MHDRZ = MARA-MHDRZ
            RET_MHDRZ    = LMARA-MHDRZ
            P_MARA_MHDHB = MARA-MHDHB
            RET_MHDHB    = LMARA-MHDHB
            P_MARA_MHDLP = MARA-MHDLP
            RET_MHDLP    = LMARA-MHDLP
* AHE: 19.03.98 - A (4.0c)
            P_MARA_IPRKZ = MARA-IPRKZ
            RET_IPRKZ    = LMARA-IPRKZ
* AHE: 19.03.98 - E
       IMPORTING
            RET_MHDRZ    = LMARA-MHDRZ
            RET_MHDHB    = LMARA-MHDHB
            RET_MHDLP    = LMARA-MHDLP
* AHE: 19.03.98 - A (4.0c)
            RET_IPRKZ    = LMARA-IPRKZ.
* AHE: 19.03.98 - E

ENDMODULE.
