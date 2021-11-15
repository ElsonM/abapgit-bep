class ZCL_AOA_TEST1 definition
  public
  final
  create public .

public section.

  methods DIVIDE
    importing
      !IV_NUM type INT4
      !IV_DIV type INT4
    returning
      value(RV_RESULT) type BSKRFX
    raising
      CX_SY_ARITHMETIC_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOA_TEST1 IMPLEMENTATION.


  METHOD divide.
    TRY.
        rv_result = iv_num / iv_div.
      CATCH cx_sy_zerodivide.
        rv_result = -1.
      CATCH cx_sy_arithmetic_overflow.
        rv_result = -2.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
