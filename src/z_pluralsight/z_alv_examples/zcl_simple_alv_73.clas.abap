CLASS zcl_simple_alv_73 DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        !title               TYPE string OPTIONAL
        !fields_to_be_hidden TYPE string OPTIONAL.
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
    DATA _alv_object          TYPE REF TO cl_salv_table.

    METHODS customize_alv
      RAISING
        cx_salv_not_found.
    METHODS hide_columns
      RAISING
        cx_salv_not_found.
    METHODS optimize_column_width.
    METHODS set_toolbar.
    METHODS set_zebra_mode_and_title.

ENDCLASS.



CLASS ZCL_SIMPLE_ALV_73 IMPLEMENTATION.


  METHOD constructor.
    _title               = title.
    _fields_to_be_hidden = fields_to_be_hidden.
  ENDMETHOD.                    "CONSTRUCTOR


  METHOD customize_alv.
    set_toolbar( ).
    optimize_column_width( ).
    set_zebra_mode_and_title( ).
    hide_columns( ).
  ENDMETHOD.                    "customize_alv


  METHOD display.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = _alv_object
      CHANGING
        t_table = data_to_be_displayed
    ).
    customize_alv( ).
    _alv_object->display( ).
  ENDMETHOD.                    "display


  METHOD hide_columns.
    DATA fields_to_be_hidden_list TYPE TABLE OF string.                  " In 7.3 you do not have Inline Declaration
    DATA field_to_be_hidden       LIKE LINE OF fields_to_be_hidden_list. " In 7.3 you do not have Inline Declaration
    DATA field_name_char30        TYPE lvc_fname.                        " In 7.3 you do not have Inline Declaration

    SPLIT _fields_to_be_hidden AT ';' INTO TABLE fields_to_be_hidden_list.

    LOOP AT fields_to_be_hidden_list INTO field_to_be_hidden.
      field_name_char30 = field_to_be_hidden. " Instead of CONV operator you have to convert it manually
      _alv_object->get_columns( )->get_column( field_name_char30 )->set_visible( abap_false ).
    ENDLOOP.
  ENDMETHOD.                    "HIDE_COLUMNS


  METHOD optimize_column_width.
    _alv_object->get_columns( )->set_optimize( ).
  ENDMETHOD.                    "OPTIMIZE_COLUMN_WIDTH


  METHOD set_toolbar.
    _alv_object->get_functions( )->set_all( ).
  ENDMETHOD.                    "SET_TOOLBAR


  METHOD set_zebra_mode_and_title.
    DATA title_of_alv_char70 TYPE lvc_title. " In 7.3 you do not have Inline Declaration

    title_of_alv_char70 = _title. " Instead of CONV operator you have to convert it manually

    _alv_object->get_display_settings( )->set_striped_pattern( abap_true ).
    _alv_object->get_display_settings( )->set_list_header( title_of_alv_char70 ).
  ENDMETHOD.                    "SET_ZEBRA_MODE_AND_TITLE
ENDCLASS.
