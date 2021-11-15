*&---------------------------------------------------------------------*
*&  Include           Z05_TWO_TABLE_CONTROLS_I01
*&---------------------------------------------------------------------*

MODULE user_command_9001 INPUT.

  CASE ok_code1. "User command for 9001
    WHEN 'DISP'.
      PERFORM get_airline.
    WHEN 'CLR'.
      REFRESH s_carrid.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " user_command_9001  INPUT

MODULE reset_scarr INPUT.

  "Resetting the internal table to its previous data
  "It is needed to remove the modification with MARKs

  it_scarr = it_temp_scarr.

ENDMODULE.                 " reset_scarr  INPUT

MODULE modify_scarr INPUT.

  "When one row is selected the internal table is modified
  "with the MARK fields x coming from wa_scarr-mark
  IF wa_scarr-mark = 'X'.
    MODIFY it_scarr INDEX tab_ctrl_scarr-current_line FROM wa_scarr.
  ENDIF.

  "When the table control is scrolled
  READ TABLE it_scarr INTO wa_scarr
    INDEX tab_ctrl_scarr-current_line.

  IF sy-subrc = 0.
    MODIFY it_scarr INDEX tab_ctrl_scarr-current_line FROM wa_scarr.
  ENDIF.

ENDMODULE.                 " modify_scarr  INPUT

MODULE user_command_9002 INPUT.

  CASE ok_code2. "User command of screen 9002

    WHEN 'FLNM'.

      PERFORM capture_carrid.
      PERFORM get_flight_number.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.

      "Previous user command needs to be cleared for further operation
      CLEAR ok_code1.
      LEAVE LIST-PROCESSING.
      LEAVE TO SCREEN 9001.

  ENDCASE.

ENDMODULE.                 " user_command_9002  INPUT

MODULE modify_spfli INPUT.

  "When the table control is scrolled
  READ TABLE it_spfli INTO wa_spfli
    INDEX tab_ctrl_spfli-current_line.

  IF sy-subrc = 0.
    MODIFY it_spfli INDEX tab_ctrl_spfli-current_line FROM wa_spfli.
  ENDIF.

ENDMODULE.                 " modify_spfli  INPUT

MODULE user_command_9003 INPUT.

  CASE ok_code3.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      "Previous user command needs to be cleared for further operation
      CLEAR: ok_code1, ok_code2.
      LEAVE LIST-PROCESSING.
      LEAVE TO SCREEN 9002.
  ENDCASE.

ENDMODULE.                 " user_command_9003  INPUT
