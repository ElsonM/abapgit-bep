*&---------------------------------------------------------------------*
*& Report Z_ELSON_T10_LOOPS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t10_loops.

*Conditional Loops

DATA: length     TYPE i VALUE 0,
      strl       TYPE i VALUE 0,
      string(30) TYPE c VALUE 'Test String'.

strl = strlen( string ).

WHILE string NE space.
  WRITE string(1).
  length = sy-index.
  SHIFT string.
ENDWHILE.

WRITE: / 'STRLEN:', strl.
WRITE: / 'Length of string:', length.
