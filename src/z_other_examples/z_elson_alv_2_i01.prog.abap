*&---------------------------------------------------------------------*
*&  Include           Z_ELSON_ALV_2_I01
*&---------------------------------------------------------------------*

* PAI module

MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'RETURN'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
