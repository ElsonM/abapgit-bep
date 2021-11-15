*&---------------------------------------------------------------------*
*&  Include           Z04_TBL_CONTROL_SEL_OPT_F01
*&---------------------------------------------------------------------*

FORM get_data_mara.

  IF s_matnr[] IS NOT INITIAL.
    SELECT matnr ersda ernam laeda aenam
           pstat mtart mbrsh matkl meins bstme
      FROM mara INTO TABLE it_mara
      WHERE matnr IN s_matnr.

    IF sy-subrc = 0.
      SORT it_mara.

      "Refreshing table control from the screen
      REFRESH CONTROL 'TAB_CTRL' FROM SCREEN 9002.

      "Calling the screen of table control
      CALL SCREEN 9002.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_data_mara
