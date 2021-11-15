class ZCL_AOA_DEMO8I definition
  public
  final
  create public .

public section.

  methods METHOD_1 .
  methods METHOD_2 .
  methods METHOD_3 .
  methods METHOD_4
    importing
      !IV_INPUT type TEXT20 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOA_DEMO8I IMPLEMENTATION.


  METHOD method_1.

    MESSAGE TEXT-t01 TYPE 'I'.
*           --> Output from instance method number 1

  ENDMETHOD.


  METHOD method_2.

    MESSAGE TEXT-t02 TYPE 'I'.
*           --> Output from instance method number 2

  ENDMETHOD.


  METHOD method_3.

    MESSAGE TEXT-t03 TYPE 'I'.
*           --> Output from instance method number 3

  ENDMETHOD.


  METHOD method_4.

    DATA:
      lv_text TYPE text132.

    lv_text = TEXT-t04 && | | && iv_input.
*             --> Instance method 4: Input was

    MESSAGE lv_text TYPE 'I'.

  ENDMETHOD.
ENDCLASS.
