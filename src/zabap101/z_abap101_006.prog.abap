*&---------------------------------------------------------------------*
*& Report Z_ABAP101_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_006.

TYPES customer_name             TYPE c LENGTH 10.
DATA  number_of_employees       TYPE i.
TYPES number_of_unpaid_invoices TYPE n LENGTH 7.
TYPES creation_date             TYPE d.
TYPES last_changed_at           TYPE t.

TYPES: BEGIN OF customer_structure,
         name            TYPE customer_name,
         n_employees     LIKE number_of_employees,
         unpaid_invoices TYPE number_of_unpaid_invoices,
         creation_date   TYPE d,
         last_changed_at TYPE t,
       END OF customer_structure.
