*&---------------------------------------------------------------------*
*& Report Z_ABAP101_013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_013.

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

DATA table_type_short_sflight TYPE TABLE OF some_components_sflight_2
      WITH KEY carrid connid fldate.

table_type_short_sflight = VALUE #( ( ) ).

BREAK-POINT.
