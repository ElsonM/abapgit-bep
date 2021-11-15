*&---------------------------------------------------------------------*
*& Report Z07_SEARCH_HELP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_search_help.

TYPES: BEGIN OF ty_matnr,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_matnr.

*--------------------------------------------------------------*
*Data Declaration
*--------------------------------------------------------------*
DATA: gwa_matnr TYPE ty_matnr,
      gt_matnr  TYPE TABLE OF ty_matnr.

DATA: gt_return  TYPE TABLE OF ddshretval,
      gwa_return TYPE ddshretval.

*--------------------------------------------------------------*
*Selection-Screen
*--------------------------------------------------------------*
PARAMETERS: p_matnr TYPE mara-matnr.

*--------------------------------------------------------------*
*Selection-Screen on Value-Request
*--------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_matnr.

  REFRESH gt_matnr.

  gwa_matnr-matnr = 'AAA'.
  gwa_matnr-maktx = 'Dummy Material 1'.
  APPEND gwa_matnr TO gt_matnr.

  gwa_matnr-matnr = 'BBB'.
  gwa_matnr-maktx = 'Dummy Material 2'.
  APPEND gwa_matnr TO gt_matnr.

  gwa_matnr-matnr = 'CCC'.
  gwa_matnr-maktx = 'Dummy Material 3'.
  APPEND gwa_matnr TO gt_matnr.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'MATNR'
      value_org       = 'S'
    TABLES
      value_tab       = gt_matnr
      return_tab      = gt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  READ TABLE gt_return INTO gwa_return INDEX 1.

  IF sy-subrc = 0.
    p_matnr = gwa_return-fieldval.
  ENDIF.

START-OF-SELECTION.
  IF p_matnr IS INITIAL.
    WRITE: 'No material selected'.
  ELSE.
    WRITE:/ 'Material: ', p_matnr.
  ENDIF.
