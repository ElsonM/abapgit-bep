*&---------------------------------------------------------------------*
*& Report Z21_MULTI_ALV_DIFF_HEADERS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z21_multi_alv_diff_headers NO STANDARD PAGE HEADING.

TABLES: mara.

" General Material Data
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         ersda TYPE mara-ersda,
         mtart TYPE mara-mtart,
       END OF ty_mara.

DATA: wa_mara TYPE          ty_mara,
      it_mara TYPE TABLE OF ty_mara.

" Material Descriptions
TYPES: BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt.

DATA: wa_makt TYPE ty_makt,
      it_makt TYPE TABLE OF ty_makt.

" Output Table
TYPES: BEGIN OF ty_out,
         matnr TYPE mara-matnr,
         maktx TYPE makt-maktx,
         ersda TYPE mara-ersda,
         mtart TYPE mara-mtart,
       END OF ty_out.

DATA: wa_out TYPE          ty_out,
      it_fg  TYPE TABLE OF ty_out, " Finished Goods Table
      it_rm  TYPE TABLE OF ty_out. " Raw Materials Table

" Field Catalouge
DATA: wa_fcat TYPE          lvc_s_fcat,
      it_fcat TYPE TABLE OF lvc_s_fcat.

" Custom Container Object
DATA: ob_cont_fg TYPE REF TO cl_gui_custom_container,
      ob_cont_rm TYPE REF TO cl_gui_custom_container.

" ALV Grid Object
DATA: ob_grid_fg TYPE REF TO cl_gui_alv_grid,
      ob_grid_rm TYPE REF TO cl_gui_alv_grid.

" Layout
DATA: wa_lay_fg TYPE lvc_s_layo,
      wa_lay_rm TYPE lvc_s_layo,
      ok_code   TYPE sy-ucomm.

INITIALIZATION.
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
    SELECT-OPTIONS s_ersda FOR mara-ersda OBLIGATORY.
  SELECTION-SCREEN END OF BLOCK b1.

CLASS cl_material DEFINITION.
  PUBLIC SECTION.
    METHODS: get_material,
             prepare_output,
             fieldcat.
ENDCLASS.

