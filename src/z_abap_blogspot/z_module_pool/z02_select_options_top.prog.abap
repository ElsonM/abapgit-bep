*&---------------------------------------------------------------------*
*&  Include           Z02_SELECT_OPTIONS_TOP
*&---------------------------------------------------------------------*

PROGRAM z02_select_options.

TABLES mara.

DATA ok_code TYPE sy-ucomm.

SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.

  SELECT-OPTIONS s_matnr FOR mara-matnr.

SELECTION-SCREEN END OF SCREEN 100.
