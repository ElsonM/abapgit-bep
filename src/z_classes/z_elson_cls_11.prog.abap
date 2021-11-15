*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_11.
CLASS cl_userdefined_types DEFINITION DEFERRED.

PARAMETERS: p_mtart TYPE mara-mtart.

DATA: lo_material TYPE REF TO   cl_userdefined_types. "Declare class
DATA: it_mara     TYPE TABLE OF mara.
DATA: wa_mara     TYPE          mara.

CLASS cl_userdefined_types DEFINITION.
  PUBLIC SECTION.
    METHODS: get_materials_for_type
      IMPORTING im_mtart TYPE mara-mtart
      EXPORTING et_mara  TYPE zsapn_mara. "Table type in SE11
ENDCLASS.

CREATE OBJECT lo_material. "Create object
CALL METHOD lo_material->get_materials_for_type
  EXPORTING
    im_mtart = p_mtart
  IMPORTING
    et_mara  = it_mara.

*Print output
LOOP AT it_mara INTO wa_mara.
  WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-meins, wa_mara-matkl.
ENDLOOP.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cl_userdefined_types
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_userdefined_types IMPLEMENTATION.
  METHOD get_materials_for_type.
    SELECT * FROM mara
      INTO TABLE et_mara
      WHERE mtart = im_mtart.
  ENDMETHOD.
ENDCLASS.               "cl_userdefined_types
