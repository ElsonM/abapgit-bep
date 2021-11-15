*&---------------------------------------------------------------------*
*& Report Z_ELSON_T19_FLIGHT_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t19_flight_screen.

TABLES: sdyn_conn.

DATA: wa_spfli      TYPE          spfli,
      lt_spfli_data TYPE TABLE OF spfli,
      container_r   TYPE REF TO   cl_gui_custom_container,
      grid_r        TYPE REF TO   cl_gui_alv_grid.

INCLUDE zfligh_screen_pai_0100.
INCLUDE zfligh_screen_pbo_0100.

START-OF-SELECTION.

  CALL FUNCTION 'ZFM_GET_FLIGHT_DATA'
    TABLES
      t_spfli_data   = lt_spfli_data
    EXCEPTIONS
      invalid_carrid = 1
      OTHERS         = 2.

  IF sy-subrc EQ 0.
    LOOP AT lt_spfli_data INTO wa_spfli.
      WRITE: / wa_spfli-carrid COLOR COL_KEY,
               wa_spfli-connid COLOR COL_KEY,
               wa_spfli-airpfrom,
               wa_spfli-cityfrom,
               wa_spfli-airpto,
               wa_spfli-cityto.
      HIDE:    wa_spfli-carrid,
               wa_spfli-connid.
    ENDLOOP.
  ENDIF.

  CALL SCREEN 200.

*  SELECT carrid connid airpfrom cityfrom airpto cityto
*    FROM spfli
*    INTO CORRESPONDING FIELDS OF wa_spfli.
*    WRITE: / wa_spfli-carrid COLOR COL_KEY,
*             wa_spfli-connid COLOR COL_KEY,
*             wa_spfli-airpfrom,
*             wa_spfli-cityfrom,
*             wa_spfli-airpto,
*             wa_spfli-cityto.
*    HIDE:    wa_spfli-carrid,
*             wa_spfli-connid.
*  ENDSELECT.

AT LINE-SELECTION.

  CALL FUNCTION 'ZFM_GET_FLIGHT_DATA'
    EXPORTING
      i_carrid       = wa_spfli-carrid
      i_connid       = wa_spfli-connid
    IMPORTING
      s_spfli_data   = wa_spfli
    EXCEPTIONS
      invalid_carrid = 1
      OTHERS         = 2.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING wa_spfli TO sdyn_conn.
    CALL SCREEN 100.
  ELSE.
    CASE sy-subrc.
      WHEN '1'.
        MESSAGE 'Invalid Airline' TYPE 'E' DISPLAY LIKE 'S'.
      WHEN OTHERS.
        MESSAGE 'Other Error'     TYPE 'E' DISPLAY LIKE 'S'.
    ENDCASE.
  ENDIF.

*  SELECT SINGLE *
*    FROM spfli
*    INTO wa_spfli
*    WHERE carrid EQ wa_spfli-carrid AND
*          connid EQ wa_spfli-connid.
*  MOVE-CORRESPONDING wa_spfli TO sdyn_conn.
*  CALL SCREEN 100.
