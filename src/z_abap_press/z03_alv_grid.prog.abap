*&---------------------------------------------------------------------*
*& Report Z03_ALV_GRID
*&---------------------------------------------------------------------*
REPORT z03_alv_grid.

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
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data USING    p_p_carrid
              CHANGING pt_sflight LIKE it_sflight.

  SELECT carrid connid fldate price currency FROM sflight
    INTO TABLE pt_sflight
    WHERE carrid EQ p_p_carrid.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FIELD_CATALOG
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
*&      Form  SHOW_OUTPUT
*&---------------------------------------------------------------------*
FORM show_output.

  DATA layout TYPE slis_layout_alv.
  layout-edit = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_grid_title  = 'ALV Grid Display'
      is_layout     = layout
      it_fieldcat   = it_fieldcat
    TABLES
      t_outtab      = it_sflight
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
