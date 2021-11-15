*&---------------------------------------------------------------------*
*& Include Z01_PUSH_CHECK_BUTTONS_TOP
*&---------------------------------------------------------------------*
PROGRAM z01_push_check_buttons.

TABLES kna1.

TYPES: BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         land1 TYPE kna1-land1,
         name1 TYPE kna1-name1,
         ort01 TYPE kna1-ort01,
       END OF ty_kna1.

DATA: it_kna1  TYPE STANDARD TABLE OF ty_kna1,
      wa_kna1  TYPE                   ty_kna1,

      ok_code1 TYPE sy-ucomm,
      ok_code2 TYPE sy-ucomm,

      name     TYPE c,
      country  TYPE c,
      city     TYPE c.
