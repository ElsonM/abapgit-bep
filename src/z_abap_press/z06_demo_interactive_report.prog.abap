*&---------------------------------------------------------------------*
*& Report Z06_DEMO_INTERACTIVE_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z06_demo_interactive_report.

TYPES: BEGIN OF ty_sflight,
         carrid   TYPE sflight-carrid,
         connid   TYPE sflight-connid,
         fldate   TYPE sflight-fldate,
         price    TYPE sflight-price,
         currency TYPE sflight-currency,
       END OF ty_sflight.

DATA: it_sflight  TYPE STANDARD TABLE OF ty_sflight,
      it_fieldcat TYPE slis_t_fieldcat_alv.

PARAMETERS p_carrid TYPE sflight-carrid.

START-OF-SELECTION.
  PERFORM get_data USING p_carrid CHANGING it_sflight.

END-OF-SELECTION.
  PERFORM field_catalog CHANGING it_fieldcat.
  PERFORM show_output.

*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
FORM get_data USING    p_p_carrid
              CHANGING pt_sflight LIKE it_sflight.

  SELECT carrid connid fldate price currency FROM sflight
    INTO TABLE pt_sflight
    WHERE carrid EQ p_p_carrid.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM field_catalog CHANGING pt_fieldcat LIKE it_fieldcat.

  DATA lw_fieldcat LIKE LINE OF pt_fieldcat.

  lw_fieldcat-col_pos   = 1.
  lw_fieldcat-fieldname = 'CARRID'.
  lw_fieldcat-tabname   = 'IT_SFLIGHT'.
  lw_fieldcat-seltext_m = 'Airline Code'.
  APPEND lw_fieldcat TO pt_fieldcat.
  CLEAR lw_fieldcat.

  lw_fieldcat-col_pos   = 2.
  lw_fieldcat-fieldname = 'CONNID'.
  lw_fieldcat-tabname   = 'IT_SFLIGHT'.
  lw_fieldcat-seltext_l = 'Flight Connection Number'.
  lw_fieldcat-outputlen = 25.
  APPEND lw_fieldcat TO pt_fieldcat.
  CLEAR lw_fieldcat.

  lw_fieldcat-col_pos   = 3.
  lw_fieldcat-fieldname = 'FLDATE'.
  lw_fieldcat-tabname   = 'IT_SFLIGHT'.
  lw_fieldcat-seltext_m = 'Flight Date'.
  APPEND lw_fieldcat TO pt_fieldcat.
  CLEAR lw_fieldcat.

  lw_fieldcat-col_pos   = 4.
  lw_fieldcat-fieldname = 'PRICE'.
  lw_fieldcat-tabname   = 'IT_SFLIGHT'.
  lw_fieldcat-seltext_m = 'Airfare'.
  APPEND lw_fieldcat TO pt_fieldcat.
  CLEAR lw_fieldcat.

  lw_fieldcat-col_pos   = 5.
  lw_fieldcat-fieldname = 'CURRENCY'.
  lw_fieldcat-tabname   = 'IT_SFLIGHT'.
  lw_fieldcat-seltext_m = 'Airline Currency'.
  APPEND lw_fieldcat TO pt_fieldcat.
  CLEAR lw_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form SHOW_OUTPUT
*&---------------------------------------------------------------------*
FORM show_output.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = 'Z06_DEMO_INTERACTIVE_REPORT'
      i_callback_pf_status_set = 'SET_PF_STATUS'
      i_callback_top_of_page   = 'TOP_OF_PAGE'
      i_grid_title             = 'ALV Grid Display'
      it_fieldcat              = it_fieldcat
    TABLES
      t_outtab                 = it_sflight
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

*&--------------------------------------------------------------*
*& Form SET_PF_STATUS
*&--------------------------------------------------------------*
FORM set_pf_status USING rt_extab TYPE slis_t_extab.

  DATA rw_extab LIKE LINE OF rt_extab.

  IF it_sflight IS INITIAL.
    CLEAR rt_extab.
    rw_extab-fcode = 'PDF'.
    APPEND rw_extab TO rt_extab.
    SET PF-STATUS 'GUIALV' EXCLUDING rt_extab.
  ELSE.
    SET PF-STATUS 'GUIALV'.
  ENDIF.

ENDFORM.

*&--------------------------------------------------------------*
*& Form TOP_OF_PAGE
*&--------------------------------------------------------------*
FORM top_of_page.

  DATA: lt_cw TYPE slis_t_listheader,
        lw_cw TYPE slis_listheader.

  lw_cw-typ  = 'H'.
  lw_cw-info = 'Flight Information'.
  APPEND lw_cw TO lt_cw.

  lw_cw-typ  = 'S'.
  lw_cw-key  = p_carrid.
  lw_cw-info = 'Selection criteria'.
  APPEND lw_cw TO lt_cw.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_cw.

ENDFORM.
