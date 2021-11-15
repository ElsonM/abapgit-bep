INTERFACE zif_comparable PUBLIC.

  CONSTANTS co_equal_to     TYPE i VALUE 0.      "#EC NOTEXT
  CONSTANTS co_less_than    TYPE i VALUE -1.     "#EC NOTEXT
  CONSTANTS co_greater_than TYPE i VALUE 1.      "#EC NOTEXT

  METHODS compare_to
    IMPORTING
      !io_object       TYPE REF TO object
    RETURNING
      VALUE(rv_result) TYPE i .

ENDINTERFACE.
