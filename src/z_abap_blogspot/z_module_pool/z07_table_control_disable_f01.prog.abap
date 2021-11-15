*&---------------------------------------------------------------------*
*&  Include           Z07_TABLE_CONTROL_DISABLE_F01
*&---------------------------------------------------------------------*

FORM get_sales_data.

  IF vbak-vbeln IS NOT INITIAL.
    SELECT SINGLE vbeln erdat ernam vkorg
      FROM vbak INTO wa_vbak
      WHERE vbeln = vbak-vbeln.

    IF sy-subrc = 0.
      SELECT vbeln posnr matnr matkl
        FROM vbap INTO TABLE it_vbap
        WHERE vbeln = vbak-vbeln.

      IF sy-subrc = 0.
        SORT it_vbap.
        REFRESH CONTROL 'TAB_CTRL' FROM SCREEN 9001.
        CALL SCREEN 9001.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_sales_data


FORM refresh_sales_data.

  CLEAR: wa_vbak, vbak, vbap, ok_code.
  REFRESH it_vbap.

ENDFORM.                    " refresh_sales_data
