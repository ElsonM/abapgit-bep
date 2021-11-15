*&---------------------------------------------------------------------*
*& Report Z_ABAP101_045
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_045.

CONSTANTS: c_abap      TYPE c LENGTH 7 VALUE 'ABAP999',
           c_separator TYPE c          VALUE '-'.

DATA v_whole_text TYPE string.

START-OF-SELECTION.
  CONCATENATE c_abap(4) '101' sy-datum+4(2) INTO v_whole_text
    SEPARATED BY c_separator.
  WRITE v_whole_text.
