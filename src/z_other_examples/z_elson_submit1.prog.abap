*&---------------------------------------------------------------------*
*& Report Z_ELSON_SUBMIT1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_submit1.

DATA: it_mara TYPE TABLE OF mara,
      wa_mara TYPE          mara.

IMPORT it_mara FROM MEMORY ID 'YOURID'.

LOOP AT it_mara INTO wa_mara.
  WRITE / wa_mara-matnr.
ENDLOOP.
