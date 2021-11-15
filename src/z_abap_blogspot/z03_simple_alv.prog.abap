*&---------------------------------------------------------------------*
*& Report Z03_SIMPLE_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z03_simple_alv.

*------Declaring local structure---------------------------------------*
TYPES: BEGIN OF ty_scarr,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
       END OF ty_scarr.

*-----Declaring work area and internal table---------------------------*
DATA: wa_scarr TYPE          ty_scarr,
      it_scarr TYPE TABLE OF ty_scarr.


*-----Declaring the field catalog work area & internal table-----------*
DATA: wa_fcat   TYPE slis_fieldcat_alv,
      it_fcat   TYPE slis_t_fieldcat_alv,

*-----Declaring the work area of ALV Layout----------------------------*
      wa_layout TYPE slis_layout_alv,

*-----Declaring the work area & internal table for Top of Page---------*
      wa_top    TYPE slis_listheader,
      it_top    TYPE slis_t_listheader.

*---Event Initialization-----------------------------------------------*
INITIALIZATION.
  SELECT-OPTIONS: s_carrid FOR wa_scarr-carrid. "Input selection criteria

*---Event Start of Selection-------------------------------------------*
START-OF-SELECTION.
  PERFORM get_scarr.

*---Event End of Selection---------------------------------------------*
END-OF-SELECTION.
  PERFORM alv_field_catalog.
  PERFORM alv_layout.
  PERFORM alv_grid_display.

*---Event Top of Page-----------------------------------------------*
TOP-OF-PAGE.
  PERFORM top_of_scarr.

*&---------------------------------------------------------------------*
*&      Form  get_scarr
*&---------------------------------------------------------------------*
*       Selection of Airline table data
*----------------------------------------------------------------------*
FORM get_scarr.

  IF s_carrid[] IS NOT INITIAL.
    SELECT carrid carrname currcode
      FROM scarr INTO TABLE it_scarr
      WHERE carrid IN s_carrid.

    IF sy-subrc = 0.
      SORT it_scarr.
    ELSE.
      MESSAGE 'Airline doesn''t exist' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_scarr

*&---------------------------------------------------------------------*
*&      Form  alv_field_catalog
*&---------------------------------------------------------------------*
*       Preparing ALV field catalog
*----------------------------------------------------------------------*
FORM alv_field_catalog.

*----Local variable to count the column position-----------------------*
  DATA: lv_col TYPE i VALUE 0.

  IF it_scarr IS NOT INITIAL.
    lv_col            = 1 + lv_col.
    wa_fcat-col_pos   = lv_col.         "Column position
    wa_fcat-fieldname = 'CARRID'.       "Technical field name
    wa_fcat-tabname   = 'IT_SCARR'.     "Output table name
    wa_fcat-seltext_l = 'Airline Code'. "Field text
    APPEND wa_fcat TO it_fcat.          "Preparing the fieldcat table
    CLEAR wa_fcat.

    lv_col            = 1 + lv_col.
    wa_fcat-col_pos   = lv_col.
    wa_fcat-fieldname = 'CARRNAME'.
    wa_fcat-tabname   = 'IT_SCARR'.
    wa_fcat-seltext_l = 'Airline Name'.
    APPEND wa_fcat TO it_fcat.
    CLEAR wa_fcat.

    lv_col            = 1 + lv_col.
    wa_fcat-col_pos   = lv_col.
    wa_fcat-fieldname = 'CURRCODE'.
    wa_fcat-tabname   = 'IT_SCARR'.
    wa_fcat-seltext_l = 'Local Currency'.
    APPEND wa_fcat TO it_fcat.
    CLEAR wa_fcat.
  ENDIF.

ENDFORM.                    " alv_field_catalog

*&---------------------------------------------------------------------*
*&      Form  alv_layout
*&---------------------------------------------------------------------*
*       Preparing the ALV Layout
*----------------------------------------------------------------------*
FORM alv_layout.

  wa_layout-zebra = 'X'.             "Calling the Zebra layout
  wa_layout-colwidth_optimize = 'X'. "Width of the column is optimized

ENDFORM.                    " alv_layout

*&---------------------------------------------------------------------*
*&      Form  top_of_scarr
*&---------------------------------------------------------------------*
*       Preparing the Top of Page
*----------------------------------------------------------------------*
FORM top_of_scarr.

  REFRESH it_top.

  wa_top-typ  = 'H'.            "Header type
  wa_top-info = 'Airline List'. "Header text
  APPEND wa_top TO it_top.
  CLEAR wa_top.

  wa_top-typ  = 'S'.            "Normal line type
  wa_top-info = 'Report: '.     "Normal line text
  CONCATENATE wa_top-info sy-repid INTO wa_top-info.
  "Concatenating the text info with program name
  APPEND wa_top TO it_top.
  CLEAR wa_top.

  wa_top-typ  = 'S'.
  wa_top-info = 'User: '.
  CONCATENATE wa_top-info sy-uname INTO wa_top-info.
  "Concatenating the text info with user name
  APPEND wa_top TO it_top.
  CLEAR wa_top.

*-Calling Function Module for displaying Top of Page-------------------*
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_top. "Passing the internal table

ENDFORM.                    " top_of_scarr

*&---------------------------------------------------------------------*
*&      Form  alv_grid_display
*&---------------------------------------------------------------------*
*       Preparing the final output by using Grid Display
*----------------------------------------------------------------------*
FORM alv_grid_display.

  IF    it_scarr IS NOT INITIAL
    AND it_fcat  IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program     = sy-repid       "Program name
        i_callback_top_of_page = 'TOP_OF_SCARR'
        is_layout              = wa_layout
        it_fieldcat            = it_fcat
      TABLES
        t_outtab               = it_scarr       "Final output table
      EXCEPTIONS
        program_error          = 1
        OTHERS                 = 2.

    IF sy-subrc <> 0.
      MESSAGE 'Report not Generated' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " alv_grid_display
