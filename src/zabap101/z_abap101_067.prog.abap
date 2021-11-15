*&---------------------------------------------------------------------*
*& Report Z_ABAP101_067
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_067.

PARAMETERS p_base TYPE p LENGTH 5 OBLIGATORY.
PARAMETERS p_exp  TYPE i          OBLIGATORY.

START-OF-SELECTION.

  DATA v_result TYPE f.
  v_result = p_base ** p_exp.
  WRITE: v_result EXPONENT 0.
