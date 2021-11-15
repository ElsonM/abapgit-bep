*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_24.

DATA: lo_class TYPE REF TO zcl_sapn_singleton.

* CREATE OBJECT lo_class. "Is not allowed

lo_class = zcl_sapn_singleton=>instantiate( ).
