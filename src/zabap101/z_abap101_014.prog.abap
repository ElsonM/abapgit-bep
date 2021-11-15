*&---------------------------------------------------------------------*
*& Report Z_ABAP101_014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_014.

TYPES: BEGIN OF flight_booking,
         carrid   TYPE sbook-carrid,
         connid   TYPE sbook-connid,
         fldate   TYPE sbook-fldate,
         bookid   TYPE sbook-bookid,
         customid TYPE sbook-customid,
       END OF flight_booking.

TYPES table_type_booking TYPE TABLE OF flight_booking
  WITH KEY carrid connid fldate customid.
