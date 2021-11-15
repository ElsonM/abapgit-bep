*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_ELSON_CLS_05.

DATA: lo_material TYPE REF TO zcl_sapn_materials, "Declare class
      wa_makt TYPE makt. "Declare work area for makt

PARAMETERS: p_matnr TYPE mara-matnr. "material input

CREATE OBJECT lo_material
  EXPORTING
    im_spras = sy-langu.

START-OF-SELECTION.
  CALL METHOD lo_material->get_material_description
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_makt = wa_makt.

  WRITE: wa_makt-matnr, wa_makt-maktx.
