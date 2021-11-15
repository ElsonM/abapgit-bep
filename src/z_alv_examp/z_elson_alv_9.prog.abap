*&---------------------------------------------------------------------*
*& Report  Z_ELSON_EX9
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_elson_ex9.

INCLUDE z_elson_alv_9_top.  "Global Data
INCLUDE z_elson_alv_9_frm.  "FORM Routines

START-OF-SELECTION.

  PERFORM data_retrieval.
  PERFORM build_fieldcatalog.
  PERFORM build_layout.
  PERFORM display_alv_report.
