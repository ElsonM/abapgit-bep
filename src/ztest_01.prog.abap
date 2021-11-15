*&---------------------------------------------------------------------*
*& Report ZTEST_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_01.


*TYPES: BEGIN OF tt_mara,
*         matnr TYPE matnr,
*       END OF tt_mara.
*
*DATA: it_mara TYPE TABLE OF tt_mara,
*      wa_mara TYPE          tt_mara.
*
*TYPES: BEGIN OF tt_marc,
*         matnr TYPE matnr,
*         werks TYPE werks_d,
*         pstat TYPE pstat_d,
*         lvorm TYPE lvowk,
*         bwtty TYPE bwtty_d,
*         xchar TYPE xchar,
*         mmsta TYPE mmsta,
*       END OF tt_marc.
*
*DATA: it_marc TYPE TABLE OF tt_marc,
*      wa_marc TYPE          tt_marc.
*
*
*SELECT matnr
*       ersda
*       ernam
*       laeda FROM mara
*             INTO CORRESPONDING FIELDS OF TABLE it_mara
*             UP TO 10 ROWS.
*
*
*SELECT matnr
*       werks
*       pstat
*       lvorm
*       bwtty
*       xchar
*       mmsta FROM marc
*             INTO CORRESPONDING FIELDS OF TABLE it_marc
*             UP TO 100 ROWS.
*
*
*DELETE it_marc WHERE matnr NOT IN ( SELECT matnr FROM mara
*                                                 INTO CORRESPONDING FIELDS OF TABLE it_mara
*                                                 UP TO 10 ROWS ).

*NODES: spfli, sflight, sbook.
*
*DATA weight TYPE i VALUE 0.
*
*GET spfli.
*  SKIP.
*  WRITE:/ 'Carrid:', spfli-carrid,
*          'Connid:', spfli-connid,
*        / 'From: ',  spfli-cityfrom,
*          'To: ',    spfli-cityto.
*  ULINE.
*
*GET sflight.
*  SKIP.
*  WRITE: / 'Date:', sflight-fldate.
*
*GET sbook.
*  weight = weight + sbook-luggweight.
*
*GET sflight LATE.
*  WRITE: / 'Total luggage weight =', weight.
*  ULINE.
*  CLEAR weight.

*NODES: spfli, sflight, sbook.
*
*DATA: gr_table TYPE REF TO cl_salv_hierseq_table.
*DATA: it_spfli TYPE TABLE OF spfli.
*DATA: it_sflight TYPE TABLE OF sflight.
*DATA: it_binding TYPE salv_t_hierseq_binding.
*DATA: wa_binding LIKE LINE OF it_binding.
*
*GET spfli.
*  APPEND spfli TO it_spfli.
*
*GET sflight.
*  APPEND sflight TO it_sflight.
*
*END-OF-SELECTION.
*  wa_binding-master = 'CARRID'.
*  wa_binding-slave  = 'CARRID'.
*  APPEND wa_binding TO it_binding.
*
*  wa_binding-master = 'CONNID'.
*  wa_binding-slave  = 'CONNID'.
*  APPEND wa_binding TO it_binding.
*
*  cl_salv_hierseq_table=>factory(
*    EXPORTING
*      t_binding_level1_level2 = it_binding
*    IMPORTING
*      r_hierseq               = gr_table
*    CHANGING
*      t_table_level1          = it_spfli
*      t_table_level2          = it_sflight ).
*
*  gr_table->display( ).


