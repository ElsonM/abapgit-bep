*&---------------------------------------------------------------------*
*& Report Z13_CHANGE_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z13_change_screen.

PARAMETERS: show     RADIOBUTTON GROUP g1 USER-COMMAND int1,
            no_show  RADIOBUTTON GROUP g1, """ FCODE INT1
            no_input RADIOBUTTON GROUP g1.

PARAMETERS: integer TYPE i MODIF ID int.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 EQ 'INT' AND show EQ 'X'.
      screen-active =  1.
      MODIFY SCREEN.
    ELSEIF screen-group1 EQ 'INT' AND no_show EQ 'X'.
      screen-active =  0.
      MODIFY SCREEN.
    ELSEIF screen-group1 EQ 'INT' AND no_input EQ 'X'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
