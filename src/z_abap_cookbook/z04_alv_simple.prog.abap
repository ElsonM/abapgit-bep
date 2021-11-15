*&---------------------------------------------------------------------*
*& Report Z04_ALV_SIMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_alv_simple.

" Report has an addition button in the toolbar that displays the number of rows displayed in the ALV
" Program takes in consideration even the filters performed

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         ersda TYPE mara-ersda,
         ernam TYPE mara-ernam,
         laeda TYPE mara-laeda,
         aenam TYPE mara-aenam,
         vpsta TYPE mara-vpsta,
         pstat TYPE mara-pstat,
         brgew TYPE mara-brgew,
       END OF ty_mara.

DATA wa_mara TYPE ty_mara.
DATA it_mara TYPE STANDARD TABLE OF ty_mara.

DATA myalv       TYPE REF TO cl_salv_table.
DATA myfunctions TYPE REF TO cl_salv_functions_list.
DATA mycolumns   TYPE REF TO cl_salv_columns_table.
DATA mycolumn    TYPE REF TO cl_salv_column_table.
DATA mylayout    TYPE REF TO cl_salv_layout.
DATA myevents    TYPE REF TO cl_salv_events_table.
DATA mykey       TYPE        salv_s_layout_key.

CLASS newbutton DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS on_button_press FOR EVENT added_function OF cl_salv_events_table
      IMPORTING e_salv_function.
ENDCLASS.

CLASS newbutton IMPLEMENTATION.
  METHOD on_button_press.
    DATA lines TYPE i.
    DATA text  TYPE string.
    IF e_salv_function EQ 'SUMM'.
      """""""""""""""""""""""""""""""""""""""""""""""""""
      """ Addition code for filter start
      """"" Step 1
      DATA: myfilters_obj TYPE REF TO cl_salv_filters,
            myfilter_obj  TYPE REF TO cl_salv_filter.

      DATA: myfilters_tab   TYPE salv_t_filter_ref,
            myfilters_struc TYPE salv_s_filter_ref.

      myfilters_obj = myalv->get_filters( ).
      myfilters_tab = myfilters_obj->get( ).

      """""  Step 2
      TYPES: BEGIN OF ty_range,
               column TYPE          string,
               range  TYPE RANGE OF string,
             END OF ty_range.

      DATA: filter_conditions_table TYPE                   salv_t_selopt_ref,
            filter_conditions       TYPE REF TO            cl_salv_selopt,
            final_range_table       TYPE STANDARD TABLE OF ty_range,
            final_range_struc       TYPE                   ty_range,
            ws_temp                 LIKE LINE OF           final_range_struc-range.

      LOOP AT myfilters_tab INTO myfilters_struc.

        final_range_struc-column = myfilters_struc-columnname.
        CLEAR final_range_struc-range.

        filter_conditions_table = myfilters_struc-r_filter->get( ).

        LOOP AT filter_conditions_table INTO filter_conditions.
          ws_temp-sign   = filter_conditions->get_sign( ).
          ws_temp-option = filter_conditions->get_option( ).
          ws_temp-low    = filter_conditions->get_low( ).
          ws_temp-high   = filter_conditions->get_high( ).
          INSERT ws_temp INTO TABLE final_range_struc-range.
        ENDLOOP.
        INSERT final_range_struc INTO TABLE final_range_table.

      ENDLOOP.

      """ Step 3

      LOOP AT final_range_table INTO final_range_struc.
        CASE final_range_struc-column.
          WHEN 'MATNR'.
            DELETE it_mara WHERE NOT matnr IN final_range_struc-range.
          WHEN 'ERSDA'.
            DELETE it_mara WHERE NOT ersda IN final_range_struc-range.
          WHEN 'ERNAM'.
            DELETE it_mara WHERE NOT ernam IN final_range_struc-range.
          WHEN 'LAEDA'.
            DELETE it_mara WHERE NOT laeda IN final_range_struc-range.
          WHEN 'AENAM'.
            DELETE it_mara WHERE NOT aenam IN final_range_struc-range.
          WHEN 'VPSTA'.
            DELETE it_mara WHERE NOT vpsta IN final_range_struc-range.
          WHEN 'PSTAT'.
            DELETE it_mara WHERE NOT pstat IN final_range_struc-range.
          WHEN 'BRGEW'.
            DELETE it_mara WHERE NOT brgew IN final_range_struc-range.
        ENDCASE.
      ENDLOOP.

      """"" addtional code for filter end
      DESCRIBE TABLE it_mara LINES lines.
      text = lines.
      CONCATENATE text 'lines are displayed' INTO text
        SEPARATED BY space.
      MESSAGE i208(00) WITH text.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE it_mara UP TO 15 ROWS.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = myalv
        CHANGING
          t_table      = it_mara ).
    CATCH cx_salv_msg.
  ENDTRY.

  mycolumns = myalv->get_columns( ).
  mycolumns->set_optimize( ).
  myfunctions = myalv->get_functions( ).
  myfunctions->set_all( ).

  TRY.
      mycolumn ?= mycolumns->get_column( 'MATNR' ).
      mycolumn->set_key( ).

      mycolumn ?= mycolumns->get_column( 'BRGEW' ).
      mycolumn->set_zero( ' ' ).

      mycolumn ?= mycolumns->get_column( 'VPSTA' ).
      mycolumn->set_technical( 'X' ).

      mycolumn ?= mycolumns->get_column( 'PSTAT' ).
      mycolumn->set_visible( if_salv_c_bool_sap=>false ).
    CATCH cx_salv_not_found.
  ENDTRY.

  mylayout = myalv->get_layout( ).

  mykey-report = sy-repid.
  mylayout->set_key( mykey ).

  mylayout->set_save_restriction( if_salv_c_layout=>restrict_user_dependant ).
  mylayout->set_default( 'X' ).

  myevents = myalv->get_event( ).
  SET HANDLER newbutton=>on_button_press FOR myevents.

  CALL METHOD myalv->set_screen_status
    EXPORTING
      pfstatus = 'SALV_TABLE_CUSTOM_02'
      report   = sy-repid.

  CALL METHOD myalv->display.
