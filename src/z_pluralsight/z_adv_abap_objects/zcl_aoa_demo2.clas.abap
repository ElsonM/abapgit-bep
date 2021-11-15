CLASS zcl_aoa_demo2 DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        !iv_sales_order TYPE vbeln_va
        !iv_po_number   TYPE bstkd
        !iv_po_date     TYPE bstdk
        !iv_po_numberx  TYPE as4flag
        !iv_po_datex    TYPE as4flag
      RAISING
        zcx_aoa.

  PROTECTED SECTION.

private section.

  data MV_PREV_PO_NUMBER type BSTKD .
  data MV_NEW_PO_NUMBER type BSTKD .
  data MV_PREV_PO_DATE type BSTDK .
  data MV_NEW_PO_DATE type BSTDK .
  data MV_CHECK_PO_DATE type BSTDK .
  constants MC_LOCK_PRESERVE type CHAR01 value '3' ##NO_TEXT.
  constants MC_ACTION_UPDATE type UPDKZ_D value 'U' ##NO_TEXT.
  constants MC_MAX_DAYS type INT4 value 10 ##NO_TEXT.
  constants MC_ERROR type BAPI_MTYPE value 'E' ##NO_TEXT.

  methods CHANGE_ORDER
    importing
      !IV_SALES_ORDER type VBELN_VA
      !IV_PO_DATEX type AS4FLAG optional
      !IV_PO_NUMBERX type AS4FLAG optional
    raising
      resumable(ZCX_AOA) .
  methods READ_SALES_ORDER
    importing
      !IV_SALES_ORDER type VBELN_VA
    raising
      ZCX_AOA .
  methods LOCK_ORDER
    importing
      !IV_SALES_ORDER type VBELN_VA
    raising
      ZCX_AOA .
  methods UNLOCK_ORDER
    importing
      !IV_SALES_ORDER type VBELN_VA .
  methods CHECK_PO_DATE
    raising
      ZCX_AOA .
ENDCLASS.



CLASS ZCL_AOA_DEMO2 IMPLEMENTATION.


  METHOD change_order.

    DATA:
*     Sales order header structures
      ls_header  TYPE bapisdhd1,
      ls_headerx TYPE bapisdhd1x,

*      lv_error   TYPE string,

*     BAPI return table
      lt_return  TYPE bapiret2_t.

*    FIELD-SYMBOLS:
*      <lwa_return> TYPE bapiret2.

    IF iv_po_datex IS SUPPLIED.

      WRITE:
        / TEXT-m05,
*         --> Changing PO date .....
        / TEXT-m06, '[', mv_prev_po_date, ']',
*         --> Old value =
        / TEXT-m07, '[', mv_new_po_date, ']'.
*         --> New value =

*     Set new PO date & indicator
      ls_header-purch_date  = mv_new_po_date.
      ls_headerx-purch_date = abap_true.

    ELSEIF iv_po_numberx IS SUPPLIED.

      WRITE:
        / TEXT-m08,
*         --> Changing PO number .....
        / TEXT-m06, '[', mv_prev_po_number, ']',
*         --> Old value =
        / TEXT-m07, '[', mv_new_po_number, ']'.
*         --> New value =

*     Set new PO number & indicator
      ls_header-purch_no_c  = mv_new_po_number.
      ls_headerx-purch_no_c = abap_true.

    ENDIF.

*   Set the update indicator
    ls_headerx-updateflag = mc_action_update.

*   Call the update BAPI
    CALL FUNCTION 'SD_SALESDOCUMENT_CHANGE'
      EXPORTING
        salesdocument    = iv_sales_order
        order_header_in  = ls_header
        order_header_inx = ls_headerx
      TABLES
        return           = lt_return.

*   Look for any error
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<lwa_return>)
      WHERE type EQ mc_error.
      DATA(lv_error) = CONV string( <lwa_return>-message ).
      EXIT.
    ENDLOOP.

    IF sy-subrc EQ 0.
*     Raise exception of an error encountered
      RAISE RESUMABLE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid    = zcx_aoa=>dynamic_error
          long_text = lv_error.
    ELSE.
