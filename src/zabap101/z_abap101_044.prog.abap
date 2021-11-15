*&---------------------------------------------------------------------*
*& Report Z_ABAP101_044
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_ABAP101_044.

CONSTANTS c_abap TYPE c LENGTH 4 VALUE 'ABAP'.
DATA v_whole_text TYPE string.

START-OF-SELECTION.

  CONCATENATE c_abap '101' INTO v_whole_text.
  WRITE v_whole_text.
