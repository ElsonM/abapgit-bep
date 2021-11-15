*&---------------------------------------------------------------------*
*& Include Z01_PUSH_CHECK_BUTTONS_I01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module USER_COMMAND_9001 INPUT
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  CLEAR ok_code1.
  ok_code1 = sy-ucomm.
  CLEAR sy-ucomm.

  CASE ok_code1.
    WHEN 'BACK1' OR 'EXIT1' OR 'CANCEL1'.
      PERFORM leave1.
    WHEN 'DISP'.
      PERFORM display.
    WHEN 'CLEAR'.
      PERFORM clear.
  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*& Module USER_COMMAND_9002 INPUT
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.

  CLEAR ok_code2.
  ok_code2 = sy-ucomm.
  CLEAR sy-ucomm.

  CASE ok_code2.
    WHEN 'BACK2' OR 'EXIT2' OR 'CANCEL2'.
      PERFORM leave2.
  ENDCASE.

ENDMODULE.
