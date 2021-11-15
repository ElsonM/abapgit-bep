*&---------------------------------------------------------------------*
*& Report Z10_DATABASE_HINTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z10_database_hints.

TABLES: zst9_vbak.

PARAMETERS: p_ernam TYPE zst9_vbak-ernam.

DATA: myvbeln TYPE zst9_vbak-vbeln.

SELECT vbeln INTO myvbeln FROM zst9_vbak
  WHERE ernam EQ p_ernam
    %_HINTS SYBASE 'INDEX("ZST9_VBAK" "ZST9_VBAK~Z12")'.
  WRITE :/ myvbeln.
ENDSELECT.
