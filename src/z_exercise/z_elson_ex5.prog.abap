*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT z_elson_ex5.

INCLUDE z_elson_ex5_top.
INCLUDE z_elson_ex5_frm.

START-OF-SELECTION.

  PERFORM get_data.

  IF c_alv = 'X'.
    PERFORM create_alv.
  ELSE.
    MESSAGE TEXT-e02 TYPE 'I'.
  ENDIF.
