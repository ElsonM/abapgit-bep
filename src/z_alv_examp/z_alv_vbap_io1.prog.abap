*&---------------------------------------------------------------------*
*&  Include           Z_ALV_VBAP_IO1
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.

    WHEN 'EXIT' OR 'BACK' OR 'CNCL'.
      LEAVE PROGRAM.
    WHEN 'BTNLIST'.
      PERFORM u_filter_vbak.
    WHEN OTHERS.

  ENDCASE.

ENDMODULE.
