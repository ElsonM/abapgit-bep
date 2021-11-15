*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_07.

DATA: lo_class TYPE REF TO zcl_sapn_class_ex. "Declare class

DATA: wa_mara TYPE mara, "MARA declaration
      wa_makt TYPE makt. "MAKT declaration

PARAMETERS p_matnr TYPE mara-matnr.

CREATE OBJECT lo_class. "Create object for the class

START-OF-SELECTION.

  CALL METHOD lo_class->get_material_details "alias name
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_mara  = wa_mara.

  CALL METHOD lo_class->get_material_descriptions "alias name
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_makt = wa_makt.

  WRITE:/ 'Material Details - ' COLOR 5, wa_mara-matnr, wa_mara-mtart, wa_mara-mbrsh, wa_mara-matkl.
  WRITE:/ 'Material Descriptions - ' COLOR 6, wa_makt-matnr, wa_makt-maktx, wa_makt-spras.
