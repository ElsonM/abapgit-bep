*&---------------------------------------------------------------------*
*& Report Z_ABAP101_030
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_030.

TYPES: BEGIN OF ty_scarr_telephone.
         INCLUDE TYPE scarr.
         TYPES: phone TYPE scustom-telephone,
       END OF ty_scarr_telephone.

TYPES ty_itab_scarr_telephone TYPE SORTED TABLE OF ty_scarr_telephone
  WITH UNIQUE KEY carrid.

DATA itab TYPE ty_itab_scarr_telephone.
