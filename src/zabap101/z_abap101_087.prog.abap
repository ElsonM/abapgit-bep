*&---------------------------------------------------------------------*
*& Report Z_ABAP101_087
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_087.

SELECTION-SCREEN PUSHBUTTON 10(8) TEXT-001 USER-COMMAND press. " TEXT-001 = 'Press me'

AT SELECTION-SCREEN.
  IF sy-ucomm = 'PRESS'.
    MESSAGE 'Button was pressed' TYPE 'I'.
  ENDIF.
