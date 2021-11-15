*&---------------------------------------------------------------------*
*& Report ZDEMO_ABAP_UNIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_abap_unit.

CLASS lcl_account DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_customer,
             acc_no  TYPE char5,
             tax_amt TYPE bseg-mwsts,
           END OF ty_customer.
    TYPES tt_customer TYPE STANDARD TABLE OF ty_customer.
    METHODS: set_customer IMPORTING im_customer TYPE tt_customer,
      get_tax_due IMPORTING im_acc_no         TYPE char5
                  RETURNING VALUE(rt_tax_amt) TYPE bseg-mwsts.
  PRIVATE SECTION.
    DATA it_customer TYPE STANDARD TABLE OF ty_customer.

ENDCLASS.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_account
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_account IMPLEMENTATION.

  METHOD set_customer .
    it_customer = im_customer.
  ENDMETHOD.

  METHOD get_tax_due.
    FIELD-SYMBOLS <fs_customer> LIKE LINE OF it_customer.
    LOOP AT it_customer ASSIGNING <fs_customer> WHERE acc_no EQ im_acc_no.
      rt_tax_amt = rt_tax_amt + <fs_customer>-tax_amt.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.               "lcl_account

CLASS lcl_test DEFINITION FOR TESTING
               RISK LEVEL HARMLESS
               DURATION SHORT.

  PRIVATE SECTION.
    DATA o_customer TYPE REF TO lcl_account.
    METHODS: setup,
      teardown,
      check_valid_tax FOR TESTING,
      check_invalid_tax FOR TESTING.

ENDCLASS.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_test
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_test IMPLEMENTATION.

  METHOD setup.
    TYPES: BEGIN OF ty_customer,
             acc_no  TYPE char5,
             tax_amt TYPE bseg-mwsts,
           END OF ty_customer.

    DATA: lt_customer TYPE STANDARD TABLE OF ty_customer,
          lw_customer LIKE LINE OF lt_customer.

    lw_customer-acc_no = '1001'.
    lw_customer-tax_amt = '50'.
    APPEND lw_customer TO lt_customer.

    lw_customer-acc_no = '1001'.
    lw_customer-tax_amt = '80'.
    APPEND lw_customer TO lt_customer.

    lw_customer-acc_no = '1002'.
    lw_customer-tax_amt = '100'.
    APPEND lw_customer TO lt_customer.

    lw_customer-acc_no = '1002'.
    lw_customer-tax_amt = '200'.
    APPEND lw_customer TO lt_customer.

    CREATE OBJECT o_customer.
    o_customer->set_customer( lt_customer ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR o_customer.
  ENDMETHOD.

  METHOD check_valid_tax.
    DATA lv_tax_amt TYPE bseg-mwsts.
    lv_tax_amt = o_customer->get_tax_due( '1001' ).
    cl_abap_unit_assert=>assert_equals(
    exp = 130
    act = lv_tax_amt
    msg = 'Tax calculation is incorrect'
    ).
  ENDMETHOD.

  METHOD check_invalid_tax.
    DATA lv_tax_amt TYPE bseg-mwsts.
    lv_tax_amt = o_customer->get_tax_due( '2000' ).
    cl_abap_unit_assert=>assert_equals(
    exp = 0
    act = lv_tax_amt
    msg = 'Tax calculation is incorrect'
    ).
  ENDMETHOD.

ENDCLASS.               "lcl_test