*CLASS demo DEFINITION.
*  PUBLIC SECTION.
*    CLASS-METHODS main.
*  PRIVATE SECTION.
*    CLASS-DATA     scarr_tab TYPE TABLE OF scarr.
*    CLASS-METHODS: handle_double_click
*      FOR EVENT double_click
*                  OF cl_salv_events_table
*      IMPORTING row column,
*      detail
*        IMPORTING carrid TYPE scarr-carrid,
*      browser
*        IMPORTING url TYPE csequence.
*ENDCLASS.
*
*CLASS demo IMPLEMENTATION.
*  METHOD main.
*    SELECT *
*           FROM scarr
*           INTO TABLE @scarr_tab.
*    TRY.
*        cl_salv_table=>factory(
*          IMPORTING r_salv_table = DATA(alv)
*          CHANGING  t_table = scarr_tab ).
*        DATA(events) = alv->get_event( ).
*        SET HANDLER handle_double_click FOR events.
*        DATA(columns) = alv->get_columns( ).
*        DATA(col_tab) = columns->get( ).
*        LOOP AT col_tab ASSIGNING FIELD-SYMBOL(<column>).
*          <column>-r_column->set_output_length( 40 ).
*          IF <column>-columnname = 'CARRNAME' OR
*             <column>-columnname = 'URL'.
*            <column>-r_column->set_visible( 'X' ).
*          ELSE.
*            <column>-r_column->set_visible( ' ' ).
*          ENDIF.
*        ENDLOOP.
*        alv->display( ).
*      CATCH cx_salv_msg.
*        MESSAGE 'ALV display not possible' TYPE 'I'
*          DISPLAY LIKE 'E'.
*    ENDTRY.
*  ENDMETHOD.
*  METHOD handle_double_click.
*    READ TABLE scarr_tab INDEX row ASSIGNING FIELD-SYMBOL(<scarr>).
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*    IF column = 'CARRNAME'.
*      demo=>detail( <scarr>-carrid ).
*    ELSEIF column = 'URL'.
*      demo=>browser( <scarr>-url ).
*    ENDIF.
*  ENDMETHOD.
*  METHOD detail.
**    TYPES: BEGIN OF alv_line,
**             carrid   TYPE spfli-carrid,
**             connid   TYPE spfli-connid,
**             cityfrom TYPE spfli-cityfrom,
**             cityto   TYPE spfli-cityto,
**           END OF alv_line.
**    DATA   alv_tab    TYPE TABLE OF alv_line.
*    SELECT carrid, connid, cityfrom, cityto
*           FROM spfli
*           WHERE carrid = @carrid INTO TABLE @DATA(alv_tab).
*    IF sy-subrc <> 0.
*      MESSAGE e007(sabapdemos).
*    ENDIF.
*    TRY.
*        cl_salv_table=>factory(
*          IMPORTING r_salv_table = DATA(alv)
*          CHANGING  t_table = alv_tab ).
*        alv->set_screen_popup( start_column = 1
*                               end_column   = 60
*                               start_line   = 1
*                               end_line     = 12 ).
*        alv->display( ).
*      CATCH cx_salv_msg.
*        MESSAGE 'ALV display not possible' TYPE 'I'
*                DISPLAY LIKE 'E'.
*    ENDTRY.
*  ENDMETHOD.
*  METHOD browser.
*    cl_abap_browser=>show_url(
*      EXPORTING url = url ).
*  ENDMETHOD.
*ENDCLASS.
*
*START-OF-SELECTION.
*  demo=>main( ).


*DATA: t100_lines TYPE STANDARD TABLE OF t001 WITH DEFAULT KEY.
*
*PARAMETERS: p_file LIKE rlgrap-filename DEFAULT 'c:\tmp\test.xls'.
*
*SELECT * FROM t001
*
*INTO TABLE t100_lines.
*
*CALL FUNCTION 'SAP_CONVERT_TO_XLS_FORMAT'
*  EXPORTING
*    i_line_header  = 'X'
*    i_filename     = p_file
*  TABLES
*    i_tab_sap_data = t100_lines.
*
*BREAK-POINT.

*DATA: gt_list     TYPE vrm_values.
*DATA: gwa_list    TYPE vrm_value.
*DATA: gt_values   TYPE TABLE OF dynpread,
*      gwa_values  TYPE dynpread.
*
*DATA: gv_selected_value(10) TYPE c.
**--------------------------------------------------------------*
**Selection-Screen
**--------------------------------------------------------------*
*PARAMETERS: list TYPE c AS LISTBOX VISIBLE LENGTH 20.
**--------------------------------------------------------------*
**At Selection Screen
**--------------------------------------------------------------*
*AT SELECTION-SCREEN ON list.
*  CLEAR: gwa_values, gt_values.
*  REFRESH gt_values.
*  gwa_values-fieldname = 'LIST'.
*  APPEND gwa_values TO gt_values.
*  CALL FUNCTION 'DYNP_VALUES_READ'
*    EXPORTING
*      dyname             = sy-cprog
*      dynumb             = sy-dynnr
*      translate_to_upper = 'X'
*    TABLES
*      dynpfields         = gt_values.
*
*  READ TABLE gt_values INDEX 1 INTO gwa_values.
*  IF sy-subrc = 0 AND gwa_values-fieldvalue IS NOT INITIAL.
*    READ TABLE gt_list INTO gwa_list
*                      WITH KEY key = gwa_values-fieldvalue.
*    IF sy-subrc = 0.
*      gv_selected_value = gwa_list-text.
*    ENDIF.
*  ENDIF.
**--------------------------------------------------------------*
**Initialization
**--------------------------------------------------------------*
*INITIALIZATION.
*  gwa_list-key = '1'.
*  gwa_list-text = 'Product'.
*  APPEND gwa_list TO gt_list.
*  gwa_list-key = '2'.
*  gwa_list-text = 'Collection'.
*  APPEND gwa_list TO gt_list.
*  gwa_list-key = '3'.
*  gwa_list-text = 'Color'.
*  APPEND gwa_list TO gt_list.
*  gwa_list-key = '4'.
*  gwa_list-text = 'Count'.
*  APPEND gwa_list TO gt_list.
*
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = 'LIST'
*      values          = gt_list
*    EXCEPTIONS
*      id_illegal_name = 1
*      OTHERS          = 2.
**--------------------------------------------------------------*
**Start of Selection
**--------------------------------------------------------------*
*START-OF-SELECTION.
*  WRITE:/ gv_selected_value.


