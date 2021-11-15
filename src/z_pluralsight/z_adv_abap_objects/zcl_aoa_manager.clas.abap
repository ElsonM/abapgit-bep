class ZCL_AOA_MANAGER definition
  public
  inheriting from ZCL_AOA_EMPLOYEE
  final
  create public .

public section.

  methods ZIF_AOA_EMPLOYEE~CALC_SALARY
    redefinition .
protected section.
private section.

  methods CALC_UPLIFT
    importing
      !IV_SALARY type EMPLOYEE_DATA_REC-SALARY
    returning
      value(RV_SALARY) type EMPLOYEE_DATA_REC-SALARY .
ENDCLASS.



CLASS ZCL_AOA_MANAGER IMPLEMENTATION.


  METHOD calc_uplift.

*   Return base salary increased by 5%
    TRY.
        rv_salary =
          iv_salary + ( iv_salary * 5 / 100 ).
      CATCH cx_sy_arithmetic_error.
        CLEAR rv_salary.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_aoa_employee~calc_salary.

    super->zif_aoa_employee~calc_salary( ).

*   Add MANAGER uplift value to base salary
    ms_employee_data-salary = calc_uplift( ms_employee_data-salary ).

  ENDMETHOD.
ENDCLASS.
