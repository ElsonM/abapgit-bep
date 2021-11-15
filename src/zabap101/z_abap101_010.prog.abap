*&---------------------------------------------------------------------*
*& Report Z_ABAP101_009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_010.

* 2nd Option - Reusing TYPES keyword

TYPES: BEGIN OF some_components_sflight_2,
         carrid    TYPE sflight-carrid,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         planetype TYPE sflight-planetype,
         seatsmax  TYPE sflight-seatsmax,
         seatsocc  TYPE sflight-seatsocc,
       END OF some_components_sflight_2.

TYPES: BEGIN OF flight_booking,
         carrid   TYPE sbook-carrid,
         connid   TYPE sbook-connid,
         fldate   TYPE sbook-fldate,
         bookid   TYPE sbook-bookid,
         customid TYPE sbook-customid,
       END OF flight_booking.

TYPES BEGIN OF sflight_sbook.
INCLUDE TYPE: some_components_sflight_2,
              flight_booking AS book RENAMING WITH SUFFIX _book.
TYPES END OF sflight_sbook.

START-OF-SELECTION. " F8 To Execute
  DATA one_record TYPE sflight_sbook.
  BREAK-POINT. " See one_record using the debugger
