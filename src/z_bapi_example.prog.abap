*&---------------------------------------------------------------------*
*& Report Z_BAPI_EXAMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_bapi_example.

CLASS flight DEFINITION.

  PUBLIC SECTION.
    METHODS: get_flight_details IMPORTING air_id  TYPE bapisflkey-airlineid
                                          conn_id TYPE bapisflkey-connectid
                                          fl_date TYPE bapisflkey-flightdate.

  PRIVATE SECTION.
    DATA: it_fldata TYPE bapisfldat.
    DATA: it_return TYPE STANDARD TABLE OF bapiret2.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Class (Implementation)
*&---------------------------------------------------------------------*
CLASS flight IMPLEMENTATION.

  METHOD: get_flight_details.

    CALL FUNCTION 'BAPI_FLIGHT_GETDETAIL'
      EXPORTING
        airlineid    = air_id
        connectionid = conn_id
        flightdate   = fl_date
      IMPORTING
        flight_data  = it_fldata
      TABLES
        return       = it_return.

    WRITE: / 'Company:', it_fldata-airline, 'From:', it_fldata-cityfrom,
             ' To:', it_fldata-cityto.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

* Selection screen
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_airid  TYPE bapisflkey-airlineid,
              p_connid TYPE bapisflkey-connectid,
              p_fldate TYPE bapisflkey-flightdate.
  SELECTION-SCREEN END OF BLOCK b1.

* Create object and execute Function Module.
  DATA: o_flight TYPE REF TO flight.
  CREATE OBJECT o_flight.

  o_flight->get_flight_details( air_id = p_airid conn_id = p_connid fl_date = p_fldate ).
