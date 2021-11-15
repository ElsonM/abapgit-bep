*&---------------------------------------------------------------------*
*& Report Z_ABAP101_027
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_027.

TYPES: BEGIN OF ty_sbook,
         carrid      TYPE sbook-carrid,
         connid      TYPE sbook-connid,
         fldate      TYPE sbook-fldate,
         bookid      TYPE sbook-bookid,
         customer_id TYPE sbook-customid,
       END OF ty_sbook.

TYPES ty_itab_sbook TYPE TABLE OF ty_sbook
  WITH KEY carrid connid fldate bookid.

DATA itab_sbook TYPE ty_itab_sbook.
