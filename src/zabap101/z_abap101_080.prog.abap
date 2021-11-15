*&---------------------------------------------------------------------*
*& Report Z_ABAP101_080
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_080.

PARAMETER p_first AS CHECKBOX DEFAULT abap_true.
PARAMETER p_busin AS CHECKBOX.
PARAMETER p_econo LIKE p_first AS CHECKBOX.

INITIALIZATION.

  IF sy-datum+6(2) >= 1 AND sy-datum+6(2) <= 10.
    p_busin = 'X'.
    p_econo = p_busin.
  ENDIF.
