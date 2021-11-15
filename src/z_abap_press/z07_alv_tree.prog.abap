*&---------------------------------------------------------------------*
*& Report Z07_ALV_TREE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_alv_tree.

DATA: it_sflight TYPE STANDARD TABLE OF sflight,
      it_outtab  LIKE it_sflight,
      wa_sflight TYPE sflight.

DATA: lo_tree TYPE REF TO cl_salv_tree.

DATA: nodes        TYPE REF TO cl_salv_nodes,
      node         TYPE REF TO cl_salv_node,
      columns      TYPE REF TO cl_salv_columns,
      lo_functions TYPE REF TO cl_salv_functions_tree,

      key          TYPE salv_de_node_key.

SELECT-OPTIONS s_carrid FOR wa_sflight-carrid.

* Select data
SELECT * FROM sflight
  INTO TABLE it_sflight
  WHERE carrid IN s_carrid.

*SORT it_sflight BY carrid DESCENDING. "Sort in Tree Display is ASC

* Create instance with an empty table
CALL METHOD cl_salv_tree=>factory
  IMPORTING
    r_salv_tree = lo_tree
  CHANGING
    t_table     = it_outtab.

* Add the nodes to the tree
nodes = lo_tree->get_nodes( ).

LOOP AT it_sflight INTO wa_sflight.
  ON CHANGE OF wa_sflight-carrid.
    CLEAR key.
    TRY.
        node = nodes->add_node( related_node = key
                                relationship = cl_gui_column_tree=>relat_first_child
                                data_row     = wa_sflight ).
        key = node->get_key( ).
      CATCH cx_salv_msg.
    ENDTRY.
  ENDON.
  TRY.
      node = nodes->add_node( related_node = key
                              relationship = cl_gui_column_tree=>relat_last_child
                              data_row     = wa_sflight ).
    CATCH cx_salv_msg.
  ENDTRY.
ENDLOOP.

columns = lo_tree->get_columns( ).
columns->set_optimize( abap_true ).

*Set default status
lo_functions = lo_tree->get_functions( ).
lo_functions->set_all( abap_true ).

*Display table
lo_tree->display( ).
