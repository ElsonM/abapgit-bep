class ZCL_AOA_INTERN definition
  public
  inheriting from ZCL_AOA_EMPLOYEE
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_EMPLOYEE_ID type ZIF_AOA_EMPLOYEE~EMPLOYEE_ID
      !IV_NAME type EMPLOYEE_DATA_REC-NAME
      !IV_PAY_RATE type ZIF_AOA_EMPLOYEE~PAY_RATE
      !IV_EMPLOYEE_TYPE type ZIF_AOA_EMPLOYEE~EMPLOYEE_TYPE .

  methods ZIF_AOA_EMPLOYEE~CALC_SALARY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_AOA_INTERN IMPLEMENTATION.


  METHOD constructor.

    super->constructor( iv_employee_id   = iv_employee_id
                        iv_employee_type = iv_employee_type
                        iv_name          = iv_name
                        iv_pay_rate      = iv_pay_rate ).

  ENDMETHOD.


  METHOD zif_aoa_employee~calc_salary.

*   INTERN Pay Rate is flat sum, payable if
*   HOURS WORKED >= BASE HOURS.
    IF ms_employee_data-hours_worked >= mv_base_hours.
      ms_employee_data-salary = mv_base_rate.
    ELSE.
      CLEAR ms_employee_data-salary.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
