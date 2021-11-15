*&---------------------------------------------------------------------*
*& Report Z_ABAP101_054
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_054.

DATA gv_flag TYPE c.
*&---------------------------------------------------------------------*
*& Form get_larger
*&---------------------------------------------------------------------*
*  Compares 2 numbers and returns a flag (true) if they are equal
*----------------------------------------------------------------------*
* --> NUMBER_A Number A
* --> NUMBER_B Number B
* --> FLAG Equal numbers indicator
*----------------------------------------------------------------------*
FORM set_flag_if_equal
    USING
      number_a TYPE f
      number_b TYPE f
    CHANGING
      flag TYPE c.
  IF number_a = number_b.
    flag = abap_true.
    WRITE flag.
    NEW-LINE.
  ELSE.
    flag = abap_false.
    WRITE 'Not equal'.
    NEW-LINE.
  ENDIF.
ENDFORM. "get_larger

START-OF-SELECTION.
  PERFORM set_flag_if_equal USING 1 1         CHANGING gv_flag.
  PERFORM set_flag_if_equal USING 4 3         CHANGING gv_flag.
  PERFORM set_flag_if_equal USING 5 5         CHANGING gv_flag.
  PERFORM set_flag_if_equal USING '6.2' '7.1' CHANGING gv_flag.
