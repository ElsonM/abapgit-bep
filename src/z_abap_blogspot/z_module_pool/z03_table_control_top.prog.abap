*&---------------------------------------------------------------------*
*&  Include           Z03_TABLE_CONTROL_TOP
*&---------------------------------------------------------------------*

PROGRAM z03_table_control.

*-------Declaration of tables for screen fields------------------------*
TABLES: ekko, ekpo.

*-------Declaration of required structures-----------------------------*
TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         ernam TYPE ekko-ernam,
         lifnr TYPE ekko-lifnr,
       END OF ty_ekko,

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         lgort TYPE ekpo-lgort,
       END OF ty_ekpo.

*-------Declaration of user command variables-------------------------*
DATA: ok_code1 TYPE sy-ucomm,
      ok_code2 TYPE sy-ucomm.

*-------Declaration of work area & table------------------------------*
DATA: wa_ekko TYPE          ty_ekko,
      wa_ekpo TYPE          ty_ekpo,
      it_ekpo TYPE TABLE OF ty_ekpo.

*-------Declaration of Table Control----------------------------------*
CONTROLS: tab_ctrl TYPE TABLEVIEW USING SCREEN 9002.
