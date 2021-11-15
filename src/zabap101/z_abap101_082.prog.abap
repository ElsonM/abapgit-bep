*&---------------------------------------------------------------------*
*& Report Z_ABAP101_082
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_082.

PARAMETER p_first              RADIOBUTTON GROUP grp1 USER-COMMAND action.
PARAMETER p_busin              RADIOBUTTON GROUP grp1.
PARAMETER p_econo LIKE p_first RADIOBUTTON GROUP grp1.

PARAMETERS p_input1 TYPE string.
PARAMETERS p_input2 TYPE i.

DATA v_last_action LIKE sy-ucomm.

AT SELECTION-SCREEN.
  v_last_action = sy-ucomm.

AT SELECTION-SCREEN OUTPUT.
  IF v_last_action = 'ACTION'.

    CASE 'X'.
      WHEN p_first.
        LOOP AT SCREEN.
          IF screen-name = 'P_INPUT1' OR screen-name = 'P_INPUT2'.
            screen-input = 1.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.

      WHEN p_busin.
        LOOP AT SCREEN.
          IF screen-name = 'P_INPUT1'.
            screen-required = 1.
            MODIFY SCREEN.
          ENDIF.
          IF screen-name = 'P_INPUT2'.
            screen-input = 0.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.

      WHEN p_econo.
        LOOP AT SCREEN.
          IF screen-name = 'P_INPUT1' OR screen-name = 'P_INPUT2'.
            screen-input = 0.
            screen-invisible = 1.
            MODIFY SCREEN.
          ENDIF.
        ENDLOOP.

    ENDCASE.
  ENDIF.
