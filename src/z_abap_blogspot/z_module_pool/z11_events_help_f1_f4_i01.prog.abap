*&---------------------------------------------------------------------*
*&  Include           Z11_EVENTS_HELP_F1_F4_I01
*&---------------------------------------------------------------------*

MODULE user_command_9001 INPUT.

  CASE ok_code.
    WHEN 'CLR'.
      CLEAR: inp1, inp2, inp3.

    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " user_command_9001  INPUT
