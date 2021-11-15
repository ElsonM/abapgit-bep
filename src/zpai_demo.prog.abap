*&---------------------------------------------------------------------*
*&  Include           ZPAI_DEMO
*&---------------------------------------------------------------------*

MODULE user_command_100 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  IF save_ok = 'CARRIER' AND NOT p_connid IS INITIAL.
    LEAVE TO SCREEN 200.
  ELSE.
    SET SCREEN 100.
  ENDIF.
ENDMODULE.


MODULE cancel INPUT.
  LEAVE PROGRAM.
ENDMODULE.


MODULE user_command_200 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
  IF save_ok = 'SELECTED'.
    MESSAGE i888(sabapdemos) WITH TEXT-001 "demof4help-carrier2
                                          p_connid.
*    CLEAR demof4help.
  ENDIF.
ENDMODULE.
