*&---------------------------------------------------------------------*
*& Report Z_COMP_ABAP_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_comp_abap_2.

*CLASS cl_person DEFINITION.
*  PUBLIC SECTION.
*    CLASS-DATA height TYPE i. "Static attribute
*    DATA weight TYPE i.       "Instance attribute
*
*    CLASS-METHODS class_constructor. "Static Constructor
*    METHODS constructor              "Instance constructor
*      IMPORTING name TYPE char20.
*
*    CLASS-METHODS set_height              "Static Method
*      IMPORTING height TYPE i.
*    METHODS get_bmi EXPORTING bmi TYPE i. "Instance method
*
*ENDCLASS.
*CLASS cl_person IMPLEMENTATION.
*  METHOD class_constructor.
*    WRITE / 'Static constructor'.
*  ENDMETHOD.
*
*  METHOD constructor.
*    WRITE / 'Instance constructor'.
*  ENDMETHOD.
*
*  METHOD set_height.
*  ENDMETHOD.
*
*  METHOD get_bmi.
*    bmi = me->height / me->weight.
*  ENDMETHOD.
*ENDCLASS.
*
*START-OF-SELECTION.
**Accessing static attributes and methods using the selector "=>"
**with class reference
*  cl_person=>height = 165.
*  cl_person=>set_height( height = 165 ).
*
**Instantiating the reference object and accessing the instance
**attributes and methods using the selector "->" with object
**reference.
*  DATA(oref) = NEW cl_person( name = 'JOHN' ).
*  oref->weight = 50.
*  oref->get_bmi(
*    IMPORTING
*      bmi = DATA(v_bmi) ).
*  WRITE v_bmi.

DATA: v_unit_value  TYPE i,
      v_total_value TYPE i VALUE 20,
      v_quantity    TYPE i.

DATA r_ex TYPE REF TO cx_root.
TRY.    "Begin of TRY block

    v_unit_value = v_total_value / v_quantity.
*   Other programming logic goes here
  CATCH cx_sy_zerodivide INTO r_ex.
    WRITE: / 'Error Short Text:', r_ex->get_text( ).
    WRITE: / 'Error long Text:', r_ex->get_longtext( ).
  CLEANUP.
*   Any cleanup logic goes here

ENDTRY. "End of TRY block
