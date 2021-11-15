interface ZIF_AOA_EMPLOYEE
  public .


  types EMPLOYEE_ID type P_PERNR .
  types EMPLOYEE_NAME type NAME1_GP .
  types EMPLOYEE_TYPE type FMPGK .
  types PAY_RATE type P08_FLREE .
  types WORK_HOURS type TISTD .
  types:
    BEGIN OF employee_data_rec,
           id            TYPE employee_id,
           name          TYPE employee_name,
           employee_type TYPE employee_type,
           hours_worked  TYPE work_hours,
           salary        TYPE pay_rate,
         END OF employee_data_rec .
  types:
    BEGIN OF employee_list_rec,
           id       TYPE employee_id,
           employee TYPE REF TO zif_aoa_employee,
         END OF employee_list_rec .
  types:
    employee_list_tab
    TYPE HASHED TABLE OF employee_list_rec
    WITH UNIQUE KEY id
    INITIAL SIZE 0 .
  types:
    BEGIN OF output_data_rec,
           id            TYPE text8,
           gap1          TYPE char02,
           name          TYPE name1_gp,
           gap2          TYPE char02,
           employee_type TYPE text20,
           gap3          TYPE char02,
           hours_worked  TYPE text6,
           gap4          TYPE char02,
           salary        TYPE text10,
         END OF output_data_rec .
  types:
    output_data_tab
   TYPE STANDARD TABLE OF output_data_rec .

  constants MC_CURRENCY type WAERS value 'USD' ##NO_TEXT.
  constants MC_HOURS_EMPLOYEE type WORK_HOURS value 42 ##NO_TEXT.
  constants MC_HOURS_INTERN type WORK_HOURS value 25 ##NO_TEXT.
  constants MC_TYPE_EMPLOYEE type EMPLOYEE_TYPE value '01' ##NO_TEXT.
  constants MC_TYPE_INTERN type EMPLOYEE_TYPE value '02' ##NO_TEXT.
  constants MC_TYPE_MANAGER type EMPLOYEE_TYPE value '03' ##NO_TEXT.
  data MS_EMPLOYEE_DATA type EMPLOYEE_DATA_REC read-only .
  data MV_BASE_HOURS type WORK_HOURS read-only .
  data MV_BASE_RATE type PAY_RATE read-only .

  class-methods FACTORY
    importing
      !IV_EMPLOYEE_ID type EMPLOYEE_ID
      !IV_EMPLOYEE_TYPE type EMPLOYEE_TYPE
      !IV_NAME type EMPLOYEE_NAME
      !IV_PAY_RATE type PAY_RATE
    returning
      value(RO_EMPLOYEE) type ref to ZIF_AOA_EMPLOYEE
    raising
      ZCX_AOA .
  methods ENTER_WORK_HOURS
    importing
      !IV_HOURS type WORK_HOURS
    raising
      ZCX_AOA .
  methods CALC_SALARY .
  methods WRITE_INFO
    returning
      value(RS_OUTPUT) type OUTPUT_DATA_REC .
endinterface.
