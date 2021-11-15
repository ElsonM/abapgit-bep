*&---------------------------------------------------------------------*
*&  Include           Z10_UPDATE_DB_O01
*&---------------------------------------------------------------------*

MODULE status_9001 OUTPUT.

  SET PF-STATUS 'PF_CUST_INPUT'.
  SET TITLEBAR  'CUST_INPUT'.

ENDMODULE.                 " STATUS_9001  OUTPUT

MODULE status_9002 OUTPUT.

  SET PF-STATUS 'PF_CUST_OUTPUT'.
  SET TITLEBAR  'CUST_OUTPUT'.

  IF ok_code1 = 'DISP'.
    PERFORM customer_output.
  ENDIF.

ENDMODULE.                 " STATUS_9002  OUTPUT
