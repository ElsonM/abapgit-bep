class ZCL_AOA_DEMO3 definition
  public
  final
  create public .

public section.
  interface ZIF_AOA_EMPLOYEE load .

  methods CONSTRUCTOR
    importing
      !IV_ACTION_HOURS type AS4FLAG
      !IV_ACTION_CALC type AS4FLAG
      !IV_ACTION_WRITE type AS4FLAG
      !IV_EMPLOYEE_ID type ZIF_AOA_EMPLOYEE=>EMPLOYEE_ID
      !IV_WORK_HOURS type ZIF_AOA_EMPLOYEE=>WORK_HOURS
    raising
      ZCX_AOA .
  class-methods CLASS_CONSTRUCTOR .
  PROTECTED SECTION.
private section.

  class-data MT_EMPLOYEES type ZIF_AOA_EMPLOYEE=>EMPLOYEE_LIST_TAB .

  methods GET_EMPLOYEE
    importing
      !IV_EMPLOYEE_ID type ZIF_AOA_EMPLOYEE=>EMPLOYEE_ID
    returning
      value(RS_DATA) type ZIF_AOA_EMPLOYEE=>EMPLOYEE_LIST_REC
    raising
      ZCX_AOA .
  methods GET_HEADER
    returning
      value(RS_OUTPUT) type ZIF_AOA_EMPLOYEE=>OUTPUT_DATA_REC .
ENDCLASS.



CLASS ZCL_AOA_DEMO3 IMPLEMENTATION.


  METHOD class_constructor.

    DATA:
      ls_data  TYPE zif_aoa_employee=>employee_list_rec,
      lo_error TYPE REF TO cx_root,
      lv_error TYPE string.

    TRY.
*       Add EMPLOYEE object to list table; pay rate is hourly
*        ls_data-id = '00000001'.
*        ls_data-employee =
*          zcl_aoa_employee=>factory( iv_employee_id = '00000001'
*                                     iv_employee_type =
*                                       zif_aoa_employee=>mc_type_employee
*                                     iv_name     = 'Frank Adams'
*                                     iv_pay_rate = '15.30' ).
*        INSERT ls_data INTO TABLE mt_employees.
*        IF sy-subrc <> 0.
*          RAISE EXCEPTION TYPE zcx_aoa
*            EXPORTING
*              textid      = zcx_aoa=>employee_already_exists
*              employee_id = ls_data-id.
*        ENDIF.

*       Add INTERN object to list table; pay rate is per diem amount
*        ls_data-id = '00000002'.
*        ls_data-employee =
*          zcl_aoa_intern=>factory( iv_employee_id = '00000002'
*                                   iv_employee_type =
*                                     zif_aoa_employee=>mc_type_intern
*                                   iv_name     = 'James Sullivan'
*                                   iv_pay_rate = '350.00' ).
*        INSERT ls_data INTO TABLE mt_employees.
*        IF sy-subrc <> 0.
*          RAISE EXCEPTION TYPE zcx_aoa
*            EXPORTING
*              textid      = zcx_aoa=>employee_already_exists
*              employee_id = ls_data-id.
*        ENDIF.

*       Add MANAGER object to list table; initial pay rate is same as EMPLOYEE type
*        ls_data-id = '00000003'.
*        ls_data-employee =
*          zcl_aoa_intern=>factory( iv_employee_id = '00000003'
*                                   iv_employee_type =
*                                     zif_aoa_employee=>mc_type_manager
*                                   iv_name     = 'Jill Fleming'
*                                   iv_pay_rate = '15.30' ).
*        INSERT ls_data INTO TABLE mt_employees.
*        IF sy-subrc <> 0.
*          RAISE EXCEPTION TYPE zcx_aoa
*            EXPORTING
*              textid      = zcx_aoa=>employee_already_exists
*              employee_id = ls_data-id.
*        ENDIF.

        SELECT * FROM zaoa_employee INTO TABLE @DATA(lt_employees).

        LOOP AT lt_employees INTO DATA(ls_employee).

          ls_data-id = ls_employee-employee_id.
          ls_data-employee =
            zcl_aoa_intern=>factory( iv_employee_id   = ls_employee-employee_id
                                     iv_employee_type = ls_employee-employee_type
                                     iv_name          = ls_employee-employee_name
                                     iv_pay_rate      = ls_employee-pay_rate ).
          INSERT ls_data INTO TABLE mt_employees.

        ENDLOOP.

      CATCH cx_root INTO lo_error.
        lv_error = lo_error->get_text( ).
        MESSAGE a000 WITH lv_error.
    ENDTRY.

  ENDMETHOD.


  METHOD constructor.

    DATA:
*     Employee list record
      lwa_data    TYPE zif_aoa_employee=>employee_list_rec,
*     Employee data record
      ls_employee TYPE zif_aoa_employee=>employee_data_rec,
*     Employee output data record & table
      lwa_output  TYPE zif_aoa_employee=>output_data_rec,
      lt_output   TYPE zif_aoa_employee=>output_data_tab.

    DATA answer TYPE string.

    CASE abap_true.

*     Enter work hours
      WHEN iv_action_hours.
*       Read employee object
        lwa_data = get_employee( iv_employee_id ).

*       Enter hours worked
        lwa_data-employee->enter_work_hours( iv_work_hours ).

*        MESSAGE TEXT-m02 TYPE 'S'.
        MESSAGE s006 WITH iv_employee_id.
*               --> Work hours entered for employee &

*     Calculate salary
      WHEN iv_action_calc.
*       Read all employees
        LOOP AT mt_employees INTO lwa_data.
*         Calculate employee salary
          lwa_data-employee->calc_salary( ).
        ENDLOOP.

        MESSAGE TEXT-m02 TYPE 'S'.
*               --> Salary calculation completed

*     Output employee data
      WHEN iv_action_write.
*       Build an output header
        lwa_output = get_header( ).
        APPEND lwa_output TO lt_output.

*       Read all employees
        LOOP AT mt_employees INTO lwa_data.
*         Write employee details
          lwa_output = lwa_data-employee->write_info( ).
          APPEND lwa_output TO lt_output.
        ENDLOOP.

*       Display the output
        CALL FUNCTION 'POPUP_WITH_TABLE'
          EXPORTING
            startpos_row = 5
            startpos_col = 5
            endpos_row   = 15
            endpos_col   = 92
            titletext    = TEXT-t01
*                          --> Employee list
          IMPORTING
            choice       = answer
          TABLES
            valuetab     = lt_output
          EXCEPTIONS
            OTHERS       = 1.

        IF sy-subrc <> 0.
*         Ignore
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD get_employee.

    READ TABLE mt_employees INTO rs_data
      WITH TABLE KEY id = iv_employee_id.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid      = zcx_aoa=>employee_not_found
          employee_id = iv_employee_id.
    ENDIF.

  ENDMETHOD.


  METHOD get_header.

    rs_output-id = TEXT-h01.
*                  --> ID
    rs_output-name = TEXT-h02.
*                    --> Name
    rs_output-employee_type = TEXT-h03.
*                             --> Category
    rs_output-hours_worked = TEXT-h04.
*                            --> Hours
    rs_output-salary = TEXT-h05.
*                      --> Pay Amount

  ENDMETHOD.
ENDCLASS.
