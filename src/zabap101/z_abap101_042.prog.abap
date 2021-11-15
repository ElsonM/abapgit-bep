*&---------------------------------------------------------------------*
*& Report Z_ABAP101_042
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_042.

DATA v_number_a TYPE i.
DATA v_number_b LIKE v_number_a VALUE 2.
DATA v_result TYPE f.

START-OF-SELECTION.

  v_number_a = 5.

  v_result = v_number_a + v_number_b.
  WRITE: 'Adition:   ', v_result EXPONENT 0.

  NEW-LINE.

  v_result = v_number_a - v_number_b.
  WRITE: 'Subtraction:   ', v_result.

  NEW-LINE.

  v_result = v_number_a * v_number_b.
  WRITE: 'Multiplication:', v_result.

  NEW-LINE.

  v_result = v_number_a / v_number_b.
  WRITE: 'Division:      ', v_result.

  NEW-LINE.

  v_result = v_number_a ** v_number_b.
  WRITE: 'Power:         ', v_result.
