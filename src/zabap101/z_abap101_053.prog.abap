*&---------------------------------------------------------------------*
*& Report Z_ABAP101_053
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_053.

DATA gv_largest TYPE f.
*&---------------------------------------------------------------------*
*& Form get_larger
*&---------------------------------------------------------------------*
*  Compares 2 numbers and returns the largest. If equal returns itself
*----------------------------------------------------------------------*
* --> NUMBER_A Number A
* --> NUMBER_B Number B
* --> LARGEST_NUMBER Largest Number
*----------------------------------------------------------------------*
FORM get_larger
    USING
      number_a TYPE f
      number_b TYPE f
    CHANGING
      largest_number TYPE f.
  IF number_a >= number_b.
    largest_number = number_a.
  ELSE.
    largest_number = number_b.
  ENDIF.
ENDFORM. "get_larger

START-OF-SELECTION.

  PERFORM get_larger USING 1 2 CHANGING gv_largest.
  WRITE gv_largest EXPONENT 0.
  NEW-LINE.

  PERFORM get_larger USING 4 3 CHANGING gv_largest.
  WRITE gv_largest EXPONENT 0.
  NEW-LINE.

  PERFORM get_larger USING 5 5 CHANGING gv_largest.
  WRITE gv_largest EXPONENT 0.
  NEW-LINE.

  PERFORM get_larger USING '6.2' '7.1' CHANGING gv_largest.
  WRITE gv_largest EXPONENT 0.
  NEW-LINE.
