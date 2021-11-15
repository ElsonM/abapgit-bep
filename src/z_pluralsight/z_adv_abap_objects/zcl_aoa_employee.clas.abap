class ZCL_AOA_EMPLOYEE definition
  public
  create public .

public section.

  interfaces ZIF_AOA_EMPLOYEE .

  aliases FACTORY
    for ZIF_AOA_EMPLOYEE~FACTORY .
  aliases EMPLOYEE_DATA_REC
    for ZIF_AOA_EMPLOYEE~EMPLOYEE_DATA_REC .

  methods CONSTRUCTOR
    importing
      !IV_EMPLOYEE_ID type ZIF_AOA_EMPLOYEE~EMPLOYEE_ID
      !IV_EMPLOYEE_TYPE type ZIF_AOA_EMPLOYEE~EMPLOYEE_TYPE
      !IV_NAME type ZIF_AOA_EMPLOYEE~EMPLOYEE_NAME
      !IV_PAY_RATE type ZIF_AOA_EMPLOYEE~PAY_RATE .
  PROTECTED SECTION.

    ALIASES mc_currency
      FOR zif_aoa_employee~mc_currency.
    ALIASES mc_hours_employee
      FOR zif_aoa_employee~mc_hours_employee.
    ALIASES mc_hours_intern
      FOR zif_aoa_employee~mc_hours_intern.
    ALIASES mc_type_employee
      FOR zif_aoa_employee~mc_type_employee.
    ALIASES mc_type_intern
      FOR zif_aoa_employee~mc_type_intern.
    ALIASES mc_type_manager
      FOR zif_aoa_employee~mc_type_manager.
    ALIASES ms_employee_data
      FOR zif_aoa_employee~ms_employee_data.
    ALIASES mv_base_hours
      FOR zif_aoa_employee~mv_base_hours.
    ALIASES mv_base_rate
      FOR zif_aoa_employee~mv_base_rate.

    CONSTANTS mc_object_employee   TYPE seoclsname VALUE 'ZCL_AOA_EMPLOYEE' ##NO_TEXT.
    CONSTANTS mc_object_intern     TYPE seoclsname VALUE 'ZCL_AOA_INTERN'   ##NO_TEXT.
    CONSTANTS mc_object_manager    TYPE seoclsname VALUE 'ZCL_AOA_MANAGER'  ##NO_TEXT.
    CONSTANTS mc_overtime_approved TYPE char01     VALUE '1'                ##NO_TEXT.

    EVENTS overtime_worked
      EXPORTING
        VALUE(iv_base_hours)   TYPE zif_aoa_employee~work_hours
        VALUE(iv_worked_hours) TYPE zif_aoa_employee~work_hours .

    METHODS approve_hours
      FOR EVENT overtime_worked OF zcl_aoa_employee
        IMPORTING
          !iv_base_hours
          !iv_worked_hours.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOA_EMPLOYEE IMPLEMENTATION.


  METHOD approve_hours.

    DATA:
      lv_overtime TYPE zif_aoa_employee~work_hours,
      lv_text     TYPE text132,
      lv_reply    TYPE char01.

*   Calculate overtime worked
    lv_overtime = iv_worked_hours - iv_base_hours.

*   Bild popup text message
    WRITE lv_overtime TO lv_text LEFT-JUSTIFIED NO-ZERO.
    CONCATENATE lv_text TEXT-t01
*                       --> Hours overtime worked by employee
      ms_employee_data-id
      INTO lv_text SEPARATED BY space.

*   Call approval popup
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar      = TEXT-t02
*                       --> Approve Employee Overtime
        text_question = lv_text
        text_button_1 = TEXT-t03
*                       --> Approve
        text_button_2 = TEXT-t04
*                       --> Reject
      IMPORTING
        answer        = lv_reply
      EXCEPTIONS
        OTHERS        = 1.

*   If not approved then set hours worked to Base Hours
    IF lv_reply <> mc_overtime_approved.
      ms_employee_data-hours_worked = mv_base_hours.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

*   Set base hours & pay rate
    CASE iv_employee_type.
      WHEN mc_type_employee
        OR mc_type_manager.
        mv_base_hours = mc_hours_employee.
      WHEN mc_type_intern.
        mv_base_hours = mc_hours_intern.
      WHEN OTHERS.
    ENDCASE.
    mv_base_rate  = iv_pay_rate.

*   Populate data structure
    ms_employee_data-id            = iv_employee_id.
    ms_employee_data-name          = iv_name.
    ms_employee_data-employee_type = iv_employee_type.

*   Register the event handler for overtime
    SET HANDLER approve_hours
      FOR me.

  ENDMETHOD.


  METHOD zif_aoa_employee~calc_salary.

*   Raise event when WORKED hours exceeds BASE hours
    IF ms_employee_data-hours_worked > mv_base_hours.
      RAISE EVENT overtime_worked
        EXPORTING
          iv_base_hours   = mv_base_hours
          iv_worked_hours = ms_employee_data-hours_worked.
    ENDIF.

*   EMPLOYEE Pay Rate is hourly; amount paid is rate * hours worked
    TRY.
        ms_employee_data-salary =
          mv_base_rate * ms_employee_data-hours_worked.
      CATCH cx_sy_arithmetic_error.
        CLEAR ms_employee_data-salary.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_aoa_employee~enter_work_hours.

    IF iv_hours IS INITIAL.
      RAISE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid     = zcx_aoa=>dynamic_error
          short_text = TEXT-e01.
*                      --> No value specified for hours worked
    ENDIF.

    ms_employee_data-hours_worked = iv_hours.

  ENDMETHOD.


  METHOD zif_aoa_employee~factory.

*    DATA:
*      lv_object TYPE seoclsname,
*   Generic error objects
*      lo_error  TYPE REF TO cx_root,
*      lv_error  TYPE string.

*   Map EMPLOYEE TYPE to correct object type
    CASE iv_employee_type.
      WHEN mc_type_employee.
        DATA(lv_object) = mc_object_employee.
      WHEN mc_type_intern.
        lv_object = mc_object_intern.
      WHEN mc_type_manager.
        lv_object = mc_object_manager.
    ENDCASE.

*   Create returned employee interface object
    TRY.
*       Specify EMPLOYEE mapped from class type object
        CREATE OBJECT ro_employee TYPE (lv_object)
          EXPORTING
            iv_employee_id   = iv_employee_id
            iv_employee_type = iv_employee_type
            iv_name          = iv_name
            iv_pay_rate      = iv_pay_rate.
      CATCH cx_root INTO DATA(lo_error).
        DATA(lv_error) = lo_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid    = zcx_aoa=>dynamic_error
            long_text = lv_error.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_aoa_employee~write_info.

    DATA:
      lv_text TYPE text132.

    rs_output-id   = ms_employee_data-id.
    rs_output-name = ms_employee_data-name.

    CASE ms_employee_data-employee_type.
      WHEN mc_type_employee.
        lv_text = TEXT-x01.
*                 --> Employee
      WHEN mc_type_intern.
        lv_text = TEXT-x02.
*                 --> Intern
      WHEN mc_type_manager.
        lv_text = TEXT-x03.
*                 --> Manager
    ENDCASE.

    rs_output-employee_type =
      ms_employee_data-employee_type && | | &&
      lv_text.

    WRITE ms_employee_data-hours_worked
      TO rs_output-hours_worked
      RIGHT-JUSTIFIED.

    WRITE ms_employee_data-salary
      TO rs_output-salary
      CURRENCY mc_currency
      RIGHT-JUSTIFIED.

  ENDMETHOD.
ENDCLASS.
