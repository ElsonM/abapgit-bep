*&---------------------------------------------------------------------*
*& Report Z_ABAP101_025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_025.

DATA: BEGIN OF some_components_of_one_flight,
        carrid    TYPE sflight-carrid,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        price     TYPE sflight-price,
        currency  TYPE sflight-currency,
        planetype TYPE sflight-planetype,
        seatsmax  TYPE sflight-seatsmax,
        seatsocc  TYPE sflight-seatsocc,
      END OF some_components_of_one_flight.
