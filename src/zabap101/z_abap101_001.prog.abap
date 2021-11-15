*&---------------------------------------------------------------------*
*& Report Z_ABAP101_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_001.

*TYPES customer_name TYPE c LENGTH 10.

DATA: gt_list   TYPE vrm_values.
DATA: gt_values TYPE TABLE OF dynpread.

DATA: gv_selected_value(10) TYPE c.
*--------------------------------------------------------------*
* Selection-Screen
*--------------------------------------------------------------*
PARAMETERS: list TYPE char80 AS LISTBOX VISIBLE LENGTH 20.

*--------------------------------------------------------------*
* At Selection Screen
*--------------------------------------------------------------*
AT SELECTION-SCREEN ON list.

  gt_values = VALUE #( ( fieldname = 'LIST' ) ).

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname             = sy-cprog
      dynumb             = sy-dynnr
      translate_to_upper = 'X'
    TABLES
      dynpfields         = gt_values.

  DATA(gwa_values) = gt_values[ 1 ].

  IF gwa_values-fieldvalue IS NOT INITIAL.
    gv_selected_value = gt_list[ key = gwa_values-fieldvalue ]-text.
  ENDIF.

*--------------------------------------------------------------*
* Initialization
*--------------------------------------------------------------*
INITIALIZATION.

  gt_list = VALUE #(
    ( key = '1' text = 'Product'    )
    ( key = '2' text = 'Collection' )
    ( key = '3' text = 'Color'      )
    ( key = '4' text = 'Size'       ) ).

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'LIST'
      values          = gt_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.

*--------------------------------------------------------------*
* Start of Selection
*--------------------------------------------------------------*
START-OF-SELECTION.

  WRITE:/ gv_selected_value.
