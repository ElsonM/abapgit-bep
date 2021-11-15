*&---------------------------------------------------------------------*
*& Report Z_ABAP101_026
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_026.

DATA: BEGIN OF sbook_with_phone.
        INCLUDE STRUCTURE sbook.
        DATA: phone TYPE scustom-telephone,
      END OF sbook_with_phone.
