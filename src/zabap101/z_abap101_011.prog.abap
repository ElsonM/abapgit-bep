*&---------------------------------------------------------------------*
*& Report Z_ABAP101_011
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_011.

TYPES: table_type_with_number TYPE TABLE OF i.

DATA: it_odd_numbers  TYPE table_type_with_number,
      it_even_numbers TYPE table_type_with_number.

START-OF-SELECTION.

  it_odd_numbers  = VALUE #( ( 1 ) ( 3 ) ( 5 ) ( 7 ) (  9 ) ).
  it_even_numbers = VALUE #( ( 2 ) ( 4 ) ( 6 ) ( 8 ) ( 10 ) ).

  LOOP AT it_odd_numbers INTO DATA(wa_number).
    WRITE / wa_number.
  ENDLOOP.

  ULINE.

  LOOP AT it_even_numbers INTO wa_number.
    WRITE / wa_number.
  ENDLOOP.
