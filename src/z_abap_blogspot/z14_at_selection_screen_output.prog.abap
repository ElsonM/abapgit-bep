*&---------------------------------------------------------------------*
*& Report Z14_AT_SELECTION_SCREEN_OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z14_at_selection_screen_output.

PARAMETERS: po      RADIOBUTTON GROUP rad1 DEFAULT 'X' USER-COMMAND test,
            item    RADIOBUTTON GROUP rad1,
            p_ebeln TYPE ekko-ebeln,
            p_bukrs TYPE ekko-bukrs,
            p_ebelp TYPE ekpo-ebelp,
            p_matnr TYPE ekpo-matnr.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    "If item is selected then Item field appears
    IF screen-name CP '*P_EBELP*'.
      IF item IS NOT INITIAL.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.

    "If item is selected then Material field appears
    IF screen-name CP '*P_MATNR*'.
      IF item IS NOT INITIAL.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.

    "If item is selected then Company field disappears
    IF screen-name CP '*P_BUKRS*'.
      IF item IS NOT INITIAL.
        screen-active = 0.
      ELSE.
        screen-active = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
