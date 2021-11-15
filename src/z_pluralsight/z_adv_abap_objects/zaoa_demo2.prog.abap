*&---------------------------------------------------------------------*
*& Report  ZAOA_DEMO2
*&---------------------------------------------------------------------*
*& ABAP Objects Advanced Programming: Demo report 2.
*&
*& Sample report showing exception triggering & handling.
*&---------------------------------------------------------------------*

REPORT zaoa_demo2.
*********************************************************************
* Selection screen definition
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK input WITH FRAME TITLE TEXT-s01.
* --> Sales Order Editing

PARAMETERS: p_sonum TYPE vbeln_va OBLIGATORY. "Sales order number

SELECTION-SCREEN SKIP 1.

PARAMETERS: p_xponum RADIOBUTTON GROUP po, "PO number change flag
            p_ponum  TYPE bstkd.           "PO number

SELECTION-SCREEN SKIP 1.

PARAMETERS: p_xpodat RADIOBUTTON GROUP po, "PO date change flag
            p_podat  TYPE bstdk.           "PO date

SELECTION-SCREEN END OF BLOCK input.

*********************************************************************
* Startup class definition
*********************************************************************
CLASS lcl_start DEFINITION FINAL.

  PUBLIC SECTION.

    CLASS-METHODS:
*     Startup method
      run RAISING zcx_aoa.

ENDCLASS.

*********************************************************************
* Global data definitions
*********************************************************************
*DATA:
* Exception objects
*  gr_error TYPE REF TO cx_root,
*  gv_error TYPE string.

*********************************************************************
* Program starts here
*********************************************************************
START-OF-SELECTION.
* Execute startup class static method
  TRY.
      lcl_start=>run( ).
    CATCH cx_root INTO DATA(gr_error).
      DATA(gv_error) = gr_error->get_text( ).
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
*
*    DATA:
**     Main processing object
*      lo_main TYPE REF TO zcl_aoa_demo2.
*
**   Create instance of main object passing screen
**   field values as parameters
*    CREATE OBJECT lo_main
*      EXPORTING
*        iv_sales_order = p_sonum
*        iv_po_number   = p_ponum
*        iv_po_date     = p_podat
*        iv_po_numberx  = p_xponum
*        iv_po_datex    = p_xpodat.

    DATA(lo_main) = NEW zcl_aoa_demo2(
      iv_sales_order = p_sonum
      iv_po_number   = p_ponum
      iv_po_date     = p_podat
      iv_po_numberx  = p_xponum
      iv_po_datex    = p_xpodat ).

  ENDMETHOD.

ENDCLASS.
