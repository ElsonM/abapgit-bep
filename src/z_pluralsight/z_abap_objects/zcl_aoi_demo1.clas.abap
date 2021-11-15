class ZCL_AOI_DEMO1 definition
  public
  final
  create public .

public section.

  class-methods DEMO1
    importing
      !IV_TEXT type TEXT10
      !IV_NUMBER type INT1
    exporting
      !EV_OUTPUT type TEXT25 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOI_DEMO1 IMPLEMENTATION.


  METHOD demo1.
    DATA: lv_numtext(3) TYPE n.

    lv_numtext = iv_number.

    CONCATENATE 'Text' iv_text 'Number' lv_numtext
      INTO ev_output
      SEPARATED BY space.
  ENDMETHOD.
ENDCLASS.
