*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_18.

TABLES: mara.
DATA: lo_cont TYPE REF TO cl_gui_custom_container. "Custom Container
DATA: lo_alv  TYPE REF TO cl_gui_alv_grid.         "ALV Grid
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         mbrsh TYPE mara-mbrsh,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
       END OF ty_mara.
DATA: it_mara TYPE TABLE OF ty_mara,
      wa_mara TYPE ty_mara.
DATA: it_fieldcatalog TYPE lvc_t_fcat,
      wa_fieldcatalog TYPE lvc_s_fcat.
SELECT-OPTIONS: s_matnr FOR mara-matnr.

START-OF-SELECTION.
* Here 100 is the screen number which we are going to create, you can create any like: 200, 300 etc
  CALL SCREEN 100. "Double click on 100 to create a screen

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CREATE OBJECT lo_cont
    EXPORTING
      container_name = 'CC_ALV'.

  CREATE OBJECT lo_alv
    EXPORTING
      i_parent = lo_cont.

* Build Field Catalogue
  wa_fieldcatalog-col_pos   = '1'. "Set column 1
  wa_fieldcatalog-fieldname = 'MATNR'.
  wa_fieldcatalog-tabname   = 'MARA'.
  wa_fieldcatalog-scrtext_m = 'Material No'.
  APPEND wa_fieldcatalog TO it_fieldcatalog.
  CLEAR wa_fieldcatalog.

  wa_fieldcatalog-col_pos   = '2'. "Set column 2
  wa_fieldcatalog-fieldname = 'MTART'.
  wa_fieldcatalog-tabname   = 'MARA'.
  wa_fieldcatalog-scrtext_m = 'Material Type'.
  APPEND wa_fieldcatalog TO it_fieldcatalog.
  CLEAR wa_fieldcatalog.

  wa_fieldcatalog-col_pos   = '3'. "Set column 3
  wa_fieldcatalog-fieldname = 'MBRSH'.
  wa_fieldcatalog-tabname   = 'MARA'.
  wa_fieldcatalog-scrtext_m = 'Industry Sector'.
  APPEND wa_fieldcatalog TO it_fieldcatalog.
  CLEAR wa_fieldcatalog.

  wa_fieldcatalog-col_pos   = '4'. "set column 4
  wa_fieldcatalog-fieldname = 'MATKL'.
  wa_fieldcatalog-tabname   = 'MARA'.
  wa_fieldcatalog-scrtext_m = 'Material Group'.
  APPEND wa_fieldcatalog TO it_fieldcatalog.
  CLEAR wa_fieldcatalog.

  wa_fieldcatalog-col_pos   = '5'. "Set column 5
  wa_fieldcatalog-fieldname = 'MEINS'.
  wa_fieldcatalog-tabname   = 'MARA'.
  wa_fieldcatalog-scrtext_m   = 'Unit Of Measure'.
  APPEND wa_fieldcatalog TO it_fieldcatalog.
  CLEAR : wa_fieldcatalog.
* End field catalogue

  SELECT matnr mtart mbrsh matkl meins FROM mara
    INTO TABLE it_mara WHERE matnr IN s_matnr.

  CALL METHOD lo_alv->set_table_for_first_display
    CHANGING
      it_outtab       = it_mara
      it_fieldcatalog = it_fieldcatalog.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

ENDMODULE.
