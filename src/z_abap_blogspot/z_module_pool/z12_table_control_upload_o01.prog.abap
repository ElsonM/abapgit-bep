*&---------------------------------------------------------------------*
*&  Include           Z12_TABLE_CONTROL_UPLOAD_O01
*&---------------------------------------------------------------------*

MODULE status_9000 OUTPUT.

  SET PF-STATUS 'PF_9000'.
  SET TITLEBAR  'T_9000'.

ENDMODULE.

MODULE tabc_9000_pbo OUTPUT.

  DESCRIBE TABLE it_lfa1 LINES sy-dbcnt.

  tabc_9000-current_line = sy-loopc.
  tabc_9000-lines        = sy-dbcnt.

  lfa1-lifnr = wa_lfa1-lifnr.

ENDMODULE.
