*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_10.

CLASS cl_methods_example DEFINITION DEFERRED.
DATA: wa_mara TYPE mara.
DATA: wa_makt TYPE makt.
PARAMETERS: p_matnr TYPE mara-matnr.
DATA: lo_material TYPE REF TO cl_methods_example. "Declare class

CLASS cl_methods_example DEFINITION.
  PUBLIC SECTION.
    METHODS: get_material_details
      IMPORTING im_matnr TYPE matnr
      EXPORTING ex_mara  TYPE mara.
    CLASS-METHODS: get_material_description
      IMPORTING im_matnr TYPE matnr
      EXPORTING ex_makt  TYPE makt.
ENDCLASS.

CREATE OBJECT lo_material. "Create object

CALL METHOD lo_material->get_material_details
  EXPORTING
    im_matnr = p_matnr
  IMPORTING
    ex_mara  = wa_mara.

CALL METHOD cl_methods_example=>get_material_description
  EXPORTING
    im_matnr = p_matnr
  IMPORTING
    ex_makt  = wa_makt.

WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-meins, wa_mara-matkl.
WRITE:/ wa_makt-matnr, wa_makt-maktx.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cl_methods_example
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_methods_example IMPLEMENTATION.
  METHOD get_material_details.
    SELECT SINGLE * FROM mara
      INTO ex_mara
      WHERE matnr = im_matnr.
  ENDMETHOD.

  METHOD get_material_description.
    SELECT * FROM makt
      INTO ex_makt
      WHERE matnr = im_matnr
        AND spras = sy-langu.
    ENDSELECT.
  ENDMETHOD.
ENDCLASS.               "cl_methods_example
