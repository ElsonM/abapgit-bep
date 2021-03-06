************************************************************************
* Program:        ZDEMO_ALV_01_74                                      *
* Request ID:     RXXXXXX                                              *
* User ID:        ELSONMECO                                            *
* Date:           01.10.2017                                           *
* Description:    -                                                    *
************************************************************************
REPORT zdemo_alv_01_74.

************************************************************************
* CLASSES                                                              *
************************************************************************
CLASS cl_custom_alv DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.
    METHODS display.

  PRIVATE SECTION.
    DATA alv                  TYPE REF TO            cl_salv_table.
    DATA data_to_be_displayed TYPE STANDARD TABLE OF spfli.

    METHODS get_data_to_be_displayed.
    METHODS initialize_alv.
    METHODS customize_alv.
    METHODS enable_layout_settings.
    METHODS optimize_column_width.
    METHODS hide_client_column.
    METHODS set_departure_country_column.
    METHODS set_toolbar.
    METHODS display_settings.
    METHODS set_aggregations.
ENDCLASS.

CLASS cl_custom_alv IMPLEMENTATION.
  METHOD constructor.
    get_data_to_be_displayed( ).
    initialize_alv( ).
    customize_alv( ).
  ENDMETHOD.

  METHOD get_data_to_be_displayed.
    SELECT * FROM spfli INTO TABLE data_to_be_displayed.
  ENDMETHOD.

  METHOD initialize_alv.
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = alv
          CHANGING
            t_table = data_to_be_displayed ).
      CATCH cx_salv_msg INTO DATA(message).
        "Error handling
    ENDTRY.
  ENDMETHOD.

  METHOD customize_alv.
    enable_layout_settings( ).
    optimize_column_width( ).
    hide_client_column( ).
    set_departure_country_column( ).
    set_toolbar( ).
    display_settings( ).
    set_aggregations( ).
  ENDMETHOD.

  METHOD enable_layout_settings.
    DATA layout_settings TYPE REF TO cl_salv_layout.
    DATA layout_key      TYPE        salv_s_layout_key.

    layout_settings = alv->get_layout( ).

    layout_key-report = sy-repid.
    layout_settings->set_key( layout_key ).

    layout_settings->set_save_restriction( if_salv_c_layout=>restrict_none ).
    layout_settings->set_default( if_salv_c_bool_sap=>true ).
  ENDMETHOD.

  METHOD optimize_column_width.
    alv->get_columns( )->set_optimize( ).
  ENDMETHOD.

  METHOD hide_client_column.
    TRY.
        alv->get_columns( )->get_column( 'MANDT' )->set_visible( if_salv_c_bool_sap=>false ).
      CATCH cx_salv_not_found INTO DATA(not_found).
        "Error handling
    ENDTRY.
  ENDMETHOD.

  METHOD set_departure_country_column.
    TRY.
        DATA(column) = alv->get_columns( )->get_column( 'COUNTRYFR' ).
        column->set_short_text( 'D. Country' ).
        column->set_medium_text( 'Dep. Country' ).
        column->set_long_text( 'Departure Country' ).
      CATCH cx_salv_not_found INTO DATA(not_found).
        "Error handling
    ENDTRY.
  ENDMETHOD.

  METHOD set_toolbar.
    alv->get_functions( )->set_all( ).
  ENDMETHOD.

  METHOD display_settings.
    DATA(display_settings) = alv->get_display_settings( ).

    display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
    display_settings->set_list_header( 'Flight Schedule' ).
  ENDMETHOD.

  METHOD set_aggregations.
    DATA(aggregations) = alv->get_aggregations( ).

    TRY.
        aggregations->add_aggregation(
        columnname = 'FLTIME'
        aggregation = if_salv_c_aggregation=>maximum ).
      CATCH cx_salv_data_error INTO DATA(data_error).
        "Error handling
      CATCH cx_salv_not_found  INTO DATA(not_found).
        "Error handling
      CATCH cx_salv_existing   INTO DATA(existing).
        "Error handling
    ENDTRY.

    aggregations->set_aggregation_before_items( ).
  ENDMETHOD.

  METHOD display.
    alv->display( ).
  ENDMETHOD.
ENDCLASS.
************************************************************************
* CLASSES - END                                                        *
************************************************************************

************************************************************************
* MAIN PROGRAM                                                         *
************************************************************************
START-OF-SELECTION.

  DATA(custom_alv) = NEW cl_custom_alv( ).
  custom_alv->display( ).

*  NEW cl_custom_alv( )->display( ). "No object reference
************************************************************************
* MAIN PROGRAM - END                                                   *
************************************************************************
