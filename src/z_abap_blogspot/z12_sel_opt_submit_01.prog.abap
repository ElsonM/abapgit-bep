*&---------------------------------------------------------------------*
*& Report Z12_SEL_OPT_SUBMIT_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z12_sel_opt_submit_01.

TABLES: ekko, rsparams.

DATA: it_params TYPE TABLE OF rsparams,
      wa_params TYPE          rsparams.

SELECT-OPTIONS s_ebeln FOR ekko-ebeln.

LOOP AT s_ebeln.
  wa_params-selname = 'S_EBELN1'.
  wa_params-kind    = 'S'.
  wa_params-sign    = s_ebeln-sign.
  wa_params-option  = s_ebeln-option.
  wa_params-low     = s_ebeln-low.
  wa_params-high    = s_ebeln-high.
  APPEND wa_params TO it_params.
ENDLOOP.

SUBMIT z12_sel_opt_submit_02 WITH SELECTION-TABLE it_params
  AND RETURN.
