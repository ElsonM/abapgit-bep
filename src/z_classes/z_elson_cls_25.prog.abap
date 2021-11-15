*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_25
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_25.

CLASS cl_singleton DEFINITION DEFERRED.

DATA: it_mara  TYPE TABLE OF mara,
      wa_mara  TYPE          mara.

DATA: lo_class TYPE REF TO   cl_singleton.

CLASS cl_singleton DEFINITION CREATE PRIVATE.                                     "Create a private class
  PUBLIC SECTION.
    METHODS:       get_mara.                                                      "Actual method get mara
    CLASS-METHODS: instantiate RETURNING VALUE(lr_inst) TYPE REF TO cl_singleton. "Create a static method
  PRIVATE SECTION.
    CLASS-DATA:    lr_inst                              TYPE REF TO cl_singleton. "Private variable
ENDCLASS.

lo_class = cl_singleton=>instantiate( ). "Get instance of class
lo_class->get_mara( ).                   "Get mara data

CLASS cl_singleton IMPLEMENTATION.
  METHOD get_mara.
    SELECT * FROM mara INTO TABLE it_mara UP TO 50 ROWS.
    LOOP AT it_mara INTO wa_mara.
      WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-meins, wa_mara-matkl.
    ENDLOOP.
  ENDMETHOD.
  METHOD instantiate.
    IF lr_inst IS INITIAL.
      CREATE OBJECT lr_inst. "Create object
    ENDIF.
  ENDMETHOD.

ENDCLASS.
