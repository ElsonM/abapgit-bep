*&---------------------------------------------------------------------*
*&  Include           Z07_TABLE_CONTROL_DISABLE_O01
*&---------------------------------------------------------------------*

MODULE status_9001 OUTPUT.

  "Setting PF status and Title
  SET PF-STATUS 'PF_9001'.
  SET TITLEBAR  'TI_9001'.

  "Preparing the Sales Header information
  vbak-erdat = wa_vbak-erdat.
  vbak-ernam = wa_vbak-ernam.
  vbak-vkorg = wa_vbak-vkorg.

ENDMODULE.                 " status_9001  OUTPUT

MODULE prepare_table_control OUTPUT.

  "Describing table to generate sy-dbcnt
  DESCRIBE TABLE it_vbap LINES sy-dbcnt.

  tab_ctrl-current_line = sy-loopc.
  tab_ctrl-lines        = sy-dbcnt.

  "Preparing the Table Control data of Sales Doc Items
  vbap-vbeln = wa_vbap-vbeln.
  vbap-posnr = wa_vbap-posnr.
  vbap-matnr = wa_vbap-matnr.
  vbap-matkl = wa_vbap-matkl.
  CLEAR wa_vbap.

  "If user clicks on the DISABLE button
  IF disable IS NOT INITIAL.
    LOOP AT SCREEN.
      CASE screen-name.
        WHEN 'VBAP-VBELN'.
          screen-input = '0'. "Input Disabled for VBELN
          MODIFY SCREEN.
        WHEN 'VBAP-POSNR'.
          screen-input = '0'. "Input Disabled for POSNR
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.
  ENDIF.

ENDMODULE.                 " prepare_table_control  OUTPUT
