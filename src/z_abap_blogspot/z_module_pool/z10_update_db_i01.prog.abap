*&---------------------------------------------------------------------*
*&  Include           Z10_UPDATE_DB_I01
*&---------------------------------------------------------------------*

MODULE user_command_9001 INPUT.

  CASE ok_code1.
    WHEN 'DISP'.
      PERFORM get_customer.
    WHEN 'CRT'.
      PERFORM create_customer.
    WHEN 'CANC'.
      CLEAR: zcustomers_mod_p-id.
      LEAVE LIST-PROCESSING.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_9001  INPUT

MODULE user_command_9002 INPUT.

  CASE ok_code2.
    WHEN 'UPDT'.
      PERFORM update_customer.
    WHEN 'DEL'.
      PERFORM delete_customer.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 9001.
      LEAVE LIST-PROCESSING.
  ENDCASE.

ENDMODULE.                 " user_command_9002  INPUT
