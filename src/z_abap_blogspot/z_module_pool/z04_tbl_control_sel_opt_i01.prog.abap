*&---------------------------------------------------------------------*
*&  Include           Z04_TBL_CONTROL_SEL_OPT_I01
*&---------------------------------------------------------------------*

MODULE user_command_9001 INPUT.

  CASE ok_code_sel.
    WHEN 'DISP'.                        "Display button
      PERFORM get_data_mara.
    WHEN 'CLR'.                         "Clear button
      CLEAR   s_matnr.
      REFRESH s_matnr[].
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.  "Leave program
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " user_command_9001  INPUT

MODULE user_command_9002 INPUT.

  CASE ok_code_mat.
    WHEN 'BACK'.
      CLEAR ok_code_mat.
      LEAVE LIST-PROCESSING.
      LEAVE TO SCREEN 9001.
  ENDCASE.

ENDMODULE.                 " user_command_9002  INPUT

MODULE modify_table_control INPUT.

  "Reading the table with current line of table control
  READ TABLE it_mara INTO wa_mara INDEX tab_ctrl-current_line.

  IF sy-subrc = 0.

    "Modifying the table with table control current line
    MODIFY it_mara FROM wa_mara INDEX tab_ctrl-current_line.

  ENDIF.

ENDMODULE.                 " modify_table_control  INPUT