CLASS cl_material IMPLEMENTATION.
  METHOD get_material.
    IF s_ersda[] IS NOT INITIAL.
      SELECT matnr ersda mtart
        FROM mara INTO TABLE it_mara
        WHERE ersda IN s_ersda
          AND mtart IN ( 'FERT', 'ROH' ).

      " FERT - Finished Goods
      " ROH  - Raw Materials

      IF sy-subrc = 0.
        SORT it_mara BY matnr.
        SELECT matnr maktx
          FROM makt INTO TABLE it_makt
          FOR ALL ENTRIES IN it_mara
          WHERE matnr = it_mara-matnr.

        IF sy-subrc = 0.
          SORT it_makt BY matnr.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD prepare_output.
    IF it_mara IS NOT INITIAL.
      LOOP AT it_mara INTO wa_mara.
        READ TABLE it_makt INTO wa_makt
          WITH KEY matnr = wa_mara-matnr
          BINARY SEARCH.
        IF sy-subrc = 0.
          wa_out-maktx = wa_makt-maktx.
        ENDIF.
        wa_out-matnr = wa_mara-matnr.
        wa_out-ersda = wa_mara-ersda.
        wa_out-mtart = wa_mara-mtart.

        IF wa_out-mtart = 'FERT'.
          APPEND wa_out TO it_fg.         " Finished Goods Table
          CLEAR: wa_out, wa_mara, wa_makt.

        ELSE.
          APPEND wa_out TO it_rm.         " Raw Materials Table
          CLEAR: wa_out, wa_mara, wa_makt.
        ENDIF.
      ENDLOOP.
    ENDIF.
    FREE: it_mara, it_makt.
  ENDMETHOD.

  METHOD fieldcat.

    "-Creating Field Catalouge
    REFRESH it_fcat.
    DATA: lv_col TYPE i VALUE 0.
    lv_col            = lv_col + 1.
    wa_fcat-col_pos   = lv_col.
    wa_fcat-fieldname = 'MATNR'.
    wa_fcat-reptext   = 'Material Code'.
    APPEND wa_fcat TO it_fcat.
    CLEAR  wa_fcat.

    lv_col            = lv_col + 1.
    wa_fcat-col_pos   = lv_col.
    wa_fcat-fieldname = 'MAKTX'.
    wa_fcat-reptext   = 'Description'.
    APPEND wa_fcat TO it_fcat.
    CLEAR  wa_fcat.

    lv_col            = lv_col + 1.
    wa_fcat-col_pos   = lv_col.
    wa_fcat-fieldname = 'ERSDA'.
    wa_fcat-reptext   = 'Created On'.
    APPEND wa_fcat TO it_fcat.
    CLEAR  wa_fcat.

    lv_col            = lv_col + 1.
    wa_fcat-col_pos   = lv_col.
    wa_fcat-fieldname = 'MTART'.
    wa_fcat-reptext   = 'Material Type'.
    APPEND wa_fcat TO it_fcat.
    CLEAR  wa_fcat.

    " Creating Layout
    wa_lay_fg-zebra      = 'X'.
    wa_lay_fg-cwidth_opt = 'X'.
    wa_lay_fg-grid_title = 'Finished Goods Materials'.

    wa_lay_rm-zebra      = 'X'.
    wa_lay_rm-cwidth_opt = 'X'.
    wa_lay_rm-grid_title = 'Raw Materials'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: ob_material TYPE REF TO cl_material.
  CREATE OBJECT ob_material.
  CALL METHOD: ob_material->get_material,
               ob_material->prepare_output,
               ob_material->fieldcat.
  CALL SCREEN 9000.                  " Calling Custom Screen

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       PBO of 9000
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'PF_9000'.
  SET TITLEBAR  'MAT'.

  PERFORM finished_goods_alv.
  PERFORM raw_materials_alv.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       PAI of 9000
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  IF   ok_code = 'BACK'
    OR ok_code = 'EXIT'
    OR ok_code = 'CANCEL'.
    FREE: ob_cont_fg, ob_grid_fg, ob_cont_rm, ob_grid_rm,
          it_fcat, it_fg, it_rm.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  FINISHED_GOODS_ALV
*&---------------------------------------------------------------------*
*       ALV of FG
*----------------------------------------------------------------------*
FORM finished_goods_alv.
  CREATE OBJECT ob_cont_fg
    EXPORTING
      container_name = 'CONT_FG'. " Creating Container
  " In layout CONT_FG name is given

  CREATE OBJECT ob_grid_fg
    EXPORTING
      i_parent = ob_cont_fg. " Creating ALV Grid

  " ALV Grid Display Method
  CALL METHOD ob_grid_fg->set_table_for_first_display
    EXPORTING
      is_layout       = wa_lay_fg
    CHANGING
      it_fieldcatalog = it_fcat
      it_outtab       = it_fg.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  RAW_MATERIALS_ALV
*&---------------------------------------------------------------------*
*       ALV of RM
*----------------------------------------------------------------------*
FORM raw_materials_alv.
  CREATE OBJECT ob_cont_rm
    EXPORTING
      container_name = 'CONT_RM'. " Creating Container
  " In layout CONT_RM name is given

  CREATE OBJECT ob_grid_rm
    EXPORTING
      i_parent = ob_cont_rm. " Creating ALV Grid

  " ALV Grid Display Method
  CALL METHOD ob_grid_rm->set_table_for_first_display
    EXPORTING
      is_layout       = wa_lay_rm
    CHANGING
      it_fieldcatalog = it_fcat
      it_outtab       = it_rm.
ENDFORM.
