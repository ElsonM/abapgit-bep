*&---------------------------------------------------------------------*
*& Report Z_ABAP101_076
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_076.

DATA v_number TYPE i.
SELECT-OPTIONS s_number FOR v_number NO-EXTENSION.

AT SELECTION-SCREEN ON s_number.

  DATA lv_range_size TYPE i.
  lv_range_size = s_number-high - s_number-low + 1.

  IF lv_range_size > 100.
    MESSAGE 'Range is too big' TYPE 'E'.
  ENDIF.
