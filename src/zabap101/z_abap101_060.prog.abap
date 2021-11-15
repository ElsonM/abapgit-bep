*&---------------------------------------------------------------------*
*& Report Z_ABAP101_060
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_060.

TYPES: BEGIN OF ty_line,
         id    TYPE c LENGTH 10,
         name  TYPE string,
         value TYPE i,
       END OF ty_line.

DATA it_standard TYPE STANDARD TABLE OF ty_line.
DATA it_sorted   TYPE SORTED TABLE OF   ty_line  WITH UNIQUE KEY id.
DATA it_hashed   TYPE HASHED TABLE OF   ty_line  WITH UNIQUE KEY id.

START-OF-SELECTION.

  DATA wa TYPE ty_line.

  wa-id = '3'.
  wa-name = 'John'.
  wa-value = 50.
  APPEND wa TO it_standard.
  INSERT wa INTO TABLE it_sorted.
  INSERT wa INTO TABLE it_hashed.

  wa-id = '2'.
  wa-name = 'Mary'.
  wa-value = 60.
  APPEND wa TO it_standard.
  INSERT wa INTO TABLE it_sorted.
  INSERT wa INTO TABLE it_hashed.

  wa-id = '1'.
  wa-name = 'Max'.
  wa-value = 30.
  APPEND wa TO it_standard.
  INSERT wa INTO TABLE it_sorted.
  INSERT wa INTO TABLE it_hashed.

  BREAK-POINT.
