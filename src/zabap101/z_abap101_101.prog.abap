*&---------------------------------------------------------------------*
*& Report Z_ABAP101_101
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_101.

DATA v_report TYPE char20.
SELECT-OPTIONS s_report FOR v_report NO INTERVALS.

START-OF-SELECTION.
  LOOP AT s_report.
    SUBMIT (s_report-low) VIA SELECTION-SCREEN AND RETURN.
  ENDLOOP.
