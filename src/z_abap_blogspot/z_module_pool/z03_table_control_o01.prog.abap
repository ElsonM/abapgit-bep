*&---------------------------------------------------------------------*
*& Include Z03_TABLE_CONTROL_O01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_9001 OUTPUT
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.

  SET PF-STATUS 'PF_PO_INP'.
  SET TITLEBAR  'PO_TITLE'.

ENDMODULE.

*&---------------------------------------------------------------------*
*& Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
MODULE status_9002 OUTPUT.
  SET PF-STATUS 'PF_PO_INP'.
  SET TITLEBAR  'PO_TITLE'.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module TABLE_CONTROL OUTPUT
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
MODULE table_control OUTPUT.

  "Describing table to populate sy-dbcnt
  DESCRIBE TABLE it_ekpo LINES sy-dbcnt.

  "Current line populates the loop information in table control
  tab_ctrl-current_line = sy-loopc.

  "Lines are populated with number of table lines
  tab_ctrl-lines        = sy-dbcnt.

  "Moving data from work area to screen fields
  ekpo-ebeln = wa_ekpo-ebeln.
  ekpo-ebelp = wa_ekpo-ebelp.
  ekpo-matnr = wa_ekpo-matnr.
  ekpo-werks = wa_ekpo-werks.
  ekpo-lgort = wa_ekpo-lgort.

  CLEAR wa_ekpo.
ENDMODULE.                 " table_control OUTPUT
