*&---------------------------------------------------------------------*
*& Report Z_ABAP101_100
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_100.

PARAMETERS p_report TYPE char20 DEFAULT 'Z_ABAP101_'.

START-OF-SELECTION.

  SUBMIT (p_report) VIA SELECTION-SCREEN AND RETURN.
