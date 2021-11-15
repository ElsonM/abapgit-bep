FUNCTION z_aoi_demo1.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_TEXT)   TYPE  TEXT10
*"     REFERENCE(IV_NUMBER) TYPE  INT1
*"  EXPORTING
*"     REFERENCE(EV_OUTPUT) TYPE  TEXT25
*"----------------------------------------------------------------------

  DATA: lv_numtext(3) TYPE n.

  lv_numtext = iv_number.

  CONCATENATE 'Text' iv_text 'Number' lv_numtext
    INTO ev_output
    SEPARATED BY space.

ENDFUNCTION.
