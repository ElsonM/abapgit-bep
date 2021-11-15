*&---------------------------------------------------------------------*
*& Report ZELSON
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zelson.


CLASS vehicle DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_name  TYPE string
                                   iv_other TYPE string.
  PROTECTED SECTION.
    DATA: av_name  TYPE string.
    DATA: av_other TYPE string.
ENDCLASS.

CLASS vehicle IMPLEMENTATION.
  METHOD constructor.
    av_name  = iv_name.
    av_other = iv_other.
  ENDMETHOD.
ENDCLASS.

CLASS auto DEFINITION INHERITING FROM vehicle.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING iv_name      TYPE string
                                   iv_max_speed TYPE i
                                   iv_other     TYPE string.
  PRIVATE SECTION.
    DATA: av_max_speed TYPE string.
ENDCLASS.

CLASS auto IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
     EXPORTING
       iv_name  = iv_name
       iv_other = iv_other ).
    av_max_speed = iv_max_speed.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA obj_auto TYPE REF TO auto.
  CREATE OBJECT obj_auto
    EXPORTING
      iv_name      = 'Test'
      iv_max_speed = 15
      iv_other     = 'Test2'.
  BREAK-POINT.
