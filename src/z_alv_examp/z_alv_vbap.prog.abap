*&---------------------------------------------------------------------*
*& Report Z_ALV_VBAP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_alv_vbap LINE-SIZE 160.

INCLUDE z_alv_vbap_top.
INCLUDE z_alv_vbap_f01.
INCLUDE z_alv_vbap_io1.
INCLUDE z_alv_vbap_o01.

START-OF-SELECTION.
  CALL SCREEN 100.
