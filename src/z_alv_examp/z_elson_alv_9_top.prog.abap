*&---------------------------------------------------------------------*
*& Include Z_ELSON_EX9_TOP
*&
*&---------------------------------------------------------------------*

*Data Declaration
TYPES: BEGIN OF ty_ekko,
         sel,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         statu TYPE ekpo-statu,
         aedat TYPE ekpo-aedat,
         matnr TYPE ekpo-matnr,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         netpr TYPE ekpo-netpr,
         peinh TYPE ekpo-peinh,
       END OF ty_ekko.

DATA: it_ekko TYPE TABLE OF ty_ekko,
      wa_ekko TYPE          ty_ekko.


*ALV data declarations
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid.
