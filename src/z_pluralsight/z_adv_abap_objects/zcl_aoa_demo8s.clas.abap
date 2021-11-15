class ZCL_AOA_DEMO8S definition
  public
  final
  create public .

public section.

  class-methods METHOD_1 .
  class-methods METHOD_2 .
  class-methods METHOD_3 .
  class-methods METHOD_4
    importing
      !IV_INPUT type TEXT20 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOA_DEMO8S IMPLEMENTATION.


  method METHOD_1.

    MESSAGE text-t01 TYPE 'I'.
*           --> Output from static method number 1

  endmethod.


  method METHOD_2.

    MESSAGE text-t02 TYPE 'I'.
*           --> Output from static method number 2

  endmethod.


  method METHOD_3.

    MESSAGE text-t03 TYPE 'I'.
*           --> Output from static method number 3

  endmethod.


  method METHOD_4.

    DATA:
      lv_text TYPE text132.

    lv_text = text-t04 && | | && iv_input.
*             --> Static method 4: Input was

    MESSAGE lv_text TYPE 'I'.

  endmethod.
ENDCLASS.
