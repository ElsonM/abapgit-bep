*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_02.

DATA: lo_material TYPE REF TO zcl_sapn_materials. "class declaration
DATA: wa_mara     TYPE mara. "work area to store material details

PARAMETERS: p_matnr TYPE mara-matnr. "material input

CREATE OBJECT lo_material
  EXPORTING
    im_spras = sy-langu.

* Register event handler method
SET HANDLER lo_material->no_material_handler       FOR lo_material.
SET HANDLER lo_material->no_found_material_handler FOR lo_material.

START-OF-SELECTION.
  CALL METHOD lo_material->get_material_details "call method
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_mara  = wa_mara.
  WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-meins.
