*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_03.

DATA: it_mara      TYPE TABLE OF mara,               "internal table to store materials
      wa_mara      TYPE          mara,               "work area for materials to loop
      lo_materials TYPE REF TO   zcl_sapn_materials. "declare materials class

PARAMETERS: p_mtart TYPE mara-mtart. "material type input

CREATE OBJECT lo_materials "Create object for materials class
  EXPORTING
    im_spras = sy-langu.

START-OF-SELECTION.
  CALL METHOD lo_materials->get_materials_for_type "call method to get materials
    EXPORTING
      im_mtart = p_mtart
    IMPORTING
      et_mara = it_mara.

  LOOP AT it_mara INTO wa_mara.
    WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-meins.
  ENDLOOP.
