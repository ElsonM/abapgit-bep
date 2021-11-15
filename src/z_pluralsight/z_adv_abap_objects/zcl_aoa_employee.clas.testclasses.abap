
CLASS lcl_employee_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Employee_Test
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>ZCL_AOA_EMPLOYEE
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL/>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO zcl_aoa_employee.  "class under test

    METHODS: setup.
    METHODS: teardown.
    METHODS: calc_salary FOR TESTING.
ENDCLASS.       "lcl_Employee_Test


CLASS lcl_employee_test IMPLEMENTATION.

  METHOD setup.

    DATA iv_employee_id TYPE zif_aoa_employee=>employee_id.
    DATA iv_employee_type TYPE zif_aoa_employee=>employee_type.
    DATA iv_name TYPE zif_aoa_employee=>employee_name.
    DATA iv_pay_rate TYPE zif_aoa_employee=>pay_rate.

*   Set CONSTRUCTOR parameter values
    iv_employee_id   = '00000001'.
    iv_employee_type = zif_aoa_employee=>mc_type_employee.
    iv_name          = 'Frank Adams'.
    iv_pay_rate      = '15.30'.

    CREATE OBJECT f_cut
      EXPORTING
        iv_employee_id   = iv_employee_id
        iv_employee_type = iv_employee_type
        iv_name          = iv_name
        iv_pay_rate      = iv_pay_rate.

*   Enter number of hours worked
    TRY.
        f_cut->zif_aoa_employee~enter_work_hours( '40' ).
      CATCH zcx_aoa.
    ENDTRY.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD calc_salary.

*   Prerequisite is HOURS_WORKED must have been entered
    cl_abap_unit_assert=>assert_not_initial(
      act   = f_cut->zif_aoa_employee~ms_employee_data-hours_worked
      msg   = 'No value specified for hours worked'
      level = if_aunit_constants=>critical
      quit  = if_aunit_constants=>no ).

    f_cut->zif_aoa_employee~calc_salary( ).

*   Checke that salary is calculated as excpected
    cl_abap_unit_assert=>assert_equals(
      act   = f_cut->zif_aoa_employee~ms_employee_data-salary
      msg   = 'Salary value incorrect'
      exp   = '612'
      level = if_aunit_constants=>critical
      quit  = if_aunit_constants=>no ).

  ENDMETHOD.

ENDCLASS.
