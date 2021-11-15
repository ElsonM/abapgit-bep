*&---------------------------------------------------------------------*
*& Report Z22_ALV_BOLD_TEXT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z22_alv_bold_text.

TABLES: ekko.

DATA: wa_fcat   TYPE lvc_s_fcat,
      it_fcat   TYPE lvc_t_fcat,

      wa_layout TYPE lvc_s_layo,

      wa_top    TYPE slis_listheader,
      it_top    TYPE slis_t_listheader.

TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         aedat TYPE ekko-aedat,
       END OF ty_ekko.

DATA: wa_ekko TYPE          ty_ekko,
      it_ekko TYPE TABLE OF ty_ekko.

TYPES: BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
       END OF ty_ekpo.

DATA: wa_ekpo TYPE          ty_ekpo,
      it_ekpo TYPE TABLE OF ty_ekpo.

TYPES: BEGIN OF ty_out,
         ebeln TYPE char15,
         ebelp TYPE char5,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         color TYPE char4,
         bold  TYPE lvc_t_styl,
       END OF ty_out.

DATA: wa_out TYPE          ty_out,
      it_out TYPE TABLE OF ty_out.

INITIALIZATION.
  SELECT-OPTIONS s_aedat FOR ekko-aedat.

START-OF-SELECTION.
  PERFORM get_ekko.
  PERFORM get_ekpo.

END-OF-SELECTION.
  PERFORM prepare_output.
  PERFORM field_catalog.
  PERFORM alv_grid_display.

TOP-OF-PAGE.
  PERFORM top_of_page.

*&---------------------------------------------------------------------*
*&      Form  GET_EKKO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_ekko.
  SELECT ebeln aedat FROM ekko
    INTO TABLE it_ekko
    WHERE aedat IN s_aedat.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_ekpo.
  IF it_ekko IS NOT INITIAL.
    SELECT ebeln ebelp matnr werks menge meins
      FROM ekpo INTO TABLE it_ekpo
      FOR ALL ENTRIES IN it_ekko
      WHERE ebeln = it_ekko-ebeln
        AND matnr NE ' '.

    IF sy-subrc = 0.
      SORT it_ekpo BY ebeln ebelp.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PREPARE_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM prepare_output.
  DATA: lw_bold TYPE lvc_s_styl,
        lt_bold TYPE lvc_t_styl.

  IF it_ekpo IS NOT INITIAL.
    LOOP AT it_ekpo INTO wa_ekpo.
      wa_out-ebeln = wa_ekpo-ebeln.
      wa_out-ebelp = wa_ekpo-ebelp.
      wa_out-matnr = wa_ekpo-matnr.
      SHIFT wa_out-matnr LEFT DELETING LEADING '0'.
      wa_out-werks = wa_ekpo-werks.
      wa_out-menge = wa_ekpo-menge.
      wa_out-meins = wa_ekpo-meins.
      APPEND wa_out TO it_out.
      CLEAR: wa_out.

      AT END OF ebeln.
        SUM.
        wa_out-ebeln = 'Sub Total'.
        wa_out-menge = wa_ekpo-menge.
        wa_out-color = 'C200'.
        lw_bold-style = '00000121'.
        INSERT lw_bold INTO lt_bold INDEX 1.
        wa_out-bold = lt_bold.
        FREE lt_bold.

        APPEND wa_out TO it_out.
        CLEAR: wa_out, lw_bold, wa_ekpo.
      ENDAT.

      AT LAST.
        SUM.
        wa_out-ebeln = 'Grand Total'.
        wa_out-menge = wa_ekpo-menge.
        wa_out-color = 'C210'.
        lw_bold-style = '00000121'.
        INSERT lw_bold INTO lt_bold INDEX 1.
        wa_out-bold = lt_bold.
        FREE lt_bold.

        APPEND wa_out TO it_out.
        CLEAR: wa_out, lw_bold, wa_ekpo.
      ENDAT.
    ENDLOOP.
  ENDIF.

  FREE it_ekpo.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM field_catalog.
  DATA: lv_col TYPE i VALUE 0.

  lv_col            = 1 + lv_col.
  wa_fcat-col_pos   = lv_col.
  wa_fcat-fieldname = 'EBELN'.
  wa_fcat-reptext   = 'Purchase Order'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  lv_col            = 1 + lv_col.
  wa_fcat-col_pos   = lv_col.
  wa_fcat-fieldname = 'EBELP'.
  wa_fcat-reptext   = 'Item'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  lv_col            = 1 + lv_col.
  wa_fcat-col_pos   = lv_col.
  wa_fcat-fieldname = 'MATNR'.
  wa_fcat-reptext   = 'Material'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  lv_col            = 1 + lv_col.
  wa_fcat-col_pos   = lv_col.
  wa_fcat-fieldname = 'WERKS'.
  wa_fcat-reptext   = 'Plant'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  lv_col            = 1 + lv_col.
  wa_fcat-col_pos   = lv_col.
  wa_fcat-fieldname = 'MENGE'.
  wa_fcat-reptext   = 'Quantity'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

  lv_col            = 1 + lv_col.
  wa_fcat-col_pos   = lv_col.
  wa_fcat-fieldname = 'MEINS'.
  wa_fcat-reptext   = 'Unit'.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

*  wa_layout-zebra      = 'X'.
  wa_layout-cwidth_opt = 'X'.
  wa_layout-info_fname = 'COLOR'.
  wa_layout-stylefname = 'BOLD'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_GRID_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_grid_display .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP_OF_PAGE'
      is_layout_lvc          = wa_layout
      it_fieldcat_lvc        = it_fcat
    TABLES
      t_outtab               = it_out
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top_of_page .

  REFRESH it_top.

  wa_top-typ  = 'H'.
  wa_top-info = 'Purchasing List'.
  APPEND wa_top TO it_top.
  CLEAR wa_top.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_top.

ENDFORM.
