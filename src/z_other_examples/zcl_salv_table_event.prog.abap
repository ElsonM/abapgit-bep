*&---------------------------------------------------------------------*
*& Report ZCL_SALV_TABLE_EVENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcl_salv_table_event.

CLASS lcl_event_handle DEFINITION.
  PUBLIC SECTION.
    METHODS: hndl_double_click FOR EVENT double_click
               OF cl_salv_events_table
      IMPORTING row
                column.
ENDCLASS.

CLASS lcl_event_handle IMPLEMENTATION.
  METHOD hndl_double_click.
    MESSAGE  'Row clicked.' TYPE 'I' .
  ENDMETHOD.
ENDCLASS.

CLASS lcl_salv_tab DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: main IMPORTING
                          i_list   TYPE xfeld
                          i_grid   TYPE xfeld
                          i_alv_tb TYPE c,
      fetch_records,
      get_alv_instance IMPORTING
                         i_list   TYPE xfeld
                         i_grid   TYPE xfeld
                         i_alv_tb TYPE c,

      display_alv.
  PRIVATE SECTION.
    TYPE-POOLS : icon, sym.
    TYPES : BEGIN OF ty_flight,
              status TYPE c LENGTH 1,
              icon   TYPE icon_d, " char - 4
              symbol TYPE icon_d. " char - 4
        INCLUDE TYPE sflight.
    TYPES : END OF ty_flight.

    CLASS-DATA : lt          TYPE TABLE OF ty_flight,
                 ls          TYPE ty_flight,
                 lo_salv_tab TYPE REF TO cl_salv_table,
                 lo_func     TYPE REF TO cl_salv_functions_list,
                 lo_cols     TYPE REF TO cl_salv_columns_table,
                 lo_col      TYPE REF TO cl_salv_column,

                 lo_col_icon TYPE REF TO cl_salv_column,
                 lo_icon     TYPE REF TO cl_salv_column_table,

                 lo_col_sym  TYPE REF TO cl_salv_column,
                 lo_symbol   TYPE REF TO cl_salv_column_table,

                 rem_seat    TYPE i,
                 lt_icon     TYPE TABLE OF icon,
                 ls_icon     TYPE icon,

                 lo_event    TYPE REF TO cl_salv_events_table,
                 lo_handle   TYPE REF TO lcl_event_handle.

ENDCLASS.


CLASS lcl_salv_tab IMPLEMENTATION.
  METHOD main.
    fetch_records( ).
    CREATE OBJECT lo_handle.
    get_alv_instance( EXPORTING  i_list     = i_list
                                                        i_grid     = i_grid
                                                        i_alv_tb   = i_alv_tb ).

    CALL METHOD lo_salv_tab->get_event
      RECEIVING
        value = lo_event.    "Get all the Events of the table
    SET HANDLER lo_handle->hndl_double_click FOR lo_event.

    display_alv( ).

  ENDMETHOD.

  METHOD fetch_records.
    DATA indx TYPE sy-tabix.
    DATA line  TYPE i.
    SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE lt UP TO 40 ROWS.
    line = lines( lt ).
    SELECT * FROM icon INTO TABLE lt_icon UP TO line ROWS.

    LOOP AT  lt INTO ls.
      indx = sy-tabix.
      rem_seat = ls-seatsmax_b - ls-seatsocc_b.
      IF  rem_seat = 0.
        ls-status = 1 .
      ELSEIF rem_seat LE 10.
        ls-status = 2.
      ELSE.
        ls-status = 3.
      ENDIF.
      ls-symbol = sym_caution.

      READ TABLE lt_icon INTO ls_icon INDEX indx .
      IF sy-subrc = 0.
        ls-icon = ls_icon-id.
      ENDIF.

      IF indx <> 0.
        MODIFY lt FROM ls INDEX indx TRANSPORTING status icon symbol .
      ENDIF.
      CLEAR ls.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_alv_instance.
    DATA : flag.
    IF i_list = 'X' OR i_grid = 'X'.
      IF i_list = 'X'.
        flag = 'X'.
      ELSE.
        flag = ' '.
      ENDIF.
      TRY.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              list_display = flag
            IMPORTING
              r_salv_table = lo_salv_tab
            CHANGING
              t_table      = lt.

          IF i_alv_tb = abap_true.
**Begin- Displaying toolbar on alv **
            CALL METHOD lo_salv_tab->get_functions " Get the instance of                                                                                      "alv toolbal button
              RECEIVING
                value = lo_func.

            CALL METHOD lo_func->set_default " pass 'TRUE' to display                                                                                 "toobar on alv
              EXPORTING
                value = if_salv_c_bool_sap=>true.
**End- Displaying toolbar on alv**
          ENDIF.

** Begin - Hides paritular column of the table in the list or grid**
          CALL METHOD lo_salv_tab->get_columns
            RECEIVING
              value = lo_cols.
          TRY.
              CALL METHOD lo_cols->get_column
                EXPORTING
                  columnname = 'MANDT'
                RECEIVING
                  value      = lo_col.
              CALL METHOD lo_col->set_technical
                EXPORTING
                  value = if_salv_c_bool_sap=>true.

            CATCH cx_salv_not_found .
          ENDTRY.

** End - Hides paritular column of the table in the list or grid**
** Begin - Set status field as traffic icon **
          TRY.
              CALL METHOD lo_cols->set_exception_column
                EXPORTING
                  value = 'STATUS'.
            CATCH cx_salv_data_error .
          ENDTRY.
**End - Set status field as traffic icon **

**Begin - Set icon for the column ICON**
          TRY.
              CALL METHOD lo_cols->get_column
                EXPORTING
                  columnname = 'ICON'
                RECEIVING
                  value      = lo_col_icon.
              lo_icon ?= lo_col_icon.
              CALL METHOD lo_icon->set_icon
                EXPORTING
                  value = if_salv_c_bool_sap=>true.
              CALL METHOD lo_icon->set_long_text
                EXPORTING
                  value = 'Icon'.

            CATCH cx_salv_not_found .
          ENDTRY.
**End - Set icon for the column ICON**


**Start- Symbol**
          TRY.
              CALL METHOD lo_cols->get_column
                EXPORTING
                  columnname = 'SYMBOL'
                RECEIVING
                  value      = lo_col_sym.
              lo_symbol ?= lo_col_sym.
              CALL METHOD lo_symbol->set_symbol
                EXPORTING
                  value = if_salv_c_bool_sap=>true.
              CALL METHOD lo_symbol->set_long_text
                EXPORTING
                  value = 'Symbol'.  " Column name set
            CATCH cx_salv_not_found .
          ENDTRY.
**End symbol**

        CATCH cx_salv_msg .
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD display_alv.
    CALL METHOD lo_salv_tab->display.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  PARAMETERS : list     RADIOBUTTON GROUP g1,
               grid     RADIOBUTTON GROUP g1,
               alv_tool AS CHECKBOX.

  SELECTION-SCREEN END OF BLOCK b1.

  CALL METHOD lcl_salv_tab=>main
    EXPORTING
      i_list   = list
      i_grid   = grid
      i_alv_tb = alv_tool.
