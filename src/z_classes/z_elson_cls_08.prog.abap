*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_08.

DATA: lo_class TYPE REF TO zcl_sapn_childclass. "Declare class

DATA: wa_mara TYPE mara, "Declare MARA
      wa_makt TYPE makt. "Declare MAKT

PARAMETERS p_matnr TYPE mara-matnr. "Material input

CREATE OBJECT lo_class. "Create instance for class

*DATA(lo_class) = NEW zcl_sapn_childclass( ).

START-OF-SELECTION.
  CALL METHOD lo_class->get_materials_details "Get material details
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_mara  = wa_mara.

  wa_makt = lo_class->ls_makt. "Access material description from class attribute

  WRITE:/ WA_MARA-MATNR, WA_MARA-MTART, WA_MARA-MEINS, WA_MARA-MATKL. "Print material details
  WRITE:/ WA_MAKT-MATNR, WA_MAKT-MAKTX.                               "Print material descriptions
