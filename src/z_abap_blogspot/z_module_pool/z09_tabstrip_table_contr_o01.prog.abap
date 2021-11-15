*&---------------------------------------------------------------------*
*&  Include           Z09_TABSTRIP_TABLE_CONTR_O01
*&---------------------------------------------------------------------*

MODULE status_9001 OUTPUT.

  SET PF-STATUS 'PF_MAIN_9001'. "GUI status
  SET TITLEBAR  'TI_MAIN_9001'. "GUI title

ENDMODULE.                 " status_9001  OUTPUT

MODULE display_tc_spfli OUTPUT.

*---------To activate the scrolling option of table control------------*
  PERFORM current_line_spfli.

*-------Moving data from work area to screen fields--------------------*
  spfli-carrid   = wa_spfli-carrid.
  spfli-connid   = wa_spfli-connid.
  spfli-cityfrom = wa_spfli-cityfrom.
  spfli-airpfrom = wa_spfli-airpfrom.
  spfli-cityto   = wa_spfli-cityto.
  spfli-airpto   = wa_spfli-airpto.
  spfli-deptime  = wa_spfli-deptime.
  spfli-arrtime  = wa_spfli-arrtime.
  spfli-distance = wa_spfli-distance.

ENDMODULE.                 " display_tc_spfli  OUTPUT

MODULE display_tc_sflight OUTPUT.

*---------To activate the scrolling option of table control------------*
  PERFORM current_line_sflight.

*-------Moving data from work area to screen fields--------------------*
  sflight-carrid   = wa_sflight-carrid.
  sflight-connid   = wa_sflight-connid.
  sflight-fldate   = wa_sflight-fldate.
  sflight-price    = wa_sflight-price.
  sflight-currency = wa_sflight-currency.
  sflight-seatsmax = wa_sflight-seatsmax.
  sflight-seatsocc = wa_sflight-seatsocc.

ENDMODULE.                 " display_tc_sflight  OUTPUT
