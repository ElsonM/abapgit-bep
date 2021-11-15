*&---------------------------------------------------------------------*
*& Include Z03_TABLE_CONTROL_I01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  CLEAR ok_code1.
  ok_code1 = sy-ucomm.
  CLEAR sy-ucomm.

  CASE ok_code1.

    WHEN 'DISP'.     "Display button
      PERFORM get_po.

    WHEN 'CLR'.      "Clear button
      CLEAR ekko-ebeln.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.
  CASE ok_code2.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.

      "Due to multiple clicks user command needs to be updated
      CLEAR ok_code2.

      LEAVE LIST-PROCESSING.
      LEAVE TO SCREEN 9001.

  ENDCASE.
ENDMODULE.                 " user_command_9002  INPUT

*&---------------------------------------------------------------------*
*& Module MODIFY_TABLE_CONTROL INPUT
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
MODULE modify_table_control INPUT.

  "Reading the table with current line
  READ TABLE it_ekpo INTO wa_ekpo INDEX tab_ctrl-current_line.

  IF sy-subrc = 0.

    "Modifying the current line in table control
    MODIFY it_ekpo FROM wa_ekpo INDEX tab_ctrl-current_line.

  ENDIF.

ENDMODULE.                 " modify_table_control  INPUT
