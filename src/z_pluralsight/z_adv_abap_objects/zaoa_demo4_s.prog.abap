*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report  ZAOA_DEMO4_S
*&
*&---------------------------------------------------------------------*
*& ABAP Objects Advanced Programming: Demo report 4_S.
*&
*& Sales order address display using abstract base
*& class implementation.
*&---------------------------------------------------------------------*

REPORT zaoa_demo4_s.
*********************************************************************
* Selection screen definition
*********************************************************************
TABLES: vbak.

SELECTION-SCREEN BEGIN OF BLOCK main
  WITH FRAME
  TITLE TEXT-s01.
*       --> Enter sales order date range

SELECT-OPTIONS:
  so_date FOR vbak-erdat.

SELECTION-SCREEN END OF BLOCK main.

*********************************************************************
* Startup class definition
*********************************************************************
CLASS lcl_start DEFINITION FINAL.

  PUBLIC SECTION.

    CLASS-METHODS:
*     Startup method
      run
        RAISING zcx_aoa.

ENDCLASS.

*********************************************************************
* Main processing class definition
*********************************************************************
CLASS lcl_main DEFINITION
  INHERITING FROM zcl_aoa_addr_display FINAL.

  PUBLIC SECTION.

    METHODS:
*     Constructor method
      constructor
        IMPORTING
          it_date_range TYPE range_t_dats
        RAISING
          zcx_aoa.

  PROTECTED SECTION.

    METHODS:
*     Redefinition of BUILD_OUTPUT
      build_output REDEFINITION,
*     Persist application messages to log
      write_log.

ENDCLASS.

*********************************************************************
* Global data definitions
*********************************************************************
DATA:
* Exception objects
  gr_error TYPE REF TO cx_root,
  gv_error TYPE string.

*********************************************************************
* Program starts here
*********************************************************************
START-OF-SELECTION.
* Execute startup class static method
  TRY.
      lcl_start=>run( ).
    CATCH cx_root INTO gr_error.
      gv_error = gr_error->get_text( ).
      MESSAGE gv_error
        TYPE 'S'
        DISPLAY LIKE 'E'.
  ENDTRY.

*********************************************************************
* Startup class implementation
*********************************************************************
CLASS lcl_start IMPLEMENTATION.

* -------------------------------------------------------------------
* Startup method
* -------------------------------------------------------------------
  METHOD run.

    DATA:
*     Main processing object
      lo_main TYPE REF TO lcl_main.

*   Create instance of main object passing screen
*   field values as parameter
    CREATE OBJECT lo_main
      EXPORTING
        it_date_range = so_date[].

  ENDMETHOD.

ENDCLASS.

*********************************************************************
* Main processing class implementation
*********************************************************************
CLASS lcl_main IMPLEMENTATION.

* -------------------------------------------------------------------
* BUILD_OUTPUT method redefinition
* -------------------------------------------------------------------
  METHOD build_output.

*   Call superclass method
    super->build_output( ).

*   Set ALV headings for sales orders
    set_column_header(
      EXPORTING
        iv_name = 'DOC_NUMBER'
        iv_text = TEXT-h01
*                 --> Sales doc.
      CHANGING
        cr_alv = mo_alv ).

    set_column_header(
      EXPORTING
        iv_name = 'PARTNER_NAME'
        iv_text = TEXT-h02
*                 --> Customer
      CHANGING
        cr_alv = mo_alv ).

  ENDMETHOD.

* -------------------------------------------------------------------
* Constructor method
* -------------------------------------------------------------------
  METHOD constructor.

    DATA:
*     Application log message structure
      ls_msg   TYPE symsg,
*     Error object
      lo_error TYPE REF TO cx_root.

*   Call super-constructor
    super->constructor( ).

*   Create instance of application log
    cl_cmd_appllog=>create(
      IMPORTING
        ev_loghandle = mv_log_handle
        er_log       = mo_log ).

*   Populate application log message structure
    ls_msg-msgty = mc_info.
    ls_msg-msgid = 'ZAOA'.
    ls_msg-msgno = '009'.

*   Write "Start of processing" message to log
    TRY.
        mo_log->set_message(
          EXPORTING
            is_msg        = ls_msg
            iv_probcl     = mc_pc_medium
            is_msgadd     = ms_log_message_params
            iv_detlevel   = mc_detl_1
          IMPORTING
            es_msg_handle = mv_msg_handle ).
      CATCH cx_cmd_log_wrong_call.
*       Ignore!
    ENDTRY.

*   Read sales documents
    TRY.
        mt_documents = read_sales_orders( it_date_range ).
      CLEANUP INTO lo_error.
*       Write exception text to application log
        TRY.
            mo_log->set_exception(
              EXPORTING
                iv_msgtype           = mc_error
                iv_probcl            = mc_pc_vimportant
                ir_exception         = lo_error
                is_excadd            = ms_log_message_params
                iv_detlevel          = mc_detl_2
              IMPORTING
                es_msg_handle        = mv_msg_handle
                es_msg_handle_origin = mv_msg_handle_orig ).
          CATCH cx_cmd_log_wrong_call.
*           Ignore!
        ENDTRY.

*       Save generated messages to application log
        write_log( ).
    ENDTRY.

*   Create ALV object & build output data
    build_output( ).

*   Save generated messages to application log
    write_log( ).

*   Display output
    mo_alv->display( ).

  ENDMETHOD.

* -------------------------------------------------------------------
* Persist application messages to log
* -------------------------------------------------------------------
  METHOD write_log.

    DATA:
*     List of message handles
      lt_msg_handles TYPE cmd_t_msghndl,
*     Application log assigned numbers
      lt_log_numbers TYPE bal_t_lgnm.

    CONSTANTS:
      lc_object     TYPE balobj_d  VALUE 'ZAOA',
      lc_sub_object TYPE balsubobj VALUE 'SALES'.

*   Set application log key values
    ms_log_key-object    = lc_object.
    ms_log_key-subobject = lc_sub_object.
    ms_log_key-extnumber = TEXT-t02 && sy-datum && sy-uzeit.
*                          --> SalesOrdersList_

    TRY.
*       Convert messages to Business Application Log format
        mo_log->convert_to_bal(
              EXPORTING
                is_logkey     = ms_log_key
              IMPORTING
                ev_balloghndl = mv_log_handle
                et_failed_msg = lt_msg_handles ).

*       Save application log entries
        mo_log->save_ballog(
          EXPORTING
            iv_in_update_task = abap_false
            iv_balloghndl     = mv_log_handle
          IMPORTING
            et_lognumbers     = lt_log_numbers ).
      CATCH cx_cmd_log_conv
            cx_cmd_log_wrong_call.
*       Ignore!
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
