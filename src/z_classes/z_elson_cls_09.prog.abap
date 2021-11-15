*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_09.

CLASS cl_attributes DEFINITION DEFERRED.
DATA: lo_attributes TYPE REF TO cl_attributes. "Declare class

CLASS cl_attributes DEFINITION.         "Double click on class name to create implementation
  PUBLIC SECTION.
    DATA: pa_name TYPE char25.          "Public instance attribute
    CLASS-DATA: pa_name_st TYPE char25. "Public static attribute
ENDCLASS.

CREATE OBJECT lo_attributes.         "Create object

lo_attributes->pa_name    = 'ELSON'. "Assign a value to instance attribute
cl_attributes=>pa_name_st = 'MECO'.  "Assign a value to static attributes

*Print attributes via class
WRITE:/ 'INSTANCE ATTRIBUTE: ', lo_attributes->pa_name.
WRITE:/ 'STATIC ATTRIBUTE: ',   cl_attributes=>pa_name_st.

*&---------------------------------------------------------------------*
*&       Class (Implementation)  cl_attributes
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_attributes IMPLEMENTATION.

ENDCLASS.               "cl_attributes
