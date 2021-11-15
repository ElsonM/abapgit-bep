*&---------------------------------------------------------------------*
*& Report Z05_PASSWORD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z05_password.

*----------------------------------------------------------------------*
*SELECTION-SCREEN
*----------------------------------------------------------------------*
PARAMETERS: p_name TYPE char10.
PARAMETERS: p_pass TYPE char10.

*----------------------------------------------------------------------*
*AT SELECTION-SCREEN OUTPUT
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'P_PASS'.
      screen-invisible = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

*----------------------------------------------------------------------*
*START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
  WRITE:/ 'Name', ':', p_name.
  WRITE:/ 'Pass', ':', p_pass.