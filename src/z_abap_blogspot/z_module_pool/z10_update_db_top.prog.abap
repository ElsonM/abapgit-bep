*&---------------------------------------------------------------------*
*& Include Z10_UPDATE_DB_TOP             Module Pool      Z10_UPDATE_DB
*&
*&---------------------------------------------------------------------*
PROGRAM z10_update_db.

TABLES: zcustomers_mod_p.

*TYPES: BEGIN OF ty_cust,
*         id      TYPE zcustomers_mod_p-id,
*         name    TYPE zcustomers_mod_p-name,
*         address TYPE zcustomers_mod_p-address,
*       END OF ty_cust.

DATA: wa_cust TYPE zcustomers_mod_p,

      ok_code1 TYPE sy-ucomm,
      ok_code2 TYPE sy-ucomm.
