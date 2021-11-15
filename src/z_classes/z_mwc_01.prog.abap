*&---------------------------------------------------------------------*
*& Report Z_MWC_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mwc_01.

* Create selection screen class
CLASS cl_sel DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES: ty_vbeln TYPE RANGE OF vbeln.
    DATA: s_vbeln TYPE ty_vbeln,
          s_werks TYPE werks_ext.
    METHODS: get_screen IMPORTING lp_werks TYPE werks_ext
                                  ls_vbeln TYPE ty_vbeln.
ENDCLASS.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cl_sel
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_sel IMPLEMENTATION.
  METHOD get_screen.
    me->s_werks = lp_werks.
    me->s_vbeln = ls_vbeln[].
  ENDMETHOD.
ENDCLASS.               "cl_sel

* Create DATA MODEL to  fetch  recordes
CLASS cl_fetch DEFINITION.
  PUBLIC SECTION.
    DATA: sel_obj TYPE REF TO cl_sel,
          it_vbap TYPE STANDARD TABLE OF vbap.
    METHODS: constructor IMPORTING ref_sel TYPE REF TO cl_sel,
      fetch_data.
ENDCLASS.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cl_fetch
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_fetch IMPLEMENTATION.
  METHOD constructor.
    me->sel_obj = ref_sel.
  ENDMETHOD.
  METHOD fetch_data.
    SELECT * FROM vbap INTO TABLE me->it_vbap UP TO 10 ROWS
      WHERE vbeln IN me->sel_obj->s_vbeln
        AND werks EQ me->sel_obj->s_werks.
  ENDMETHOD.
ENDCLASS.               "cl_fetch

* Display data class
CLASS cl_alv DEFINITION.
  PUBLIC SECTION.
    DATA: fetch_obj TYPE REF TO cl_fetch.
    METHODS: constructor IMPORTING ref_fetch TYPE REF TO cl_fetch,
      display_alv.
ENDCLASS.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cl_alv
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_alv IMPLEMENTATION.
  METHOD constructor.
    me->fetch_obj = ref_fetch.
  ENDMETHOD.
  METHOD display_alv.
    DATA: lx_msg TYPE REF TO cx_salv_msg,
          o_alv  TYPE REF TO cl_salv_table.
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = o_alv
          CHANGING
            t_table      = me->fetch_obj->it_vbap ).
      CATCH cx_salv_msg INTO lx_msg.
    ENDTRY.
    o_alv->display( ).
  ENDMETHOD.
ENDCLASS.               "cl_alv


DATA: lv_vbeln TYPE vbap-vbeln.

* Create selection screen
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS:     p_werks  TYPE vbap-werks OBLIGATORY.
SELECT-OPTIONS: s_vbeln1 FOR  lv_vbeln .
SELECTION-SCREEN END OF BLOCK b1.

* Declare TYPE REF TO class objects
DATA: o_sel     TYPE REF TO cl_sel,
      o_fetch   TYPE REF TO cl_fetch,
      o_display TYPE REF TO cl_alv.

INITIALIZATION .
* Creating Objects of the Class
  CREATE OBJECT: o_sel,
                 o_fetch   EXPORTING ref_sel = o_sel,     " ref_sel is in Constructor
                 o_display EXPORTING ref_fetch = o_fetch. " ref_fetch is in Constructor

START-OF-SELECTION .
* Import screen data to class screen
  o_sel->get_screen( EXPORTING lp_werks = p_werks ls_vbeln = s_vbeln1[] ) .

* Call fetch data to fetch the records
  o_fetch->fetch_data( ).

END-OF-SELECTION .
* Display data
  o_display->display_alv( ).
