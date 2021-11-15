*&---------------------------------------------------------------------*
*&  Include           Z05_TWO_TABLE_CONTROLS_O01
*&---------------------------------------------------------------------*

MODULE status_9001 OUTPUT.

  SET PF-STATUS 'PF_SEL'.
  SET TITLEBAR  'TI_SEL'.

ENDMODULE.                 " status_9001  OUTPUT

MODULE status_9002 OUTPUT.

  SET PF-STATUS 'PF_SEL'.
  SET TITLEBAR  'TI_AIR'.

  "The internal table needs to be reset with its previous data
  "The table has been modified with MARK
  "So it needs to be reset to use it again

  it_scarr = it_temp_scarr.

ENDMODULE.                 " status_9002  OUTPUT

MODULE table_control_scarr OUTPUT.

  CLEAR scarr.

  scarr-carrid   = wa_scarr-carrid.
  scarr-carrname = wa_scarr-carrname.
  scarr-currcode = wa_scarr-currcode.

ENDMODULE.                 " table_control_scarr  OUTPUT

MODULE status_9003 OUTPUT.

  SET PF-STATUS 'PF_SEL'.
  SET TITLEBAR 'TI_SPFLI'.

ENDMODULE.                 " status_9003  OUTPUT

MODULE table_control_spfli OUTPUT.

  CLEAR spfli.

  spfli-carrid    = wa_spfli-carrid.
  spfli-connid    = wa_spfli-connid.
  spfli-countryfr = wa_spfli-countryfr.
  spfli-cityfrom  = wa_spfli-cityfrom.
  spfli-airpfrom  = wa_spfli-airpfrom.
  spfli-cityto    = wa_spfli-cityto.
  spfli-airpto    = wa_spfli-airpto.

ENDMODULE.                 " table_control_spfli  OUTPUT
