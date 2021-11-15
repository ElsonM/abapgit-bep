*&---------------------------------------------------------------------*
*& Report Z_ABAP101_043
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_043.

PARAMETERS p_num_a TYPE i.
PARAMETERS p_num_b LIKE p_num_a DEFAULT 2.
DATA v_result TYPE f.

START-OF-SELECTION.

  v_result = p_num_a + p_num_b.
  WRITE: 'Addition:  ', v_result EXPONENT 0 .
  NEW-LINE.

  v_result = p_num_a - p_num_b.
  WRITE: 'Subtraction:   ', v_result.
  NEW-LINE.

  v_result = p_num_a * p_num_b.
  WRITE: 'Multiplication:', v_result.
  NEW-LINE.

  v_result = p_num_a / p_num_b.
  WRITE: 'Division:      ', v_result.
  NEW-LINE.

  v_result = p_num_a ** p_num_b.
  WRITE: 'Power:         ', v_result.
