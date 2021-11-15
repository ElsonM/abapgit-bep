*&---------------------------------------------------------------------*
*& Report ZABAP_740_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_740_1.

DATA:
  BEGIN OF struct1,
    col1 TYPE i VALUE 11,
    col2 TYPE i VALUE 12,
  END OF struct1.

DATA:
  BEGIN OF struct2,
    col2 TYPE i VALUE 22,
    col3 TYPE i VALUE 23,
  END OF struct2.

*struct2 = CORRESPONDING #( struct1 ).

*MOVE-CORRESPONDING struct1 TO struct2.

struct2 = VALUE #( BASE struct1  col3 = 33 ).

BREAK-POINT.
