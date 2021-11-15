*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_ex6.

INCLUDE z_elson_ex6_top.
INCLUDE z_elson_ex6_frm.

START-OF-SELECTION.

  PERFORM get_data.

  PERFORM open_form.
  PERFORM start_form.

  PERFORM write_form USING 'CLIENT'  'E_CLI'.
  PERFORM write_form USING 'ADDRESS' 'E_ADR'.
  PERFORM write_form USING 'SALES'   'E_SAL'.
  PERFORM write_form USING 'FOOTER'  'E_FTR'.

  PERFORM end_form.
  PERFORM close_form.
