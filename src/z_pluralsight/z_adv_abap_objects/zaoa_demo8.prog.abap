*&---------------------------------------------------------------------*
*& Report  ZAOA_DEMO8
*&
*&---------------------------------------------------------------------*
*& ABAP Objects Advanced Programming: Demo report 8.
*&
*& Dynamic programming: Classes & methods.
*&---------------------------------------------------------------------*

REPORT zaoa_demo8.
*********************************************************************
* Selection screen definition
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK main
  WITH FRAME
  TITLE TEXT-s01.
*       --> Select class type & method

PARAMETERS:
  p_class  TYPE zaoa_class_type OBLIGATORY,
  p_method TYPE zaoa_method     OBLIGATORY.

SELECTION-SCREEN SKIP 1.

PARAMETERS:
  p_text TYPE text20 LOWER CASE.

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
CLASS lcl_main DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS:
*     Constructor method
      constructor
        IMPORTING
          iv_class_type TYPE zaoa_class_type
          iv_method     TYPE zaoa_method
          iv_text       TYPE text20
        RAISING
          zcx_aoa.

  PRIVATE SECTION.

    CONSTANTS:
      mc_cltype_instance TYPE zaoa_class_type
        VALUE 'Instance',
      mc_cltype_static   TYPE zaoa_class_type
        VALUE 'Static',
      mc_class_static    TYPE seoclsname
        VALUE 'ZCL_AOA_DEMO8S'.

    METHODS:
*     Call instance method with parameters
      call_instance_method
        IMPORTING
          ir_class  TYPE REF TO zcl_aoa_demo8i
          iv_method TYPE seocpdname
          iv_text   TYPE text20
        RAISING
          zcx_aoa,

*     Call static method with parameters
      call_static_method
        IMPORTING
          iv_class  TYPE seoclsname
          iv_method TYPE seocpdname
          iv_text   TYPE text20
        RAISING
          zcx_aoa.

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
        iv_class_type = p_class
        iv_method     = p_method
        iv_text       = p_text.

  ENDMETHOD.

ENDCLASS.

*********************************************************************
* Main processing class implementation
*********************************************************************
CLASS lcl_main IMPLEMENTATION.

* -------------------------------------------------------------------
* Call instance method with parameters
* -------------------------------------------------------------------
  METHOD call_instance_method.

    DATA:
*     Dynamic method parameter table & work area
      lt_params TYPE abap_parmbind_tab,
      lwa_param TYPE abap_parmbind,
*     Generic error objects
      lo_error  TYPE REF TO cx_root,
      lv_error  TYPE string.

*   Populate method parameter work area:
*   Parameter name for METHOD_4 is IV_INPUT
    lwa_param-name = 'IV_INPUT'.
*   Parameter type is IMPORTING so specify EXPORTING
*   as would be the case for static method call
    lwa_param-kind = cl_abap_objectdescr=>exporting.
*   Value is REFERENCE TO passed IV_TEXT value
    GET REFERENCE OF iv_text INTO lwa_param-value.

*   Add parameter line to table
    INSERT lwa_param INTO TABLE lt_params.

*   Then call the method
    TRY.
        CALL METHOD ir_class->(iv_method)
          PARAMETER-TABLE lt_params.
      CATCH cx_root INTO lo_error.
*       Map any raised exception to standard exception object
        lv_error = lo_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid    = zcx_aoa=>dynamic_error
            long_text = lv_error.
    ENDTRY.

  ENDMETHOD.

* -------------------------------------------------------------------
* Call static method with parameters
* -------------------------------------------------------------------
  METHOD call_static_method.

    DATA:
*     Dynamic method parameter table & work area
      lt_params TYPE abap_parmbind_tab,
      lwa_param TYPE abap_parmbind,
*     Generic error objects
      lo_error  TYPE REF TO cx_root,
      lv_error  TYPE string.

*   Populate method parameter work area:
*   Parameter name for METHOD_4 is IV_INPUT
    lwa_param-name = 'IV_INPUT'.
*   Parameter type is IMPORTING so specify EXPORTING
*   as would be the case for static method call
    lwa_param-kind = cl_abap_objectdescr=>exporting.
*   Value is REFERENCE TO passed IV_TEXT value
    GET REFERENCE OF iv_text INTO lwa_param-value.

*   Add parameter line to table
    INSERT lwa_param INTO TABLE lt_params.

*   Then call the method
    TRY.
        CALL METHOD (iv_class)=>(iv_method)
          PARAMETER-TABLE lt_params.
      CATCH cx_root INTO lo_error.
*       Map any raised exception to standard exception object
        lv_error = lo_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid    = zcx_aoa=>dynamic_error
            long_text = lv_error.
    ENDTRY.

  ENDMETHOD.

* -------------------------------------------------------------------
* Constructor method
* -------------------------------------------------------------------
  METHOD constructor.

*    DATA:
*     Demo class object
*      lo_demo   TYPE REF TO zcl_aoa_demo8i,
*     Method names for dynamic calls
*      lv_method TYPE seocpdname,
*     Generic error objects
*      lo_error  TYPE REF TO cx_root,
*      lv_error  TYPE string.

*   Set dynamic method name
    DATA(lv_method) = CONV seocpdname( iv_method ).

    CASE iv_class_type.

      WHEN mc_cltype_instance.
*        CREATE OBJECT lo_demo.
        DATA(lo_demo) = NEW zcl_aoa_demo8i( ).
        IF iv_method = 'METHOD_4'.
          call_instance_method( ir_class  = lo_demo
                                iv_method = lv_method
                                iv_text   = iv_text ).
        ELSE.
          TRY.
              CALL METHOD lo_demo->(lv_method).
            CATCH cx_root INTO DATA(lo_error).
*             Map any raised exception to standard exception object
              DATA(lv_error) = lo_error->get_text( ).
              RAISE EXCEPTION TYPE zcx_aoa
                EXPORTING
                  textid    = zcx_aoa=>dynamic_error
                  long_text = lv_error.
          ENDTRY.
        ENDIF.

      WHEN mc_cltype_static.
        IF iv_method = 'METHOD_4'.
          call_static_method( iv_class  = mc_class_static
                              iv_method = lv_method
                              iv_text   = iv_text ).
        ELSE.
          TRY.
              CALL METHOD (mc_class_static)=>(lv_method).
            CATCH cx_root INTO lo_error.
*             Map any raised exception to standard exception object
              lv_error = lo_error->get_text( ).
              RAISE EXCEPTION TYPE zcx_aoa
                EXPORTING
                  textid    = zcx_aoa=>dynamic_error
                  long_text = lv_error.
          ENDTRY.
        ENDIF.

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid     = zcx_aoa=>dynamic_error
            short_text = TEXT-e01 && | | && iv_class_type.
*                        --> Invalid class type:

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
