*&---------------------------------------------------------------------*
*&  Include           Z03_TABLE_CONTROL_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_PO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_po.
  IF ekko-ebeln IS NOT INITIAL.
    REFRESH: it_ekpo.

    SELECT SINGLE ebeln bukrs ernam lifnr
      FROM ekko INTO wa_ekko
      WHERE ebeln = ekko-ebeln.

    IF sy-subrc = 0.
      SELECT ebeln ebelp matnr werks lgort
        FROM ekpo INTO TABLE it_ekpo
        WHERE ebeln = wa_ekko-ebeln.

      IF sy-subrc = 0.
        SORT it_ekpo.

        "Refreshing the table control to have updated data
        REFRESH CONTROL 'TAB_CTRL' FROM SCREEN 9002.

        CLEAR ok_code1.
        CALL SCREEN 9002.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " get_po