*PARAMETERS:
*  a TYPE char10.
*
*
*DATA:
*  BEGIN OF tab OCCURS 0,
*    field1 TYPE char10,
*    field2 TYPE char10,
*    field3 TYPE char10,
*  END OF tab,
*  wa              LIKE LINE OF tab,
*  lt_return       TYPE TABLE OF ddshretval,
*  lwa_return      TYPE ddshretval.
*
*INITIALIZATION.
*  wa-field1 = 'aaaaa'.
*  wa-field2 = 'bbbbb'.
*  wa-field3 = 'ccccc'.
*  APPEND wa TO tab.
*
*  wa-field1 = 'aaaaa'.
*  wa-field2 = 'bbccc'.
*  wa-field3 = 'ddddd'.
*  APPEND wa TO tab.
*
*  wa-field1 = 'aaaab'.
*  wa-field2 = 'bbccc'.
*  wa-field3 = 'eeeee'.
*  APPEND wa TO tab.
*
**  dyn_wa-fldname = 'FIELD1'.
**  dyn_wa-dyfldname = 'A'.
**  APPEND dyn_wa TO dynpfld_mapping.
**
**  dyn_wa-fldname = 'FIELD2'.
**  dyn_wa-dyfldname = 'B'.
**  APPEND dyn_wa TO dynpfld_mapping.
**
**  dyn_wa-fldname = 'FIELD3'.
**  dyn_wa-dyfldname = 'C'.
**  APPEND dyn_wa TO dynpfld_mapping.
**
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR a.
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield         = 'FIELD1'
*      dynpprog         = sy-cprog
*      dynpnr           = '1000'
*      dynprofield      = 'A'
*      value_org        = 'S'
*      callback_program = sy-cprog
*      callback_form    = 'CALLBACK_F4'
*
*    TABLES
*      value_tab        = tab
*
*      return_tab       = lt_return
*
*    .
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*
*FORM callback_f4 TABLES record_tab STRUCTURE seahlpres
*            CHANGING shlp TYPE shlp_descr
*                     callcontrol LIKE ddshf4ctrl.
*  DATA:
*    ls_intf LIKE LINE OF shlp-interface,
*    ls_prop LIKE LINE OF shlp-fieldprop.
*
*  CLEAR: ls_prop-shlpselpos,
*         ls_prop-shlplispos.
*
*  REFRESH: shlp-interface.
*  ls_intf-shlpfield = 'F0001'.
*  ls_intf-valfield  = 'A'.
*  ls_intf-f4field   = 'X'.
*  APPEND ls_intf TO shlp-interface.
*  ls_intf-shlpfield = 'F0002'.
*  ls_intf-valfield  = 'B'.
*  ls_intf-f4field   = 'X'.
*  APPEND ls_intf TO shlp-interface.
*  ls_intf-shlpfield = 'F0003'.
*  ls_intf-valfield  = 'C'.
*  ls_intf-f4field   = 'X'.
*  APPEND ls_intf TO shlp-interface.
*ENDFORM.

