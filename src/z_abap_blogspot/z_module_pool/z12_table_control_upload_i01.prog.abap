*&---------------------------------------------------------------------*
*&  Include           Z12_TABLE_CONTROL_UPLOAD_I01
*&---------------------------------------------------------------------*

MODULE user_command_9000 INPUT.

  CASE ok_code_9000.

    WHEN 'BACK'.
      PERFORM back_9000.
    WHEN 'UPL'.
      PERFORM upload_data.

  ENDCASE.

ENDMODULE.

MODULE tabc_9000_pai INPUT.

  READ TABLE it_lfa1 INTO wa_lfa1 INDEX tabc_9000-current_line.
  IF sy-subrc = 0.
    MODIFY it_lfa1 FROM wa_lfa1 INDEX tabc_9000-current_line.
  ENDIF.

ENDMODULE.
