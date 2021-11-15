*&---------------------------------------------------------------------*
*& Report Z_ABAP101_075
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_075.

DATA v_number TYPE i.
SELECT-OPTIONS s_number FOR v_number NO INTERVALS.

AT SELECTION-SCREEN ON s_number.

  LOOP AT s_number.
    IF s_number-low = '0'.
      MESSAGE 'Number zero is not allowed' TYPE 'E'.
    ENDIF.
  ENDLOOP.
