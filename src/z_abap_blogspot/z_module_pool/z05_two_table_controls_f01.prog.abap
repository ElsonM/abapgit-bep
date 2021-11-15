*&---------------------------------------------------------------------*
*&  Include           Z05_TWO_TABLE_CONTROLS_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  get_airline
*&---------------------------------------------------------------------*
*       Get data of Airline
*----------------------------------------------------------------------*
FORM get_airline.

  IF s_carrid[] IS NOT INITIAL.

    "It will refresh previous data when program moves with BACK
    REFRESH: lt_scarr.

    SELECT carrid carrname currcode
      FROM scarr INTO TABLE lt_scarr
      WHERE carrid IN s_carrid.

    IF sy-subrc = 0.
      REFRESH it_scarr.

      "Preparing the output table for screen fields
      LOOP AT lt_scarr INTO lw_scarr.
        wa_scarr-carrid   = lw_scarr-carrid.
        wa_scarr-carrname = lw_scarr-carrname.
        wa_scarr-currcode = lw_scarr-currcode.
        APPEND wa_scarr TO it_scarr.
        CLEAR: wa_scarr, lw_scarr.
      ENDLOOP.

      IF it_scarr IS NOT INITIAL.
        SORT it_scarr.

        "Storing the data to a temp table for reusing
        it_temp_scarr = it_scarr.

        "Refreshing the table control to display new records
        REFRESH CONTROL 'TAB_CTRL_SCARR' FROM SCREEN 9002.

        "Calling the next screen
        CALL SCREEN 9002.
      ENDIF.

    ELSE.
      MESSAGE 'Airline code doesn''t exist' TYPE 'S'.
      LEAVE LIST-PROCESSING.
    ENDIF.

  ELSE.
    MESSAGE 'Enter a valid Airline Code' TYPE 'I'.
  ENDIF.

ENDFORM.                    " get_airline

*&---------------------------------------------------------------------*
*&      Form  capture_carrid
*&---------------------------------------------------------------------*
*       Capturing the selected rows into a table
*----------------------------------------------------------------------*
FORM capture_carrid .

  IF it_scarr IS NOT INITIAL.

    LOOP AT it_scarr INTO wa_scarr WHERE mark = 'X'.
      v_carrid = wa_scarr-carrid.
      CLEAR: wa_scarr.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " capture_carrid

*&---------------------------------------------------------------------*
*&      Form  get_flight_number
*&---------------------------------------------------------------------*
*       Get data from Flight schedule table
*----------------------------------------------------------------------*
FORM get_flight_number.

  IF v_carrid IS NOT INITIAL.

    "It will refresh previous data when program moves with BACK
    REFRESH: lt_spfli, it_spfli.

    SELECT carrid connid countryfr cityfrom airpfrom cityto airpto
      FROM spfli INTO TABLE lt_spfli
      WHERE carrid = v_carrid.

    "Preparing the output table for screen fields
    IF sy-subrc = 0.
      CLEAR v_carrid. "Clearing v_carrid for UAT - BUGs

      LOOP AT lt_spfli INTO lw_spfli.
        wa_spfli-carrid    = lw_spfli-carrid.
        wa_spfli-connid    = lw_spfli-connid.
        wa_spfli-countryfr = lw_spfli-countryfr.
        wa_spfli-cityfrom  = lw_spfli-cityfrom.
        wa_spfli-airpfrom  = lw_spfli-airpfrom.
        wa_spfli-cityto    = lw_spfli-cityto.
        wa_spfli-airpto    = lw_spfli-airpto.
        APPEND wa_spfli TO it_spfli.
        CLEAR: wa_spfli, lw_spfli.
      ENDLOOP.

      IF it_spfli IS NOT INITIAL.
        SORT it_spfli.

        "Refreshing the table control to display new records
        REFRESH CONTROL 'TAB_CTRL_SPFLI' FROM SCREEN 9003.

        "Calling the next screen
        CALL SCREEN 9003.
      ENDIF.

    ELSE.
      CLEAR ok_code2. "Clearing OK_CODE2 for UAT - BUGs
      MESSAGE 'Flight doesn''t exist' TYPE 'I'.
    ENDIF.

  ELSE.
    CLEAR ok_code2. "Clearing OK_CODE2 for UAT - BUGs
    MESSAGE 'Select an Airline' TYPE 'I'.
  ENDIF.

ENDFORM.                    " get_flight_number
