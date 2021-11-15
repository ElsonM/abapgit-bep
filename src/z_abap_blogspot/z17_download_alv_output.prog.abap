*&---------------------------------------------------------------------*
*& Report Z17_DOWNLOAD_ALV_OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z17_download_alv_output NO STANDARD PAGE HEADING.

TABLES: mara.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
       END OF ty_mara.

      "Internal Tables & Work Area
DATA: wa_mara TYPE ty_mara,
      it_mara TYPE TABLE OF ty_mara.

      "Field Catalogue
DATA: wa_fcat TYPE slis_fieldcat_alv,
      it_fcat TYPE slis_t_fieldcat_alv,

      "Layout
      wa_layout TYPE slis_layout_alv,

      "Top of Page
       wa_top TYPE slis_listheader,
       it_top TYPE slis_t_listheader.

INITIALIZATION.
  PARAMETERS: p_mtart TYPE mara-mtart.

START-OF-SELECTION.
  PERFORM get_mara. "--------------------------------------Get Materials

END-OF-SELECTION.
  PERFORM field_catalog. "-------------------------------Field Catalogue
  PERFORM layout. "-------------------------------------------Get Layout
  PERFORM transfer_output. "----------------------Transferring into Text
  PERFORM alv_output. "---------------------------------------ALV Output

TOP-OF-PAGE.
  PERFORM top_of_page. "-------------------------------------Top of Page

*&---------------------------------------------------------------------*
*&      Form  GET_MARA
*&---------------------------------------------------------------------*
*       Get data from MARA
*----------------------------------------------------------------------*
FORM get_mara.
  IF p_mtart IS NOT INITIAL.
    SELECT matnr mtart
      FROM mara INTO TABLE it_mara
      WHERE mtart = p_mtart.

    IF sy-subrc = 0.
      SORT it_mara.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG
*&---------------------------------------------------------------------*
*       Field Catalogue
*----------------------------------------------------------------------*
FORM field_catalog.
  DATA: lv_col TYPE i VALUE 0.

  IF it_mara IS NOT INITIAL.
    lv_col            = 1 + lv_col.
    wa_fcat-col_pos   = lv_col.
    wa_fcat-fieldname = 'MATNR'.
    wa_fcat-seltext_l = 'Material No'.
    APPEND wa_fcat TO it_fcat.
    CLEAR  wa_fcat.

    lv_col            = 1 + lv_col.
    wa_fcat-col_pos   = lv_col.
    wa_fcat-fieldname = 'MTART'.
    wa_fcat-seltext_l = 'Material Type'.
    APPEND wa_fcat TO it_fcat.
    CLEAR  wa_fcat.

  ELSE.
    MESSAGE 'No Material Found' TYPE 'I'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  LAYOUT
*&---------------------------------------------------------------------*
*       Prepare Layout
*----------------------------------------------------------------------*
FORM layout.
  wa_layout-zebra             = 'X'.
  wa_layout-colwidth_optimize = 'X'.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  TRANSFER_OUTPUT
*&---------------------------------------------------------------------*
*       Transferring into Text
*----------------------------------------------------------------------*
FORM transfer_output.
  DATA: lv_out   TYPE string,
        lv_fname TYPE string.

  "It will store the text file into Application Server Path
  lv_fname = 'C:\MATERIALS.TXT'.

  OPEN DATASET lv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

  "Header in Text file
  CONCATENATE 'Material_No.'
              'Material_Type'
              INTO lv_out SEPARATED BY ' '.
  TRANSFER lv_out TO lv_fname.

  "Data in Text file
  LOOP AT it_mara INTO wa_mara.
    CONCATENATE wa_mara-matnr
                wa_mara-mtart
                INTO lv_out SEPARATED BY ' '.
    TRANSFER lv_out TO lv_fname.
    CLEAR: wa_mara, lv_out.
  ENDLOOP.
  CLOSE DATASET lv_fname.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT
*&---------------------------------------------------------------------*
*       ALV Output
*----------------------------------------------------------------------*
FORM alv_output.
  IF it_fcat IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program     = sy-repid
        i_callback_top_of_page = 'TOP_OF_PAGE'
        is_layout              = wa_layout
        it_fieldcat            = it_fcat
      TABLES
        t_outtab               = it_mara
      EXCEPTIONS
        program_error          = 1
        OTHERS                 = 2.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       Top of Page
*----------------------------------------------------------------------*
FORM top_of_page.
  CLEAR wa_top.
  REFRESH it_top.

  wa_top-typ  = 'H'.
  wa_top-info = 'Material List'.
  APPEND wa_top TO it_top.
  CLEAR  wa_top.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_top.
ENDFORM.
