*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_16
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_16.

CLASS cl_child_class DEFINITION DEFERRED.  "Definition deferred
DATA: lo_child TYPE REF TO cl_child_class. "Declare class
DATA : wa_mara TYPE mara.                  "Declare work area to store mara data
DATA : wa_makt_tmp TYPE makt.              "Declare work area to store makt data
PARAMETERS p_matnr TYPE mara-matnr.        "Parameter input field for material no.

CLASS cl_parent_class DEFINITION.          "Parent class definition not a final class
  PUBLIC SECTION.
    METHODS: get_material_details          "Method to get material details
      IMPORTING im_matnr TYPE mara-matnr
      EXPORTING ex_mara  TYPE mara.
ENDCLASS.

CLASS cl_child_class DEFINITION INHERITING FROM cl_parent_class. "child class using inheritance
  PUBLIC SECTION.
    DATA: wa_makt TYPE makt.                    "attribute for material descriptions
    METHODS: get_material_details REDEFINITION. "we will add additional code
ENDCLASS.

START-OF-SELECTION.
  CREATE OBJECT lo_child. "Create object for child class

  CALL METHOD lo_child->get_material_details "call method to get material details
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_mara  = wa_mara.
  wa_makt_tmp = lo_child->wa_makt. "material descriptions

  WRITE:/ 'Material Details:', wa_mara-matnr, wa_mara-mtart, wa_mara-meins, wa_mara-matkl.
  WRITE:/ 'Material Descriptions:', wa_makt_tmp-matnr, wa_makt_tmp-maktx.

CLASS cl_parent_class IMPLEMENTATION.
  METHOD: get_material_details.
    SELECT SINGLE * FROM mara
      INTO ex_mara
      WHERE matnr = im_matnr.
  ENDMETHOD.
ENDCLASS.               "cl_parent_class

CLASS cl_child_class IMPLEMENTATION.
  METHOD: get_material_details.
    CALL METHOD super->get_material_details
      EXPORTING
        im_matnr = p_matnr
      IMPORTING
        ex_mara  = wa_mara.
    SELECT * FROM makt
      INTO wa_makt
      WHERE matnr = wa_mara-matnr
        AND spras = sy-langu.
    ENDSELECT.
  ENDMETHOD.
ENDCLASS.               "cl_child_class
