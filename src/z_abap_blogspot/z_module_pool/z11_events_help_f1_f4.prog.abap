*&---------------------------------------------------------------------*
*& Module Pool       Z11_EVENTS_HELP_F1_F4
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

INCLUDE z11_events_help_f1_f4_top.  "Global Data
INCLUDE z11_events_help_f1_f4_o01.  "PBO Modules
INCLUDE z11_events_help_f1_f4_i01.  "PAI Modules
INCLUDE z11_events_help_f1_f4_f01.  "FORM Routines

MODULE value_for_customer INPUT.

  "The system will show only customer no. & name after pressing F4
  SELECT kunnr name1 FROM kna1 INTO TABLE it_kna1.

  "The table needs to be passed through this function module
  "for table value request
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'INP1'
      value_org       = 'S'
    TABLES
      value_tab       = it_kna1
      return_tab      = it_kna1_ret
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    LOOP AT it_kna1_ret INTO wa_kna1_ret.
      "The selected field needs to be passed to the screen field
      inp1 = wa_kna1_ret-fieldval.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " value_for_customer  INPUT

MODULE capture_date INPUT.

  "This function module will export the calendar and import date
  CALL FUNCTION 'F4_DATE'
    EXPORTING
      date_for_first_month         = inp2
    IMPORTING
      select_date                  = inp2
    EXCEPTIONS
      calendar_buffer_not_loadable = 1
      date_after_range             = 2
      date_before_range            = 3
      date_invalid                 = 4
      factory_calendar_not_found   = 5
      holiday_calendar_not_found   = 6
      parameter_conflict           = 7
      OTHERS                       = 8.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.                 " capture_date  INPUT

MODULE capture_time INPUT.

  CALL FUNCTION 'F4_CLOCK'
    EXPORTING
      start_time    = inp3
    IMPORTING
      selected_time = inp3.

ENDMODULE.                 " capture_time  INPUT

MODULE help_customer INPUT.

  CALL FUNCTION 'DSYS_SHOW_FOR_F1HELP'
    EXPORTING
      dokclass = 'TX'
      doklangu = sy-langu
      dokname  = 'ZTEST'.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMODULE.                 " help_customer  INPUT
