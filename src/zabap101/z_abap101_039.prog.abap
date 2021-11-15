*&---------------------------------------------------------------------*
*& Report Z_ABAP101_039
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_039.

TYPES: ty_reused_date   TYPE d,
       ty_creation_date TYPE ty_reused_date.

DATA: v_creation_date TYPE ty_reused_date,
      v_update_date   TYPE ty_reused_date.

DATA: BEGIN OF wa_document,
        name          TYPE string,
        creation_date TYPE ty_reused_date,
        update_date   TYPE ty_reused_date,
      END OF wa_document.

DATA: itab_documents LIKE TABLE OF wa_document.

CONSTANTS c_update_date TYPE ty_reused_date VALUE '99991231'.
