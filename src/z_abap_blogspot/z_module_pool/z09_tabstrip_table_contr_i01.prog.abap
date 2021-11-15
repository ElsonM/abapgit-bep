*&---------------------------------------------------------------------*
*&  Include           Z09_TABSTRIP_TABLE_CONTR_I01
*&---------------------------------------------------------------------*

MODULE user_command_9001 INPUT.

  CASE ok_code.
    WHEN 'TAB1'. "TAB1 tab title works like a push button
      ts_air-activetab = 'TAB1'.
    WHEN 'TAB2'. "TAB2 tab title works like a push button
      ts_air-activetab = 'TAB2'.
    WHEN 'TAB3'. "TAB3 tab title works like a push button
      ts_air-activetab = 'TAB3'.

    WHEN 'DISP'. "Display push button
      PERFORM get_airline.
      PERFORM get_flight_schedule.
      PERFORM get_flight.
    WHEN 'CLR'.  "Clear push button
      PERFORM clear_program.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'. "GUI buttons
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " user_command_9001  INPUT

MODULE modify_tc_spfli INPUT.

  READ TABLE it_spfli INTO wa_spfli
  INDEX tc_spfli-current_line.

  IF sy-subrc = 0.
    MODIFY it_spfli FROM wa_spfli INDEX tc_spfli-current_line.
  ENDIF.

ENDMODULE.                 " modify_tc_spfli  INPUT

MODULE modify_tc_sflight INPUT.

  READ TABLE it_sflight INTO wa_sflight
  INDEX tc_sflight-current_line.

  IF sy-subrc = 0.
    MODIFY it_sflight FROM wa_sflight INDEX tc_sflight-current_line.
  ENDIF.

ENDMODULE.                 " modify_tc_sflight  INPUT
