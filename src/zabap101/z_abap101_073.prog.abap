*&---------------------------------------------------------------------*
*& Report Z_ABAP101_073
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_073.

DATA v_number TYPE i.

SELECT-OPTIONS s_number FOR v_number NO-EXTENSION.

START-OF-SELECTION.

  DATA v_difference            TYPE i.
  DATA v_multiplication_result TYPE i.

  v_difference = s_number-high - s_number-low + 1.

  DO v_difference TIMES.
    v_multiplication_result = ( s_number-low + sy-index - 1 ) * 3.
    WRITE v_multiplication_result.
    NEW-LINE.
  ENDDO.
