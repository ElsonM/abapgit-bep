*&---------------------------------------------------------------------*
*&      Module  MARA_BMATN  INPUT               MK/4.0A Neu
*&---------------------------------------------------------------------*
* Prüfung der internen Materialnummer zum Herstellerteil
*----------------------------------------------------------------------*
MODULE MARA_BMATN INPUT.
  CHECK BILDFLAG = SPACE.
  CHECK T130M-AKTYP NE AKTYPA AND T130M-AKTYP NE AKTYPZ.

  CALL FUNCTION 'MARA_BMATN'
       EXPORTING
            P_BMATN = MARA-BMATN.

ENDMODULE.                             " MARA_BMATN  INPUT

* note 581171
*&---------------------------------------------------------------------*
*&      Module  MARA_MFRNR  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MARA_MFRNR INPUT.

  DATA H_LFA1 LIKE LFA1.

  CHECK BILDFLAG = SPACE.
  CHECK T130M-AKTYP NE AKTYPA AND T130M-AKTYP NE AKTYPZ.
  CHECK MARA-MFRNR NE LMARA-MFRNR AND NOT MARA-MFRNR IS INITIAL.

  CALL FUNCTION 'WY_LFA1_SINGLE_READ'
    EXPORTING
      PI_LIFNR                  = MARA-MFRNR
    IMPORTING
      PO_LFA1                   = H_LFA1
    EXCEPTIONS
      OTHERS                    = 1.
  IF NOT H_LFA1-LOEVM IS INITIAL.
*note 1473414
        CALL FUNCTION 'ME_CHECK_T160M'
         EXPORTING
              I_ARBGB = 'ME'
              I_MSGNR = '024'
              I_MSGVS = '00'          " Messagevariante default '00'
         EXCEPTIONS
              NOTHING = 00
              WARNING = 01
              ERROR   = 02.

    CASE SY-SUBRC.
      WHEN 1.
           MESSAGE W024(ME) WITH MARA-MFRNR.
      WHEN 2.
           MESSAGE E024(ME) WITH MARA-MFRNR.
      ENDCASE.


  ENDIF.

ENDMODULE.                 " MARA_MFRNR  INPUT
