*&---------------------------------------------------------------------*
*& Report Z_ABAP101_081
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_081.

PARAMETER p_first RADIOBUTTON GROUP grp1 USER-COMMAND action.
PARAMETER p_busin RADIOBUTTON GROUP grp1.

PARAMETER p_econo LIKE p_first RADIOBUTTON GROUP grp1.
PARAMETER p_input TYPE string.

AT SELECTION-SCREEN.
  IF sy-ucomm = 'ACTION'.
    CLEAR p_input.
  ENDIF.
