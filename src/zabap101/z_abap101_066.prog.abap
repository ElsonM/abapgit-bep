*&---------------------------------------------------------------------*
*& Report Z_ABAP101_066
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_066.

PARAMETERS: p_number TYPE i,
            p_length TYPE i.

START-OF-SELECTION.

  DATA vl_number_string TYPE string.
  DATA vl_number_length TYPE i.
  DATA vl_number_with_left_zeros TYPE string.
  vl_number_string = p_number.
  CONDENSE vl_number_string NO-GAPS.

  vl_number_length = strlen( vl_number_string ).

  IF vl_number_length >= p_length.
    WRITE: vl_number_string(p_length).
  ELSE.
    DATA vl_zeros TYPE i.
    DATA vl_left_zeros TYPE string.
    vl_zeros = p_length - vl_number_length.

    DO vl_zeros TIMES.
      CONCATENATE vl_left_zeros '0' INTO vl_left_zeros.
    ENDDO.
    CONCATENATE vl_left_zeros vl_number_string INTO vl_number_with_left_zeros.
    WRITE: vl_number_with_left_zeros.
  ENDIF.
