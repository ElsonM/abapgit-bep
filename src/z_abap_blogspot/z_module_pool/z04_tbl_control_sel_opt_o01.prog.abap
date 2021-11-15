*&---------------------------------------------------------------------*
*&  Include           Z04_TBL_CONTROL_SEL_OPT_O01
*&---------------------------------------------------------------------*

MODULE status_9001 OUTPUT.

  SET PF-STATUS 'GUI_STATUS'.
  SET TITLEBAR  'TITLE_9001'.

ENDMODULE.                 " status_9001  OUTPUT

MODULE status_9002 OUTPUT.

  SET PF-STATUS 'GUI_STATUS'.
  SET TITLEBAR  'TITLE_9002'.

ENDMODULE.                 " status_9002  OUTPUT

MODULE prepare_table_control OUTPUT.

  "Describing table to populate sy-dbcnt
  DESCRIBE TABLE it_mara LINES sy-dbcnt.

  "Current line populates the loop information in table control
  tab_ctrl-current_line = sy-loopc.

  "Lines are populated with number of table lines
  tab_ctrl-lines        = sy-dbcnt.

  "Moving data from work area to screen fields
  mara-matnr = wa_mara-matnr.
  mara-ersda = wa_mara-ersda.
  mara-ernam = wa_mara-ernam.
  mara-laeda = wa_mara-laeda.
  mara-aenam = wa_mara-aenam.
  mara-pstat = wa_mara-pstat.
  mara-mtart = wa_mara-mtart.
  mara-mbrsh = wa_mara-mbrsh.
  mara-matkl = wa_mara-matkl.
  mara-meins = wa_mara-meins.
  mara-bstme = wa_mara-bstme.
  CLEAR wa_mara.

ENDMODULE.                 " prepare_table_control  OUTPUT
