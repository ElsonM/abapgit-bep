*&---------------------------------------------------------------------*
*& Report Z_ABAP101_055
*&---------------------------------------------------------------------*
REPORT z_abap101_055.

DATA gv_result TYPE f.

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
ENDFORM. " get_larger

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
      flag     TYPE c.

  IF number_a = number_b.
    flag = abap_true.
  ELSE.
    flag = abap_false.
  ENDIF.
ENDFORM. " set_flag_if_equal

*&---------------------------------------------------------------------*
*& Form division_or_power2
*&---------------------------------------------------------------------*
*  Takes two numbers and writes the result of the operation
*  [higher_number / lower_number] if the numbers are different.
*  If they are equal, write the result of the operation [number ^ 2].
*----------------------------------------------------------------------*
* --> NUMBER_A text
* --> NUMBER_B text
* --> RESULT text
*----------------------------------------------------------------------*
FORM division_or_power2
    USING
      number_a TYPE f
      number_b TYPE f
    CHANGING
      result TYPE f.

  DATA lv_number_equal TYPE c.

  PERFORM set_flag_if_equal
    USING
      number_a
      number_b
    CHANGING
      lv_number_equal.

  IF lv_number_equal = abap_true.
    result = number_a ** 2.
  ELSE.
    DATA lv_larger_number TYPE f.

    PERFORM get_larger
      USING number_a number_b
      CHANGING lv_larger_number.

    IF lv_larger_number = number_a.
      result = number_a / number_b.
    ELSE.
      result = number_b / number_a.
    ENDIF.
  ENDIF.

  WRITE result EXPONENT 0.
  NEW-LINE.
ENDFORM.

START-OF-SELECTION.
  PERFORM division_or_power2
    USING 1 1
    CHANGING gv_result.

  PERFORM division_or_power2
    USING 3 3
    CHANGING gv_result.

  PERFORM division_or_power2
    USING 6 2
    CHANGING gv_result.

  PERFORM division_or_power2
    USING 2 6
    CHANGING gv_result.

  PERFORM division_or_power2
    USING 10 2
    CHANGING gv_result.

  PERFORM division_or_power2
    USING 2 10
    CHANGING gv_result.