*     Otherwise COMMIT the change
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      WRITE:
        / TEXT-m12.
*         --> Change to sales order saved .....
    ENDIF.

  ENDMETHOD.


  METHOD check_po_date.

    IF mv_new_po_date IS INITIAL OR
       mv_prev_po_date IS INITIAL.
*     Nothing to check when either date is not set
      RETURN.
    ENDIF.

    IF mv_new_po_date > cl_hrpt_date_tools=>add_date(
                          date_in = mv_prev_po_date
                          unit    = cl_hrpt_date_tools=>unit_day
                          count   = mc_max_days ).
*     Exception when new date is out of range
      RAISE EXCEPTION TYPE zcx_aoa.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

*    DATA: lo_error TYPE REF TO zcx_aoa,
*          lv_error TYPE string.

*   Set new order data attributes
    mv_new_po_number = iv_po_number.
    mv_new_po_date   = iv_po_date.

*   Set lock on sales order
    lock_order( iv_sales_order ).

*   Read sales order data
    TRY.
        read_sales_order( iv_sales_order ).
      CLEANUP.
        WRITE:
          / TEXT-m13.
*         --> CLEANUP after exception
*       Free the lock on the Sales Order
        unlock_order( iv_sales_order ).
    ENDTRY.

    TRY.
        CASE abap_true.

          WHEN iv_po_numberx.
*           Change PO number
            change_order( iv_sales_order = iv_sales_order
                          iv_po_numberx  = iv_po_numberx ).

          WHEN iv_po_datex.
*           Validate new PO date
            TRY.
                check_po_date( ).
              CATCH zcx_aoa.
                WRITE:
                  / TEXT-m15.
*                   --> RETRY after exception
*
*               Reset new PO Date
                mv_new_po_date =
                  cl_hrpt_date_tools=>add_date(
                    date_in = mv_prev_po_date
                    unit    = cl_hrpt_date_tools=>unit_day
                    count   = mc_max_days ).
                RETRY.
            ENDTRY.

*           Change PO date
            change_order( iv_sales_order = iv_sales_order
                          iv_po_datex    = iv_po_datex ).

        ENDCASE.
      CATCH BEFORE UNWIND zcx_aoa INTO DATA(lo_error).
        DATA(lv_error) = lo_error->get_text( ).
        WRITE:
          / TEXT-m14,
*           --> RESUME after exception
          / lv_error.
        RESUME.
    ENDTRY.

*   Free lock on sales order
    unlock_order( iv_sales_order ).

    WRITE:
      / TEXT-m11.
*       --> Processing complete!

  ENDMETHOD.


  METHOD lock_order.

    WRITE:
      / TEXT-m01.
*     --> Locking sales order .....

    CALL FUNCTION 'ENQUEUE_EVVBAKE'
      EXPORTING
        vbeln          = iv_sales_order
        _scope         = mc_lock_preserve
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    CASE sy-subrc.

      WHEN 0.
*       OK; no error

      WHEN 1.
*       Order is locked by another user / process
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid      = zcx_aoa=>order_locked
            sales_order = iv_sales_order.

      WHEN OTHERS.
*       Lock system failure
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid      = zcx_aoa=>lock_system_failure.

    ENDCASE.

    WRITE:
      / TEXT-m02.
*     --> Sales order locked .....

  ENDMETHOD.


  METHOD read_sales_order.

    WRITE:
      / TEXT-m03.
*     --> Reading sales order .....

    SELECT SINGLE bstkd bstdk
      INTO (mv_prev_po_number, mv_prev_po_date)
      FROM vbkd
      WHERE vbeln = iv_sales_order.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid      = zcx_aoa=>order_not_found
          sales_order = iv_sales_order.
    ENDIF.

    WRITE:
      / TEXT-m04.
*     --> Sales order data retrieved .....

  ENDMETHOD.


  METHOD unlock_order.

    WRITE:
      / TEXT-m10.
*     --> Unlocking sales order .....

    CALL FUNCTION 'DEQUEUE_EVVBAKE'
      EXPORTING
        vbeln  = iv_sales_order
        _scope = mc_lock_preserve.

  ENDMETHOD.
ENDCLASS.
