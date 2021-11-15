CLASS zcl_simple_alv_74 DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        !title                TYPE string OPTIONAL
        !fields_to_be_hidden  TYPE string OPTIONAL.
    METHODS display
      CHANGING
        !data_to_be_displayed TYPE ANY TABLE
      RAISING
        cx_salv_msg
        cx_salv_not_found.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA _title               TYPE string.
    DATA _fields_to_be_hidden TYPE string.
    DATA _alv_object          TYPE REF TO cl_salv_table .

    METHODS customize_alv
      RAISING
        cx_salv_not_found.
    METHODS hide_columns
      EXCEPTIONS
        cx_salv_not_found.
    METHODS optimize_column_width.
    METHODS set_toolbar.
    METHODS set_zebra_mode_and_title.

ENDCLASS.



CLASS ZCL_SIMPLE_ALV_74 IMPLEMENTATION.


  METHOD constructor.
    _title               = title.
    _fields_to_be_hidden = fields_to_be_hidden.
  ENDMETHOD.


  METHOD customize_alv.
    set_toolbar( ).
    optimize_column_width( ).
    set_zebra_mode_and_title( ).
    hide_columns( ).
  ENDMETHOD.


  METHOD display.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = _alv_object
      CHANGING
        t_table = data_to_be_displayed
    ).
    customize_alv( ).
    _alv_object->display( ).
  ENDMETHOD.


  METHOD hide_columns.
    SPLIT _fields_to_be_hidden AT ';' INTO TABLE DATA(fields_to_be_hidden_list).

    LOOP AT fields_to_be_hidden_list INTO DATA(field_to_be_hidden).
      _alv_object->get_columns( )->get_column( CONV #( field_to_be_hidden ) )->set_visible( abap_false ).
    ENDLOOP.

  ENDMETHOD.


  METHOD optimize_column_width.
    _alv_object->get_columns( )->set_optimize( ).
  ENDMETHOD.


  METHOD set_toolbar.
    _alv_object->get_functions( )->set_all( ).
  ENDMETHOD.


  METHOD set_zebra_mode_and_title.
    _alv_object->get_display_settings( )->set_striped_pattern( abap_true ).
    _alv_object->get_display_settings( )->set_list_header( CONV #( _title ) ).
  ENDMETHOD.
ENDCLASS.
