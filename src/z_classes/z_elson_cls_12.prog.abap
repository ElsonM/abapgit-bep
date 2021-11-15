*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_12.
CLASS cl_userdefined_types DEFINITION DEFERRED.

PARAMETERS: p_mtart TYPE mara-mtart.
DATA: lo_material TYPE REF TO cl_userdefined_types. "Declare class
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         meins TYPE mara-meins,
         matkl TYPE mara-matkl,
       END OF ty_mara.
TYPES: tt_mara TYPE TABLE OF ty_mara.
DATA: it_mara TYPE TABLE OF ty_mara.
DATA: wa_mara TYPE ty_mara.

CLASS cl_userdefined_types DEFINITION.
  PUBLIC SECTION.
    METHODS : get_materials_for_type
      IMPORTING im_mtart TYPE mara-mtart
      EXPORTING et_mara  TYPE tt_mara.
ENDCLASS.

CREATE OBJECT lo_material. "Create object
CALL METHOD lo_material->get_materials_for_type
  EXPORTING
    im_mtart = p_mtart
  IMPORTING
    et_mara  = it_mara.

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
    SELECT matnr mtart meins matkl FROM mara
           INTO TABLE et_mara
           WHERE mtart = im_mtart.
  ENDMETHOD.
ENDCLASS.               "cl_userdefined_types
