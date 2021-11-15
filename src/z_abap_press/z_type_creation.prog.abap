*&---------------------------------------------------------------------*
*& Report Z_TYPE_CREATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_type_creation.

PARAMETERS: p_table TYPE string,
            p_where TYPE string.

DATA: r_typedescr   TYPE REF TO cl_abap_typedescr,
      r_structdescr TYPE REF TO cl_abap_structdescr,
      r_tabledescr  TYPE REF TO cl_abap_tabledescr,
      r_table       TYPE REF TO data,
      components    TYPE cl_abap_structdescr=>component_table,
      component     LIKE LINE OF components,
      ro_alv        TYPE REF TO cl_salv_table.

FIELD-SYMBOLS: <table> TYPE ANY TABLE.

START-OF-SELECTION.
  PERFORM get_table.
  PERFORM display_table.

*&------------------------------------------------------------*
*& Form GET_TABLE
*&------------------------------------------------------------*
* text
*-------------------------------------------------------------*
FORM get_table.

  r_typedescr = cl_abap_typedescr=>describe_by_name( p_table ).

  TRY.
      r_structdescr ?= r_typedescr.
    CATCH cx_sy_move_cast_error.
  ENDTRY.

  components = r_structdescr->get_components( ).

  TRY.
      r_structdescr = cl_abap_structdescr=>get( components ).
      r_tabledescr  = cl_abap_tabledescr=>get( r_structdescr ).
    CATCH cx_sy_struct_creation.
    CATCH cx_sy_table_creation .
  ENDTRY.

  TRY.
      CREATE DATA r_table TYPE HANDLE r_tabledescr.
      ASSIGN r_table->* TO <table>.
    CATCH cx_sy_create_data_error.
  ENDTRY.

  TRY.
      SELECT *
        FROM (p_table)
          INTO TABLE <table> WHERE (p_where).
    CATCH cx_sy_sql_error.
  ENDTRY.

ENDFORM.

*&------------------------------------------------------------*
*& Form DISPLAY_TABLE
*&------------------------------------------------------------*
* text
*-------------------------------------------------------------*
FORM display_table.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = ro_alv
        CHANGING
          t_table      = <table>.
    CATCH cx_salv_msg.
  ENDTRY.

  ro_alv->display( ).

ENDFORM.
