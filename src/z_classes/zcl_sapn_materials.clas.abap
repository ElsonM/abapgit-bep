
CLASS zcl_sapn_materials DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_mara,
        matnr TYPE mara-matnr,
        ersda TYPE mara-ersda,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
        meins TYPE mara-meins,
      END OF ty_mara.
    TYPES:
      tt_mara TYPE TABLE OF ty_mara.

    DATA       language TYPE spras.
    CLASS-DATA mat_type TYPE mtart.

    EVENTS no_material.
    EVENTS no_found_material.

    METHODS get_material_details
      IMPORTING
        !im_matnr TYPE mara-matnr
      EXPORTING
        !ex_mara  TYPE mara.
    METHODS get_materials_for_type
      IMPORTING
        !im_mtart TYPE mara-mtart
      EXPORTING
        !et_mara  TYPE zsapn_mara.
    METHODS get_materials_for_date
      IMPORTING
        !im_date TYPE mara-ersda
      EXPORTING
        !et_mara TYPE tt_mara.
    METHODS no_material_handler
        FOR EVENT no_material OF zcl_sapn_materials.
    METHODS no_found_material_handler
        FOR EVENT no_found_material OF zcl_sapn_materials.
    METHODS constructor
      IMPORTING
        !im_spras TYPE makt-spras.
    METHODS get_material_description
      IMPORTING
        !im_matnr TYPE mara-matnr
      EXPORTING
        !ex_makt  TYPE makt.
    CLASS-METHODS class_constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SAPN_MATERIALS IMPLEMENTATION.


  METHOD class_constructor.
* Set default material type as FERT
    mat_type = 'FERT'.
  ENDMETHOD.


  METHOD constructor.
    language = im_spras.
  ENDMETHOD.


  METHOD get_materials_for_date.
* Get material no, created date, material type, material group, units of measure
* from MARA table
    SELECT matnr ersda mtart matkl meins
      FROM mara INTO TABLE et_mara
      WHERE ersda = im_date.
  ENDMETHOD.


  METHOD get_materials_for_type.

* Get data from MARA for a material type MTART
    SELECT * FROM mara
      INTO TABLE et_mara
      WHERE mtart = im_mtart.
  ENDMETHOD.


  METHOD get_material_description.
    SELECT * FROM makt INTO ex_makt
      WHERE matnr = im_matnr
        AND spras = language. "Language is the attribute defined in method
    ENDSELECT.
  ENDMETHOD.


  METHOD get_material_details.

* Select material data from MARA table into exporting parameter EX_MARA
* (work area) for a material no - IM_MATNR
    IF im_matnr IS INITIAL.
      RAISE EVENT no_material.
    ELSE.
      SELECT SINGLE * FROM mara
        INTO ex_mara
        WHERE matnr = im_matnr.
      IF sy-subrc <> 0.
        RAISE EVENT no_found_material.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD no_found_material_handler.

    WRITE:/ 'No material found'.
  ENDMETHOD.


  METHOD no_material_handler.

    WRITE:/ 'No material entered'.
  ENDMETHOD.
ENDCLASS.
