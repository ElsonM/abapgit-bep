*&---------------------------------------------------------------------*
*& Include Z12_TABLE_CONTROL_UPLOAD_TOP    " Module Pool
*&                                           Z12_TABLE_CONTROL_UPLOAD
*&---------------------------------------------------------------------*
PROGRAM z12_table_control_upload.

TABLES: lfa1.

TYPES: BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
       END OF ty_lfa1.

DATA: wa_lfa1 TYPE          ty_lfa1,
      it_lfa1 TYPE TABLE OF ty_lfa1.

DATA: ok_code_9000 TYPE sy-ucomm.

CONTROLS tabc_9000 TYPE TABLEVIEW USING SCREEN 9000.
