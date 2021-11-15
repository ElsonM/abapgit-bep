*&---------------------------------------------------------------------*
*& Report Z_ELSON_FM_ALV3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_fm_alv3.

*&---------------------------------------------------------------------*
*& Data Declaration
*&---------------------------------------------------------------------*
DATA: it_spfli      TYPE TABLE OF spfli.
DATA: g_repid       TYPE          sy-repid.
DATA: it_listheader TYPE          slis_t_listheader,
      wa_listheader TYPE          slis_listheader.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  g_repid = sy-repid.

  SELECT * FROM spfli INTO TABLE it_spfli.

  PERFORM build_alv_header.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = g_repid
      i_callback_top_of_page = 'TOP_OF_PAGE'
      i_structure_name       = 'SPFLI'
    TABLES
      t_outtab               = it_spfli.

*&---------------------------------------------------------------------*
*&      Form  BUILD_ALV_HEADER
*&---------------------------------------------------------------------*
FORM build_alv_header.

* Type H is used to display headers i.e. big font
  wa_listheader-typ  =  'H'.
  wa_listheader-info = 'Flight Details'.
  APPEND wa_listheader TO it_listheader.
  CLEAR wa_listheader.

* Type S is used to display key and value pairs
  wa_listheader-typ = 'S'.
  wa_listheader-key = 'Date:'.
  CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum(4)
    INTO wa_listheader-info
    SEPARATED BY '/'.
  APPEND wa_listheader TO it_listheader.
  CLEAR wa_listheader.

* Type A is used to display italic font
  wa_listheader-typ  = 'A'.
  wa_listheader-info = 'SAP ALV Report'.
  APPEND wa_listheader TO it_listheader.
  CLEAR wa_listheader.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form TOP_OF_PAGE
*&---------------------------------------------------------------------*
FORM top_of_page.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_listheader
      i_logo             = 'FRESH'.

ENDFORM.
