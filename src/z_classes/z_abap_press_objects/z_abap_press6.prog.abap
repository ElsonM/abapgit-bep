*&---------------------------------------------------------------------*
*& Report Z_ABAP_PRESS6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap_press6.

CLASS lcl_employee DEFINITION ABSTRACT.
  PUBLIC SECTION.
    INTERFACES zif_comparable.

    METHODS:
      constructor IMPORTING iv_id         TYPE pernr_d
                            iv_first_name TYPE ad_namefir
                            iv_last_name  TYPE ad_namelas,
      get_id RETURNING VALUE(rv_id) TYPE pernr_d,
      get_details RETURNING VALUE(rv_details) TYPE string,
      get_paystub_amount ABSTRACT RETURNING VALUE(rv_wages)
                                              TYPE bapicurr_d.

  PROTECTED SECTION.
    DATA: mv_id         TYPE pernr_d,
          mv_first_name TYPE ad_namefir,
          mv_last_name  TYPE ad_namelas.
ENDCLASS.

CLASS lcl_hourly_employee DEFINITION
                            INHERITING FROM lcl_employee.
  PUBLIC SECTION.
    CONSTANTS:
      co_work_week TYPE i VALUE 40.

    METHODS:
      constructor IMPORTING iv_id          TYPE pernr_d
                            iv_first_name  TYPE ad_namefir
                            iv_last_name   TYPE ad_namelas
                            iv_hourly_rate TYPE bapicurr_d,
      get_paystub_amount REDEFINITION.

  PRIVATE SECTION.
    DATA mv_hourly_rate TYPE bapicurr_d.
ENDCLASS.

CLASS lcl_salaried_employee DEFINITION
                              INHERITING FROM lcl_employee.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_id         TYPE pernr_d
                            iv_first_name TYPE ad_namefir
                            iv_last_name  TYPE ad_namelas
                            iv_salary     TYPE bapicurr_d,
      get_paystub_amount REDEFINITION.

  PRIVATE SECTION.
    DATA mv_salary TYPE bapicurr_d.
ENDCLASS.

DATA lo_hourly_emp TYPE REF TO lcl_hourly_employee.
DATA lo_salary_emp TYPE REF TO lcl_salaried_employee.

CREATE OBJECT lo_hourly_emp
  EXPORTING
    iv_id          = '12345678'
    iv_first_name  = 'Andersen'
    iv_last_name   = 'Wood'
    iv_hourly_rate = '80.00'.

CREATE OBJECT lo_salary_emp
  EXPORTING
    iv_id         = '23456789'
    iv_first_name = 'Paige'
    iv_last_name  = 'Wood'
    iv_salary     = '150000'.

IF lo_hourly_emp->get_paystub_amount( ) GT
     lo_salary_emp->get_paystub_amount( ).
  WRITE:/ lo_hourly_emp->get_details( ), 'makes more money.'.
ELSE.
  WRITE:/ lo_salary_emp->get_details( ), 'makes more money.'.
ENDIF.

IF lo_hourly_emp->zif_comparable~compare_to( lo_salary_emp ) LT 0.
  WRITE:/ lo_hourly_emp->get_details( ), 'is smaller than', lo_salary_emp->get_details( ).
ELSEIF lo_hourly_emp->zif_comparable~compare_to( lo_salary_emp ) EQ 0.
  WRITE:/ lo_hourly_emp->get_details( ), 'is equal to', lo_salary_emp->get_details( ).
ELSE.
  WRITE:/ lo_hourly_emp->get_details( ), 'is greater than', lo_salary_emp->get_details( ).
ENDIF.

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_employee
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_employee IMPLEMENTATION.
  METHOD constructor.
    me->mv_id         = iv_id.
    me->mv_first_name = iv_first_name.
    me->mv_last_name  = iv_last_name.
  ENDMETHOD.

  METHOD get_id.
    rv_id = me->mv_id.
  ENDMETHOD.

  METHOD get_details.
    rv_details =
     |Employe #{ mv_id }: { mv_first_name } { mv_last_name }|.
  ENDMETHOD.

  METHOD zif_comparable~compare_to.
    "Perform a widening cast on the comparison object
    "so that we can access its components during the
    "comparison process:
    DATA(lo_employee) = CAST lcl_employee( io_object ).

    "Compare the two employees based on their ID number:
    IF me->get_id( ) > lo_employee->get_id( ).
      rv_result = 1.
    ELSEIF me->get_id( ) < lo_employee->get_id( ).
      rv_result = -1.
    ELSE.
      rv_result = 0.
    ENDIF.
  ENDMETHOD.
ENDCLASS.               "lcl_employee

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_hourly_employee
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_hourly_employee IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      EXPORTING
        iv_id         = iv_id
        iv_first_name = iv_first_name
        iv_last_name  = iv_last_name ).

    me->mv_hourly_rate = iv_hourly_rate.
  ENDMETHOD.

  METHOD get_paystub_amount.
    rv_wages = me->mv_hourly_rate * co_work_week.
  ENDMETHOD.
ENDCLASS.               "lcl_hourly_employee

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_salaried_employee
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_salaried_employee IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
     EXPORTING
       iv_id         = iv_id
       iv_first_name = iv_first_name
       iv_last_name  = iv_last_name ).

    me->mv_salary = iv_salary.
  ENDMETHOD.

  METHOD get_paystub_amount.
    rv_wages = me->mv_salary / 52.
  ENDMETHOD.
ENDCLASS.               "lcl_salaried_employee
