*&---------------------------------------------------------------------*
*& Report Z_ELSON_T14_FLIGHT_SCHEDULE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t14_flight_schedule.

INCLUDE zinclude_header.

DATA: lt_flight TYPE TABLE OF zvw_flight_sch,
      wa_flight LIKE LINE OF  lt_flight,
      lt_names  TYPE TABLE OF scarr,
      wa_names  LIKE LINE OF  lt_names,
      lv_flag.

PARAMETERS p_carrid TYPE spfli-carrid OBLIGATORY.
PARAMETERS p_connid TYPE spfli-connid.

INITIALIZATION.
  p_carrid = 'AA'.

AT SELECTION-SCREEN.
  AUTHORITY-CHECK OBJECT 'ZAOCARRID'
           ID 'ZCARRID' FIELD p_carrid
           ID 'ACTVT'   FIELD '03'.

  IF sy-subrc EQ 0.
    lv_flag = 'X'.
  ENDIF.

START-OF-SELECTION.
  IF lv_flag EQ 'X'.
    SELECT *
    FROM zvw_flight_sch
    INTO CORRESPONDING FIELDS OF TABLE lt_flight
    WHERE carrid EQ p_carrid AND
          connid EQ p_connid.

    SELECT *
      FROM scarr
      INTO CORRESPONDING FIELDS OF TABLE lt_names
      FOR ALL ENTRIES IN lt_flight
      WHERE carrid = lt_flight-carrid.

    PERFORM print_flight CHANGING lt_flight lt_names.
    CLEAR lv_flag.
  ELSE.
    MESSAGE 'You are not authorized to view this airline information.' TYPE 'I'.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  PRINT_FLIGHT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_LT_FLIGHT  text
*      <--P_LT_NAMES  text
*----------------------------------------------------------------------*
FORM print_flight  CHANGING p_lt_flight TYPE ztty_flight
                            p_lt_names  TYPE ty_scarr.

  DATA wa_flight LIKE LINE OF p_lt_flight.
  DATA wa_names  LIKE LINE OF p_lt_names.

  LOOP AT p_lt_flight INTO wa_flight.

    READ TABLE p_lt_names INTO wa_names WITH KEY carrid = wa_flight-carrid.
    IF sy-subrc EQ 0.
      NEW-LINE.
      WRITE: wa_flight-carrid,
             wa_names-carrname,
             wa_flight-connid,
             wa_flight-cityfrom,
             wa_flight-cityto,
             wa_flight-airpfrom,
             wa_flight-airpto,
             wa_flight-fltime,
             wa_flight-arrtime,
             wa_flight-deptime,
             wa_flight-price,
             wa_flight-currency,
             wa_flight-seatsmax,
             wa_flight-seatsocc,
             wa_flight-seatsmax_b,
             wa_flight-seatsocc_b,
             wa_flight-seatsmax_f,
             wa_flight-seatsocc_f.
    ENDIF.

  ENDLOOP.

ENDFORM.
