*&---------------------------------------------------------------------*
*& Report ZDEMO_CLASS_EXAMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_class_example.

CLASS cl_person DEFINITION.
  PUBLIC SECTION.
    TYPES ty_packed TYPE p LENGTH 4 DECIMALS 2.
    METHODS set_height IMPORTING im_height TYPE ty_packed.
    METHODS set_weight IMPORTING im_weight TYPE ty_packed.
    METHODS set_bmi.
    METHODS get_bmi RETURNING VALUE(r_bmi) TYPE ty_packed.

  PRIVATE SECTION.
    DATA: bmi    TYPE i,
          height TYPE i,
          weight TYPE i.
ENDCLASS.

CLASS cl_person IMPLEMENTATION.
  METHOD set_height.
    height = im_height.
  ENDMETHOD.

  METHOD set_weight.
    weight = im_weight.
  ENDMETHOD.

  METHOD set_bmi.
    bmi = height / weight.
  ENDMETHOD.

  METHOD get_bmi.
    r_bmi = bmi.
  ENDMETHOD.
ENDCLASS.

DATA john TYPE REF TO cl_person.
DATA mark TYPE REF TO cl_person.

START-OF-SELECTION.
  CREATE OBJECT john.
  john->set_height( EXPORTING im_height = 165 ).
  john->set_weight( EXPORTING im_weight = 50 ).
  john->set_bmi( ).
  WRITE :/'John’s BMI is', john->get_bmi( ).

  CREATE OBJECT mark.
  mark->set_height( EXPORTING im_height = 175 ).
  mark->set_weight( EXPORTING im_weight = 80 ).
  mark->set_bmi( ).
  WRITE :/'Mark’s BMI is', mark->get_bmi( ).

  IF john->get_bmi( ) GT mark->get_bmi( ).
    WRITE :/'John is fatter than Mark'.
  ELSE.
    WRITE :/'Mark is fatter than John'.
  ENDIF.
