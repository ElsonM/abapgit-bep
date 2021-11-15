*&---------------------------------------------------------------------*
*&  Include           Z07_TABLE_CONTROL_DISABLE_TOP
*&---------------------------------------------------------------------*

PROGRAM z07_table_control_disable.

TABLES: vbak, vbap.
CONTROLS: tab_ctrl TYPE TABLEVIEW USING SCREEN 9001.

TYPES: BEGIN OF ty_vbak,
         vbeln TYPE vbak-vbeln,
         erdat TYPE vbak-erdat,
         ernam TYPE vbak-ernam,
         vkorg TYPE vbak-vkorg,
       END OF ty_vbak.

TYPES: BEGIN OF ty_vbap,
         vbeln TYPE vbap-vbeln,
         posnr TYPE vbap-posnr,
         matnr TYPE vbap-matnr,
         matkl TYPE vbap-matkl,
       END OF ty_vbap.

DATA: wa_vbak TYPE          ty_vbak,
      wa_vbap TYPE          ty_vbap,
      it_vbap TYPE TABLE OF ty_vbap.

DATA: ok_code TYPE sy-ucomm,
      disable TYPE c.
