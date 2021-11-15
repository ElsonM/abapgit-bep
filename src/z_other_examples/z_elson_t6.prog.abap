*&---------------------------------------------------------------------*
*& Report Z_ELSON_T6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t6.

DATA lv_1    TYPE s_carr_id.      "Declaration using data elements
DATA lv_2    TYPE spfli-cityfrom. "Declaration using table fields
DATA ls_spli TYPE spfli_t.        "Declaration using structure type variables

lv_1 = '123'.
lv_2 = 'Tegucigalpa'.
ls_spli-carrname = 'carrname'.

WRITE: 'Original:',
       lv_1,
       lv_2,
       ls_spli-carrname.

MOVE lv_2 TO ls_spli-carrname.
WRITE: / 'lv_2:', lv_2, 'ls_spli-carrname:', ls_spli-carrname.
