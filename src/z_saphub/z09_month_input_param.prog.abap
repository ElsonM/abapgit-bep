*&---------------------------------------------------------------------*
*& Report Z09_MONTH_INPUT_PARAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z09_month_input_param.

DATA: gt_text  TYPE TABLE OF tline,
      gwa_text TYPE          tline.

*&---------------------------------------------------------------------*
*&      Selection Screen
*&---------------------------------------------------------------------*
PARAMETERS: p_month TYPE isellist-month.
PARAMETERS: p_chk AS CHECKBOX.

*&---------------------------------------------------------------------*
*&      At Selection Screen Event
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_month.
  CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
    EXPORTING
      actual_month               = sy-datum(6)
    IMPORTING
      selected_month             = p_month
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      month_not_found            = 3
      OTHERS                     = 4.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

AT SELECTION-SCREEN ON HELP-REQUEST FOR p_chk.
  gwa_text-tdformat = 'U1'.     "To display text in blue color
  gwa_text-tdline = 'F1 Help'.
  APPEND gwa_text TO gt_text.
  CLEAR gwa_text.

  gwa_text-tdline = 'ABAP Demo Checkbox'.
  APPEND gwa_text TO gt_text.
  CLEAR gwa_text.

  CALL FUNCTION 'COPO_POPUP_TO_DISPLAY_TEXTLIST'
    EXPORTING
      titel      = 'F1 Help'
    TABLES
      text_table = gt_text.

  REFRESH gt_text.

  START-OF-SELECTION.

    BREAK-POINT.
