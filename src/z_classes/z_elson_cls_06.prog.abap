*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_06.

DATA: lo_material TYPE REF TO zcl_sapn_materials. "Declare class

CREATE OBJECT lo_material
  EXPORTING
    im_spras = sy-langu.

WRITE:/ 'Executed through Class Constructor', zcl_sapn_materials=>mat_type.

WRITE:/ 'Executed through Constructor', lo_material->language.
