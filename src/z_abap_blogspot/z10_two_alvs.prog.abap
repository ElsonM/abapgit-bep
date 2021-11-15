*&---------------------------------------------------------------------*
*& Report Z10_TWO_ALVS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z10_two_alvs NO STANDARD PAGE HEADING.

TABLES: ekko, ekpo.

TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         lifnr TYPE ekko-lifnr,
         sel   TYPE char1,
       END OF ty_ekko,

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         lgort TYPE ekpo-lgort,
         sel   TYPE char1,
       END OF ty_ekpo.

DATA: wa_ekko TYPE                   ty_ekko,
      wa_ekpo TYPE                   ty_ekpo,
      it_ekko TYPE STANDARD TABLE OF ty_ekko,
      it_ekpo TYPE STANDARD TABLE OF ty_ekpo.

"Field Catalog structure and Tables
DATA: wa_fcat_ekko TYPE                   lvc_s_fcat,
      wa_fcat_ekpo TYPE                   lvc_s_fcat,
      it_fcat_ekko TYPE STANDARD TABLE OF lvc_s_fcat,
      it_fcat_ekpo TYPE STANDARD TABLE OF lvc_s_fcat.

"Object for Custom Container
DATA: ob_custom1 TYPE REF TO cl_gui_custom_container,
      ob_custom2 TYPE REF TO cl_gui_custom_container,

"Object for GRIDs
      ob_grid1   TYPE REF TO cl_gui_alv_grid,
      ob_grid2   TYPE REF TO cl_gui_alv_grid.

INITIALIZATION.
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
    SELECT-OPTIONS s_ebeln FOR ekko-ebeln.
  SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
*       CLASS purchase DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS purchase DEFINITION.

  PUBLIC SECTION.
    METHODS: get_ekko,       "Selection from EKKO
             get_ekpo,       "Selection from EKPO
             fieldcat_ekko,  "Fieldcatalog for Header Table
             fieldcat_ekpo.  "Fieldcatalog for Item Table

ENDCLASS.                    "purchase DEFINITION

*----------------------------------------------------------------------*
*       CLASS purchase IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS purchase IMPLEMENTATION.

  METHOD get_ekko.
    IF s_ebeln[] IS NOT INITIAL.
      SELECT ebeln bukrs lifnr
        FROM ekko INTO TABLE it_ekko
        WHERE ebeln IN s_ebeln.

      IF sy-subrc = 0.
        SORT it_ekko BY ebeln.
      ELSE.
        MESSAGE 'PO doesn''t exist' TYPE 'I'.
      ENDIF.
    ELSE.
      MESSAGE 'Please select a valid PO' TYPE 'I'.
    ENDIF.
  ENDMETHOD.                    "get_ekko

  METHOD get_ekpo.
    IF it_ekko IS NOT INITIAL.
      SELECT ebeln ebelp matnr werks lgort
        FROM ekpo INTO TABLE it_ekpo
        FOR ALL ENTRIES IN it_ekko
        WHERE ebeln = it_ekko-ebeln
          AND bukrs = it_ekko-bukrs.

      IF sy-subrc = 0.
        SORT it_ekpo BY ebeln.
        CALL METHOD: fieldcat_ekko,
                     fieldcat_ekpo.
        CALL SCREEN 9000.
      ELSE.
        MESSAGE 'Item doesn''t exist' TYPE 'I'.
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "get_ekpo

  METHOD fieldcat_ekko.

    CLEAR   wa_fcat_ekko.
    REFRESH it_fcat_ekko.

    DATA: lv_col TYPE i VALUE 0.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'EBELN'.
    wa_fcat_ekko-tabname   = 'IT_EKKO'.
    wa_fcat_ekko-reptext   = 'Purchase Order'.
    wa_fcat_ekko-col_opt   = 'X'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR  wa_fcat_ekko.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'BUKRS'.
    wa_fcat_ekko-tabname   = 'IT_EKKO'.
    wa_fcat_ekko-reptext   = 'Company Code'.
    wa_fcat_ekko-col_opt   = 'X'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR  wa_fcat_ekko.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'LIFNR'.
    wa_fcat_ekko-tabname   = 'IT_EKKO'.
    wa_fcat_ekko-reptext   = 'Vendor'.
    wa_fcat_ekko-col_opt   = 'X'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR  wa_fcat_ekko.

  ENDMETHOD.                    "fieldcat_ekko

  METHOD fieldcat_ekpo.

    CLEAR   wa_fcat_ekpo.
    REFRESH it_fcat_ekpo.

    DATA: lv_col TYPE i VALUE 0.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'EBELN'.
    wa_fcat_ekpo-tabname   = 'IT_EKPO'.
    wa_fcat_ekpo-reptext   = 'Purchase Order'.
    wa_fcat_ekpo-col_opt   = 'X'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR  wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'EBELP'.
    wa_fcat_ekpo-tabname   = 'IT_EKPO'.
    wa_fcat_ekpo-reptext   = 'Item'.
    wa_fcat_ekpo-col_opt   = 'X'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR  wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'MATNR'.
    wa_fcat_ekpo-tabname   = 'IT_EKPO'.
    wa_fcat_ekpo-reptext   = 'Material'.
    wa_fcat_ekpo-col_opt   = 'X'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR  wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'WERKS'.
    wa_fcat_ekpo-tabname   = 'IT_EKPO'.
    wa_fcat_ekpo-reptext   = 'Plant'.
    wa_fcat_ekpo-col_opt   = 'X'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR  wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'LGORT'.
    wa_fcat_ekpo-tabname   = 'IT_EKPO'.
    wa_fcat_ekpo-reptext   = 'Storage Location'.
    wa_fcat_ekpo-col_opt   = 'X'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR  wa_fcat_ekpo.

  ENDMETHOD.                    "fieldcat_ekpo

