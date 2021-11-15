*&---------------------------------------------------------------------*
*&  Include           Z07_TABLE_CONTROL_DISABLE_I01
*&---------------------------------------------------------------------*

MODULE modify_table_control INPUT.

  "Reading output table with current line to modify
  "when user scrolls down the table control
  READ TABLE it_vbap INTO wa_vbap INDEX tab_ctrl-current_line.

  IF sy-subrc = 0.
    MODIFY it_vbap FROM wa_vbap INDEX tab_ctrl-current_line.
  ENDIF.

ENDMODULE.                 " modify_table_control  INPUT

MODULE user_command_9001 INPUT.

  CASE ok_code.
    WHEN 'DISP'. "Display Button
      PERFORM get_sales_data.
    WHEN 'REF'.  "Refresh Button
      PERFORM refresh_sales_data.
    WHEN 'DISA'. "Disable Button
      disable = 'X'.
    WHEN 'ENA'.  "Enable Button
      CLEAR disable.
    WHEN 'BACK'. "Back Button
      LEAVE LIST-PROCESSING.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " user_command_9001  INPUT
