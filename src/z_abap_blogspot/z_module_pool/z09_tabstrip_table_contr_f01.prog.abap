*&---------------------------------------------------------------------*
*&  Include           Z09_TABSTRIP_TABLE_CONTR_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  get_airline
*&---------------------------------------------------------------------*
*       Get data from Airline
*----------------------------------------------------------------------*
FORM get_airline.

  IF scarr-carrid IS NOT INITIAL.
    SELECT SINGLE carrid carrname currcode
      FROM scarr INTO wa_scarr
      WHERE carrid = scarr-carrid.

    IF sy-subrc = 0.

      "To avoid the selection screen field and display field
      "we are using different name for carrid
      v_carrid       = wa_scarr-carrid.
      scarr-carrname = wa_scarr-carrname.
      scarr-currcode = wa_scarr-currcode.
      CLEAR wa_scarr.
    ENDIF.
  ELSE.
    MESSAGE 'Please enter a valid Airline code' TYPE 'I'.
  ENDIF.

ENDFORM.                    " get_airline

*&---------------------------------------------------------------------*
*&      Form  get_flight_schedule
*&---------------------------------------------------------------------*
*       Get data from Flight schedule table
*----------------------------------------------------------------------*
FORM get_flight_schedule.

  IF scarr-carrid IS NOT INITIAL.
    SELECT carrid connid cityfrom airpfrom
           cityto airpto deptime arrtime distance
      FROM spfli INTO TABLE it_spfli
      WHERE carrid = scarr-carrid.
  ENDIF.

ENDFORM.                    " get_flight_schedule

*&---------------------------------------------------------------------*
*&      Form  get_flight
*&---------------------------------------------------------------------*
*       Get data from Flight table
*----------------------------------------------------------------------*
FORM get_flight.

  IF scarr-carrid IS NOT INITIAL.
    SELECT carrid connid fldate price
           currency seatsmax seatsocc
      FROM sflight INTO TABLE it_sflight
      WHERE carrid = scarr-carrid.
  ENDIF.

ENDFORM.                    " get_flight

*&---------------------------------------------------------------------*
*&      Form  clear_program
*&---------------------------------------------------------------------*
*       Clearing & refreshing all screen fields and tables
*----------------------------------------------------------------------*
FORM clear_program.

  CLEAR: scarr, spfli, sflight, v_carrid,
         wa_scarr, wa_spfli, wa_sflight.
  REFRESH: it_spfli, it_sflight.

ENDFORM.                    " clear_program

*&---------------------------------------------------------------------*
*&      Form  current_line_spfli
*&---------------------------------------------------------------------*
*       Scrolling operation in flight schedule table control
*----------------------------------------------------------------------*
FORM current_line_spfli.

  "Describing the internal table to populate the sy-dbcnt
  DESCRIBE TABLE it_spfli LINES sy-dbcnt.

  "Field current line of table control needs to be populated
  "with sy-loopc - loop information in table control
  tc_spfli-current_line = sy-loopc.

  "Field lines is populated with the number of table lines
  "which has been processed yet
  tc_spfli-lines = sy-dbcnt.

ENDFORM.                    " current_line_spfli

FORM current_line_sflight.

  "Describing the internal table to populate the sy-dbcnt
  DESCRIBE TABLE it_sflight LINES sy-dbcnt.

  "Field current line of table control needs to be populated
  "with sy-loopc - loop information in table control
  tc_sflight-current_line = sy-loopc.

  "Field lines is populated with the number of table lines
  "which has been processed yet
  tc_sflight-lines = sy-dbcnt.

ENDFORM.                    " current_line_sflight
