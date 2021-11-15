*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_14.

CLASS cl_constructor_example DEFINITION DEFERRED. "Class is defined in next lines
DATA lo_class TYPE REF TO cl_constructor_example. "Declare class
DATA: wa_makt TYPE makt. "MAKT - work area
DATA: lv_date TYPE sy-datum. "Declare date
PARAMETERS: p_matnr TYPE mara-matnr. "Input material number
PARAMETERS: p_spras TYPE makt-spras. "Input language to pass to constructor

CLASS cl_constructor_example DEFINITION. "Class definition
  PUBLIC SECTION.
    DATA: lv_language TYPE spras.
    CLASS-METHODS: class_constructor. "Class constructor method
    METHODS: constructor "Constructor method
      IMPORTING im_spras TYPE spras.
    METHODS: get_material_descriptions "Method to get material descriptions
      IMPORTING im_matnr TYPE mara-matnr
      EXPORTING ex_makt  TYPE makt.
ENDCLASS.

START-OF-SELECTION.
  CREATE OBJECT lo_class "Create object for class, constructor method will trigger here
    EXPORTING
      im_spras = p_spras.

  CALL METHOD lo_class->get_material_descriptions "Call method to get material descriptions
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_makt  = wa_makt.

  WRITE:/ wa_makt-matnr, wa_makt-maktx, wa_makt-spras. "Print data
  WRITE:/ 'Generated at: ', lv_date.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cl_constructor_example
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_constructor_example IMPLEMENTATION.
  METHOD: constructor.
    lv_language = im_spras.
  ENDMETHOD.
  METHOD: class_constructor.
    lv_date = sy-datum. "Add date using class constructor
  ENDMETHOD.
  METHOD: get_material_descriptions.
    SELECT * FROM makt INTO ex_makt
      WHERE matnr = im_matnr AND spras = lv_language.
    ENDSELECT.
  ENDMETHOD.
ENDCLASS.               "cl_constructor_example
