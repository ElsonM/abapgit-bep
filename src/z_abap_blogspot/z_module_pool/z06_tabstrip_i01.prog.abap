*&---------------------------------------------------------------------*
*&  Include           Z06_TABSTRIP_I01
*&---------------------------------------------------------------------*

MODULE user_command_9001 INPUT.

*------Capturing the function code for different button----------------*
  CASE ok_code.
    WHEN 'TAB1'.    "When user clicks on TAB1 button
      PERFORM tab1.
    WHEN 'TAB2'.    "When user clicks on TAB1 button
      PERFORM tab2.
    WHEN 'TAB3'.    "When user clicks on TAB1 button
      PERFORM tab3.

    WHEN 'DISP'.    "When user clicks on Display button
      PERFORM get_material.
      PERFORM get_material_description.
      PERFORM get_material_unit.
      PERFORM get_material_sales_data.
    WHEN 'CLR'.     "When user clicks on Clear button
      PERFORM clear_screen.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      "When user clicks on Standard toolbar buttons
      LEAVE PROGRAM.
  ENDCASE.

  CLEAR ok_code.

ENDMODULE.                 " user_command_9001  INPUT
