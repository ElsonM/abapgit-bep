*&---------------------------------------------------------------------*
*& Report Z_ABAP_PRESS7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap_press7.

CLASS lcl_animal DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      get_type ABSTRACT RETURNING VALUE(rv_type) TYPE string,
      speak ABSTRACT RETURNING VALUE(rv_message) TYPE string.
ENDCLASS.

CLASS lcl_cat DEFINITION
                INHERITING FROM lcl_animal.
  PUBLIC SECTION.
    METHODS: get_type REDEFINITION,
      speak REDEFINITION.
ENDCLASS.

CLASS lcl_dog DEFINITION
                INHERITING FROM lcl_animal.
  PUBLIC SECTION.
    METHODS: get_type REDEFINITION,
      speak REDEFINITION.
ENDCLASS.

CLASS lcl_see_and_say DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      play IMPORTING io_animal
             TYPE REF TO lcl_animal.
ENDCLASS.

START-OF-SELECTION.
  DATA(lo_cat) = NEW lcl_cat( ).
  DATA(lo_dog) = NEW lcl_dog( ).

  lcl_see_and_say=>play( lo_cat ).
  lcl_see_and_say=>play( lo_dog ).

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_cat
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_cat IMPLEMENTATION.
  METHOD get_type.
    rv_type = 'Cat'.
  ENDMETHOD.

  METHOD speak.
    rv_message = 'Meow'.
  ENDMETHOD.
ENDCLASS.               "lcl_cat

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_dog
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_dog IMPLEMENTATION.
  METHOD get_type.
    rv_type = 'Dog'.
  ENDMETHOD.

  METHOD speak.
    rv_message = 'Bark'.
  ENDMETHOD.
ENDCLASS.               "lcl_dog

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_see_and_say
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_see_and_say IMPLEMENTATION.
  METHOD play.
    DATA(lv_message) =
      |The { io_animal->get_type( ) } | &&
      |says "{ io_animal->speak( ) }".|.
    WRITE: / lv_message.
ENDMETHOD.
ENDCLASS.               "lcl_see_and_say