ENDCLASS.                    "purchase IMPLEMENTATION

START-OF-SELECTION.
  DATA: purchase TYPE REF TO purchase.
  CREATE OBJECT purchase.
  CALL METHOD: purchase->get_ekko,
               purchase->get_ekpo.

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'GUI_9000'.
  SET TITLEBAR  'TITLE_9000'.

" Object creation for custom container 1 exporting the name
  CREATE OBJECT ob_custom1
    EXPORTING
      container_name = 'CONTAINER1'.

" Object creation for custom container 2 exporting the name
  CREATE OBJECT ob_custom2
    EXPORTING
      container_name = 'CONTAINER2'.

" Object creation for ALV Grid 1 exporting the parent container 1
" It means container 1 contains ALV grid 1 - header table
  CREATE OBJECT ob_grid1
    EXPORTING
      i_parent = ob_custom1.

" Object creation for ALV Grid 2 exporting the parent container 2
" It means container 2 contains ALV grid 2 - item table
  CREATE OBJECT ob_grid2
    EXPORTING
      i_parent = ob_custom2.

* Calling the method to display the output table in ALV Grid 1.
* Here field catalog and output table are passed by changing parameter.
* Header table is passed here.
  CALL METHOD ob_grid1->set_table_for_first_display
    CHANGING
      it_fieldcatalog = it_fcat_ekko
      it_outtab       = it_ekko.

* Calling the method to display the output table in ALV Grid 2.
* Here field catalog and output table are passed by changing parameter.
* Item table is passed here.
  CALL METHOD ob_grid2->set_table_for_first_display
    CHANGING
      it_fieldcatalog = it_fcat_ekpo
      it_outtab       = it_ekpo.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.
  IF   sy-ucomm = 'BACK'
    OR sy-ucomm = 'EXIT'
    OR sy-ucomm = 'CANCEL'.

    FREE: ob_grid1, ob_grid2, ob_custom1, ob_custom2.
    REFRESH: it_ekko, it_ekpo.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.                 " USER_COMMAND_9000  INPUT