*CLASS printer DEFINITION.
*  PUBLIC SECTION.
*    METHODS print.
*ENDCLASS.
*
*CLASS printer IMPLEMENTATION.
*  METHOD print.
*    WRITE / 'Document printed.'.
*  ENDMETHOD.
*ENDCLASS.
*
*CLASS printer_with_counter DEFINITION INHERITING FROM printer.
*  PUBLIC SECTION.
*    DATA counter TYPE i.
*    METHODS constructor IMPORTING count TYPE i.
*    METHODS print REDEFINITION.
*ENDCLASS.
*
*CLASS printer_with_counter IMPLEMENTATION.
*  METHOD constructor.
*    super->constructor( ).
*    counter = count.
*  ENDMETHOD.
*
*  METHOD print.
*    counter = counter + 1.
*    super->print( ).
*  ENDMETHOD.
*ENDCLASS.
*
*CLASS multi_copy_printer DEFINITION INHERITING FROM printer_with_counter.
*  PUBLIC SECTION.
*    METHODS set_copies IMPORTING copies TYPE i.
*    METHODS print REDEFINITION.
*
*  PRIVATE SECTION.
*    DATA copies TYPE i.
*ENDCLASS.
*
*CLASS multi_copy_printer IMPLEMENTATION.
*  METHOD set_copies.
*    me->copies = copies.
*  ENDMETHOD.
*
*  METHOD print.
*    DO copies TIMES.
*      super->print( ).
*    ENDDO.
*  ENDMETHOD.
*
*ENDCLASS.
*
*START-OF-SELECTION.
*  DATA(oref) = NEW multi_copy_printer( count = 0 ).
*  oref->set_copies( 5 ).
*  oref->print( ).

* Daten für SALV-Grid oben
SELECT *
  INTO TABLE @DATA(it_scarr)
  FROM scarr.

* Daten für SALV-Grid unten
SELECT *
  INTO TABLE @DATA(it_sflight)
  FROM sflight.

* Referenzen auf GUI-Objekte
* Splitter
DATA: o_splitter_main TYPE REF TO cl_gui_splitter_container.
* Splitter-Container oben
DATA: o_container_o   TYPE REF TO cl_gui_container.
* Splitter-Container unten
DATA: o_container_u   TYPE REF TO cl_gui_container.

* Splitter auf default_screen erzeugen
o_splitter_main = NEW #( parent                  = cl_gui_container=>default_screen
                         no_autodef_progid_dynnr = abap_true       "wichtig
                         rows                    = 2
                         columns                 = 1 ).

* Höhe oberer Splitter in %
o_splitter_main->set_row_height( id = 1 height = 50 ).

* REF auf oberen und unteren Splitcontainer holen
o_container_o = o_splitter_main->get_container( row = 1 column = 1 ).
o_container_u = o_splitter_main->get_container( row = 2 column = 1 ).

* SALV-Table oben mit Fluggesellschaften
DATA: o_salv_o TYPE REF TO cl_salv_table.

cl_salv_table=>factory( EXPORTING
                          r_container  = o_container_o
                        IMPORTING
                          r_salv_table = o_salv_o
                        CHANGING
                          t_table      = it_scarr ).

* Grundeinstellungen
o_salv_o->get_functions( )->set_all( abap_true ).
o_salv_o->get_columns( )->set_optimize( abap_true ).
o_salv_o->get_display_settings( )->set_list_header( 'Fluggesellschaften' ).
o_salv_o->get_display_settings( )->set_striped_pattern( abap_true ).
o_salv_o->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

* Spaltenüberschriften: technischer Name und Beschreibungstexte
LOOP AT o_salv_o->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<so>).
  DATA(o_col_o) = <so>-r_column.
  o_col_o->set_short_text( || ).
  o_col_o->set_medium_text( || ).
  o_col_o->set_long_text( |{ o_col_o->get_columnname( ) }| ).
ENDLOOP.

* SALV-Grid anzeigen
o_salv_o->display( ).

* SALV-Table unten mit Flügen
DATA: o_salv_u TYPE REF TO cl_salv_table.

cl_salv_table=>factory( EXPORTING
                          r_container  = o_container_u
                        IMPORTING
                          r_salv_table = o_salv_u
                        CHANGING
                          t_table      = it_sflight ).

* Grundeinstellungen
o_salv_u->get_functions( )->set_all( abap_true ).
o_salv_u->get_columns( )->set_optimize( abap_true ).
o_salv_u->get_display_settings( )->set_list_header( 'Flüge' ).
o_salv_u->get_display_settings( )->set_striped_pattern( abap_true ).
o_salv_u->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

* Spaltenüberschriften: technischer Name und Beschreibungstexte
LOOP AT o_salv_u->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<su>).
  DATA(o_col_u) = <su>-r_column.
  o_col_u->set_short_text( || ).
  o_col_u->set_medium_text( || ).
  o_col_u->set_long_text( |{ o_col_u->get_columnname( ) }| ).
ENDLOOP.

* SALV-Grid anzeigen
o_salv_u->display( ).

* leere Toolbar ausblenden
cl_abap_list_layout=>suppress_toolbar( ).

* Erzwingen von cl_gui_container=>default_screen
WRITE: space.
