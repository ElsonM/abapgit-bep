*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr15.

TABLES: spfli.

*--------------------------------------------------------------*
*Data Types
*--------------------------------------------------------------*
TYPES: BEGIN OF ty_spfli,
         check   TYPE c.
         INCLUDE TYPE spfli.
TYPES: END OF ty_spfli.

*--------------------------------------------------------------*
*Data Declaration
*--------------------------------------------------------------*
DATA: gt_spfli     TYPE TABLE OF ty_spfli.
DATA: gwa_spfli    TYPE ty_spfli.
DATA: gwa_selfield TYPE slis_selfield.

*--------------------------------------------------------------*
*Selection-Screen
*--------------------------------------------------------------*
SELECT-OPTIONS: s_carrid FOR spfli-carrid.

*--------------------------------------------------------------*
*Selection-Screen on Value-Request
*--------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_carrid-low.

  CLEAR: gwa_selfield.

* Get data
  SELECT * FROM spfli INTO CORRESPONDING FIELDS OF
    TABLE gt_spfli.

* Remove duplicates
  DELETE ADJACENT DUPLICATES FROM gt_spfli COMPARING carrid.

  CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
    EXPORTING
      i_checkbox_fieldname = 'CHECK'
      i_tabname            = 'GT_SPFLI'   "Internal table name
      i_structure_name     = 'SPFLI'
    IMPORTING
      es_selfield          = gwa_selfield
    TABLES
      t_outtab             = gt_spfli     "Internal table which contains entries
    EXCEPTIONS
      program_error        = 1
      OTHERS               = 2.

  REFRESH s_carrid.

  LOOP AT gt_spfli INTO gwa_spfli WHERE check = 'X'.
    s_carrid-sign   = 'I'.
    s_carrid-option = 'EQ'.
    s_carrid-low    = gwa_spfli-carrid.
    APPEND s_carrid.
  ENDLOOP.

  READ TABLE s_carrid INDEX 1.
