*&---------------------------------------------------------------------*
*& Report Z02_CAPTURE_INPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_capture_input.

*&---------------------------------------------------------------------*
*& Data Declaration
*&---------------------------------------------------------------------*
TABLES mara.

DATA: gt_params  TYPE TABLE OF rsparams,
      gwa_params TYPE          rsparams.

*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECT-OPTIONS s_matnr FOR mara-matnr.

PARAMETERS: p_mtart TYPE mara-mtart,
            p_matkl TYPE mara-matkl.

*&---------------------------------------------------------------------*
*& Start of Selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
    EXPORTING
      curr_report     = sy-repid
    TABLES
      selection_table = gt_params.

  SORT gt_params BY kind.

  WRITE:/ 'Parameters' COLOR 5.
  WRITE:/ 'Name' COLOR 1, 20 'Value' COLOR 1.

  LOOP AT gt_params INTO gwa_params WHERE kind = 'P'.
    WRITE:/ gwa_params-selname, 20 gwa_params-low.
  ENDLOOP.

  SKIP.

  WRITE:/ 'Select-Options' COLOR 5.
  WRITE:/    'Name' COLOR 1, 20 'Sign' COLOR 1, 25 'Option' COLOR 1,
          32 'Low'  COLOR 1, 52 'High' COLOR 1.

  LOOP AT gt_params INTO gwa_params WHERE kind = 'S'.
    WRITE:/ gwa_params-selname, 20 gwa_params-sign,
         25 gwa_params-option,  32 gwa_params-low,
         52 gwa_params-high.
  ENDLOOP.
