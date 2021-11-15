*&---------------------------------------------------------------------*
*& Report  ZAOA_DEMO4_P
*&
*&---------------------------------------------------------------------*
*& ABAP Objects Advanced Programming: Demo report 4_P.
*&
*& Purchase order address display using abstract base
*& class implementation.
*&---------------------------------------------------------------------*

REPORT zaoa_demo4_p.
*********************************************************************
* Selection screen definition
*********************************************************************
TABLES: ekko.

SELECTION-SCREEN BEGIN OF BLOCK main
  WITH FRAME
  TITLE TEXT-s01.
*       --> Enter purchase order date range

  SELECT-OPTIONS:
    so_date FOR ekko-aedat.

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
      build_output REDEFINITION.

  PRIVATE SECTION.

    DATA:
*     ALV event object
      mo_event TYPE REF TO cl_salv_events_table.

    METHODS:
*     Event handler method for double-click
      process_double_click
        FOR EVENT double_click OF cl_salv_events_table
        IMPORTING
          row
          column.

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

*   Set ALV headings for purchase orders
    set_column_header(
      EXPORTING
        iv_name = 'DOC_NUMBER'
        iv_text = text-h01
*                 --> Purch doc.
      CHANGING
        cr_alv = mo_alv ).

    set_column_header(
      EXPORTING
        iv_name = 'PARTNER_NAME'
        iv_text = text-h02
*                 --> Vendor
      CHANGING
        cr_alv = mo_alv ).

  ENDMETHOD.

* -------------------------------------------------------------------
* Constructor method
* -------------------------------------------------------------------
  METHOD constructor.

*   Call super-constructor
    super->constructor( ).

*   Read purchasing documents
    mt_documents = read_purchase_orders( it_date_range ).

*   Create ALV object & build output data
    build_output( ).

*   Create instance of event object
    mo_event = mo_alv->get_event( ).

*   Register the event handler
    SET HANDLER process_double_click
      FOR mo_event.

*   Display output
    mo_alv->display( ).

  ENDMETHOD.

* -------------------------------------------------------------------
* Double-click event handler
* -------------------------------------------------------------------
  METHOD process_double_click.

    FIELD-SYMBOLS:
      <lwa_data> TYPE output_rec.

*   Read ALV row clicked
    READ TABLE mt_output ASSIGNING <lwa_data>
      INDEX row.

*   Display purchase order
    SET PARAMETER
      ID 'BES'
      FIELD <lwa_data>-doc_number.
    CALL TRANSACTION 'ME23N'
      AND SKIP FIRST SCREEN.

  ENDMETHOD.

ENDCLASS.
