*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_15.

CLASS cl_class DEFINITION DEFERRED.
DATA lo_class TYPE REF TO cl_class.
DATA: wa_mara TYPE mara,
      wa_makt TYPE makt.
PARAMETERS: p_matnr TYPE mara-matnr.

INTERFACE cl_interface.
  METHODS: get_material_details
    IMPORTING im_matnr TYPE mara-matnr
    EXPORTING ex_mara  TYPE mara.
  METHODS: get_material_descriptions
    IMPORTING im_matnr TYPE mara-matnr
    EXPORTING ex_makt  TYPE makt.
ENDINTERFACE.

CLASS cl_class DEFINITION.
  PUBLIC SECTION.
    INTERFACES cl_interface.
ENDCLASS.

START-OF-SELECTION.
  CREATE OBJECT lo_class.

  CALL METHOD lo_class->cl_interface~get_material_details
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_mara  = wa_mara.

  CALL METHOD lo_class->cl_interface~get_material_descriptions
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_makt  = wa_makt.

  WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-meins, wa_mara-matkl.
  WRITE:/ wa_makt-matnr, wa_makt-maktx.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cl_class
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_class IMPLEMENTATION.
  METHOD cl_interface~get_material_details.
    SELECT SINGLE * FROM mara
      INTO ex_mara
      WHERE matnr = im_matnr.
  ENDMETHOD.

  METHOD cl_interface~get_material_descriptions.
    SELECT * FROM makt
      INTO ex_makt WHERE matnr = im_matnr AND spras = sy-langu.
    ENDSELECT.
  ENDMETHOD.
ENDCLASS.               "cl_class
