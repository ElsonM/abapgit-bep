*&---------------------------------------------------------------------*
*& Report ZTEST_ELSON01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_elson01.

** Get all airlines
*SELECT * FROM sflight INTO TABLE @DATA(lt_sflight).
*
*IF lt_sflight IS NOT INITIAL.
** Get airline details
*  SELECT * FROM scarr INTO TABLE @DATA(lt_scarr)
*    FOR ALL ENTRIES IN @lt_sflight
*    WHERE carrid = @lt_sflight-carrid.
*
** Get airline connection details
*  SELECT * FROM spfli INTO TABLE @DATA(lt_spfli)
*    FOR ALL ENTRIES IN @lt_sflight
*    WHERE carrid = @lt_sflight-carrid
*      AND connid = @lt_sflight-connid.
*ENDIF.
*
*SORT lt_sflight BY carrid connid.
*DELETE ADJACENT DUPLICATES FROM lt_sflight COMPARING carrid connid.
*
*LOOP AT lt_sflight INTO DATA(ls_sflight).
*
*  DATA(airline) = CONV string(
*    LET airline_name = lt_scarr[ carrid = ls_sflight-carrid ]-carrname
*        airline_from = lt_spfli[ carrid = ls_sflight-carrid
*                                 connid = ls_sflight-connid ]-cityfrom
*        airline_to   = lt_spfli[ carrid = ls_sflight-carrid
*                                 connid = ls_sflight-connid ]-cityto
*     IN |{ airline_name } connects from { airline_from } to { airline_to }| ).
*
*  WRITE: / airline.
*
*ENDLOOP.

*TYPES: BEGIN OF lty_demo,
*         col1 TYPE i,
*         col2 TYPE i,
*       END OF lty_demo.
*
*TYPES ltt_text TYPE STANDARD TABLE OF string WITH EMPTY KEY.
*
**Structure
*DATA(struc) = VALUE lty_demo( LET x = 1
*                                  y = 10 * X
*                               IN col1 = x
*                                  col2 = y ).
*WRITE: struc-col1, struc-col2.
*
**Internal Table
*DATA(lt_text) = VALUE ltt_text( LET it = 'be' IN
*                                ( |To { it } is to do| )
*                                ( |To do is to { it }| )
*                                ( |What is to { it } done| )
*                                ( |Scooby-doobee-doo| ) ).
*
*LOOP AT lt_text INTO DATA(ls_text).
*  WRITE / ls_text.
*ENDLOOP.



*LOOP AT lt_sflight INTO DATA(ls_sflight) GROUP BY ( k1 = ls_sflight-carrid
*                                                    k2 = ls_sflight-connid ).
*  WRITE:/ ls_sflight-carrid, ls_sflight-connid.
*ENDLOOP.

*DATA total_price TYPE i.
*
*SELECT * FROM sflight INTO TABLE @DATA(lt_sflight).
*
*LOOP AT lt_sflight INTO DATA(ls_sflight) GROUP BY ( k1 = ls_sflight-carrid
*                                                    k2 = ls_sflight-connid )
*                                         INTO DATA(group_sflight).
**  WRITE:/ sy-tabix.
*  LOOP AT GROUP group_sflight INTO DATA(record).
**    "Accessing group members
**    WRITE:/ record-carrid, record-connid.
*    total_price = total_price + record-paymentsum.
*  ENDLOOP.
*
*  WRITE:/ record-carrid, record-connid, total_price.
*
*  CLEAR total_price.
*ENDLOOP.


*DATA total_price TYPE i.
*
*SELECT * FROM sflight INTO TABLE @DATA(lt_sflight).
*
*LOOP AT lt_sflight INTO DATA(ls_sflight) GROUP BY ( airline    = ls_sflight-carrid
*                                                    connection = ls_sflight-connid )
*                                         INTO DATA(group_sflight).
*
*  LOOP AT GROUP group_sflight INTO DATA(record_sflight).
*    total_price = total_price + record_sflight-paymentsum.
*  ENDLOOP.
*
*  WRITE:/ group_sflight-airline, group_sflight-connection, total_price.
*  CLEAR total_price.
*
*ENDLOOP.


*DATA(lv_text) = NEW char10( 'ABCD@#@#' ).
*DATA(lv_output) = NEW char10( ).
*
*DO 10 TIMES.
*  DATA(lv_offset) = NEW i( sy-index - 1 ).
*  DATA(lv_char_part) = NEW char1( lv_text->*+lv_offset->*(1) ).
*  DATA(lv_new_part) =
*    SWITCH char1( LET x = '*' IN
*                  lv_char_part->*
*                  WHEN 'A' THEN 'Z'
*                  WHEN 'B' THEN 'Y'
*                  WHEN 'C' THEN 'X'
*                  WHEN 'D' THEN 'W'
*                  WHEN space THEN LET y = x IN y
*                  ELSE 0 ).
*  lv_output->*+lv_offset->*(1) = lv_new_part.
*ENDDO.
*
*WRITE:/ lv_output->*.

*TYPES ltty_days TYPE TABLE OF string WITH EMPTY KEY.
*
*WRITE:/ |Variant 1 : BASE before an Internal table used for insert|.
*
*DATA(lt_days) =
*  VALUE ltty_days( ( |Mon| ) ( |Tue| ) ( |Wed| ) ).
*
*lt_days =
*  VALUE #(
*    BASE lt_days
*      ( |Thu| ) ( |Fri| ) ( |Sat| ) ( |Sun| ) ).
*
*LOOP AT lt_days ASSIGNING FIELD-SYMBOL(<lfs_days>).
*  WRITE:/ |{ <lfs_days> }|.
*ENDLOOP.


*DATA: BEGIN OF struct1,
*        col1 TYPE i VALUE 11,
*        col2 TYPE i VALUE 12,
*      END OF struct1.
*
*DATA: BEGIN OF struct2,
*        col2 TYPE i VALUE 22,
*        col3 TYPE i VALUE 23,
*      END OF struct2.
*
*struct2 = CORRESPONDING #( BASE ( struct2 ) struct1 ).
*
*BREAK-POINT.

*MOVE-CORRESPONDING struct1 TO struct2.
*
*BREAK-POINT.

*WRITE:/ |Variant 2 : usage with CORRESPONDING operator on Work area|.
*
*TYPES: BEGIN OF lty_type1,
*         field1 TYPE i,
*       END OF lty_type1,
*
*       ltty_type1 TYPE TABLE OF lty_type1 WITH EMPTY KEY,
*
*       BEGIN OF lty_type2,
*         field1 TYPE i,
*         field2 TYPE i,
*       END OF lty_type2,
*
*       ltty_type2 TYPE TABLE OF lty_type2 WITH EMPTY KEY.
*
*DATA(lwa_type1) = VALUE lty_type1( field1 = 1 ).
*DATA(lwa_type2) = VALUE lty_type2( field1 = 2 field2 = 3 ).
*
*MOVE-CORRESPONDING lwa_type1 TO lwa_type2.
*
*WRITE:/ lwa_type2-field1, space, lwa_type2-field2.
*
*lwa_type2 = VALUE lty_type2( field1 = 2 field2 = 3 ).
*lwa_type2 = CORRESPONDING #( lwa_type1 ).
*
*WRITE:/ lwa_type1-field1, space, lwa_type2-field2.
*
*lwa_type2 = VALUE lty_type2( field1 = 2 field2 = 3 ).
*lwa_type2 = CORRESPONDING #( BASE ( lwa_type2 ) lwa_type1 ).
*
*WRITE:/ lwa_type1-field1, space, lwa_type2-field2.

*WRITE:/ |{ repeat( val = 'A' occ = 5 ) }|.

*TYPES: BEGIN OF ty_customer,
*         customer TYPE char10,
*         name     TYPE char30,
*         city     TYPE char30,
*         route    TYPE char10,
*       END OF ty_customer.
*
*TYPES: BEGIN OF ty_route,
*         route TYPE char10,
*         name  TYPE char40,
*       END OF ty_route.
*
*TYPES: BEGIN OF ty_route_config,
*         route   TYPE char10,
*         c_type  TYPE char10,
*         c_value TYPE char40,
*       END OF ty_route_config.
*
*TYPES: BEGIN OF ty_route_max,
*         route   TYPE char10,
*         name    TYPE char40,
*         c_value TYPE char40,
*       END OF ty_route_max.
*
*TYPES: tt_customer TYPE SORTED TABLE OF ty_customer
*          WITH UNIQUE KEY customer.
*
*TYPES: tt_route TYPE SORTED TABLE OF ty_route
*         WITH UNIQUE KEY route.
*
*TYPES: tt_route_config TYPE SORTED TABLE OF ty_route_config
*        WITH UNIQUE KEY route c_type.
*
*TYPES: tt_city TYPE STANDARD TABLE OF char30 WITH DEFAULT KEY.
*
*TYPES: tt_name TYPE STANDARD TABLE OF char40 WITH DEFAULT KEY.
*TYPES: tt_name2 TYPE STANDARD TABLE OF ty_route WITH DEFAULT KEY.
*
*TYPES: tt_route_max TYPE STANDARD TABLE OF ty_route_max WITH DEFAULT KEY.
*
*DATA(lt_customer) =
*  VALUE tt_customer(
*    ( customer = 'C0001' name = 'Test Customer 1' city = 'NY'  route = 'R0001' )
*    ( customer = 'C0002' name = 'Customer 2'      city = 'LA'  route = 'R0002' )
*    ( customer = 'C0003' name = 'Good Customer 3' city = 'DFW' route = 'R0001' )
*    ( customer = 'C0004' name = 'Best Customer 4' city = 'CH'  route = 'R0003' ) ).
*
*DATA(lt_route) =
*  VALUE tt_route(
*    ( route = 'R0001' name = 'Route 1' )
*    ( route = 'R0002' name = 'Route 2' )
*    ( route = 'R0003' name = 'Route 3' ) ).
*
*DATA(lt_rc) =
*  VALUE tt_route_config(
*    ( route = 'R0001' c_type = 'RTYPE' c_value = 'DSD'  )
*    ( route = 'R0001' c_type = 'MAX'   c_value = '10'   )
*    ( route = 'R0002' c_type = 'RTYPE' c_value = 'WH'   )
*    ( route = 'R0002' c_type = 'MAX'   c_value = '100'  )
*    ( route = 'R0003' c_type = 'RTYPE' c_value = 'WH'   )
*    ( route = 'R0004' c_type = 'RTYPE' c_value = 'DSD'  ) ).
*
** FOR to get the column CITY
*DATA(lt_city) =
*  VALUE tt_city(
*    FOR ls_customer IN lt_customer ( ls_customer-city ) ).
*
** FOR with WHERE condition
*DATA(lt_city_in_03) =
*  VALUE tt_city(
*    FOR ls_customer IN lt_customer WHERE ( route = 'R0001' )
*      ( ls_customer-city ) ).
*
** Nested FOR with 2 tables
*DATA(lt_route_name) =
*  VALUE tt_name(
*    FOR ls_customer IN lt_customer
*    FOR ls_route IN lt_route WHERE ( route = ls_customer-route )
*      ( ls_route-name ) ).
*
*DATA(lt_route_name2) =
*  VALUE tt_name2(
*    FOR ls_customer IN lt_customer
*     LET ls_route = VALUE #( lt_route[ route = ls_customer-route ] OPTIONAL )
*      IN ( route = ls_route-route name = ls_route-name ) ).
*
** Nested FOR - 3 levels
*DATA(lt_route_max) =
*  VALUE tt_route_max(
*    FOR ls_customer IN lt_customer
*    FOR ls_route    IN lt_route WHERE ( route = ls_customer-route )
*    FOR ls_rc       IN lt_rc    WHERE ( route  = ls_route-route
*                                  AND   c_type = 'MAX' )
*      ( route   = ls_route-route
*        name    = ls_route-name
*        c_value = ls_rc-c_value ) ).
*
*DATA(lt_route_max2) =
*  VALUE tt_route_max(
*    FOR ls_customer IN lt_customer
*    LET ls_route = VALUE #( lt_route[ route = ls_customer-route ] OPTIONAL )
*        ls_rc    = VALUE #( lt_rc[ route  = ls_route-route
*                                   c_type = 'MAX'] OPTIONAL )
*    IN ( route  = ls_route-route
*        name    = ls_route-name
*        c_value = ls_rc-c_value ) ).
*
*BREAK-POINT.

TYPES : BEGIN OF ty_s_customizing_tables,
          tabname TYPE dd02l-tabname,
          ddtext  TYPE dd02t-ddtext,
        END OF ty_s_customizing_tables.

TYPES: ty_it_customizing_tables TYPE STANDARD TABLE OF ty_s_customizing_tables WITH DEFAULT KEY.

DATA: it_customizing_tables TYPE ty_it_customizing_tables.

* Klasse für Eventhandling definieren
CLASS lcl_events DEFINITION.
  PUBLIC SECTION.
* Doppelklick
    CLASS-METHODS: on_double_click FOR EVENT double_click OF cl_salv_events_table
      IMPORTING
          row
          column
          sender.
ENDCLASS.

CLASS lcl_events IMPLEMENTATION.
  METHOD on_double_click.
* Tabelle / Pflegeview
    DATA(lv_tab) = CONV dd02l-tabname( it_customizing_tables[ row ]-tabname ).

* Customizingobjekte zu Tabelle anzeigen, ins SAP-IMG abspringen
    CALL FUNCTION 'OBJECT_MAINTENANCE_CALL'
      EXPORTING
        tabname                        = lv_tab
      EXCEPTIONS
        interface_not_correct          = 1
        transaction_not_maintained     = 2
        transaction_not_found          = 3
        table_not_activ                = 4
        table_not_found                = 5
        subobject_not_found_in_project = 6
        subobject_not_found_in_guide   = 7
        object_not_found_in_project    = 8
        object_not_found_in_guide      = 9
        table_has_no_object_in_project = 10
        table_has_no_object_in_guide   = 11
        outline_not_found              = 12
        call_transaction_recurring     = 13
        system_failure                 = 14
        OTHERS                         = 15.

    DATA(lv_err) = ||.

    CASE sy-subrc.
      WHEN 1.
        lv_err = |INTERFACE_NOT_CORRECT|.
      WHEN 2.
        lv_err = |TRANSACTION_NOT_MAINTAINED|.
      WHEN 3.
        lv_err = |TRANSACTION_NOT_FOUND|.
      WHEN 4.
        lv_err = |TABLE_NOT_ACTIV|.
      WHEN 5.
        lv_err = |TABLE_NOT_FOUND|.
      WHEN 6.
        lv_err = |SUBOBJECT_NOT_FOUND_IN_PROJECT|.
      WHEN 7.
        lv_err = |SUBOBJECT_NOT_FOUND_IN_GUIDE|.
      WHEN 8.
        lv_err = |OBJECT_NOT_FOUND_IN_PROJECT|.
      WHEN 9.
        lv_err = |OBJECT_NOT_FOUND_IN_GUIDE|.
      WHEN 10.
        lv_err = |TABLE_HAS_NO_OBJECT_IN_PROJECT|.
      WHEN 11.
        lv_err = |TABLE_HAS_NO_OBJECT_IN_GUIDE|.
      WHEN 12.
        lv_err = |OUTLINE_NOT_FOUND|.
      WHEN 13.
        lv_err = |CALL_TRANSACTION_RECURRING|.
      WHEN 14.
        lv_err = |SYSTEM_FAILURE|.
      WHEN 15.
        lv_err = |OTHERS|.
    ENDCASE.

    MESSAGE |{ lv_err }| TYPE 'S' DISPLAY LIKE 'E'.

  ENDMETHOD.
ENDCLASS.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (10) l_field FOR FIELD p_field.
PARAMETER: p_field TYPE dd03vv-fieldname DEFAULT 'VSBED'.
SELECTION-SCREEN END OF LINE.

INITIALIZATION.

  l_field = 'Feldname:'.

START-OF-SELECTION.

* Customizingtabellen zu einem Datenfeld lesen
  SELECT t~tabname,
         tx~ddtext
    FROM dd03vv AS t
    INNER JOIN dd02l AS c ON t~tabname = c~tabname
    INNER JOIN dd02t AS tx ON t~tabname = tx~tabname
    INTO TABLE @it_customizing_tables
    WHERE t~fieldname = @p_field     " Feldname
      AND t~tabclass = 'TRANSP'      " transparente Tabellen
      AND t~as4local = 'A'           " aktive Objekte
      AND c~contflag IN ('C', 'G')   " Typ: Customizing-Tabellen
      AND tx~ddlanguage = @sy-langu. " Anmeldesprache

  TRY.
* SALV-Table
      DATA: o_salv TYPE REF TO cl_salv_table.

      cl_salv_table=>factory( IMPORTING
                                r_salv_table   = o_salv
                              CHANGING
                                t_table        = it_customizing_tables ).

* Grundeinstellungen
      o_salv->get_functions( )->set_all( abap_true ).
      o_salv->get_columns( )->set_optimize( abap_true ).
      o_salv->get_display_settings( )->set_list_header( |Customizing-Tabellen zu Datenfeld { p_field } (Doppelklick -> IMG)| ).
      o_salv->get_display_settings( )->set_striped_pattern( abap_true ).
      o_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

* Spaltenüberschriften: technischer Name und Beschreibungstexte
      LOOP AT o_salv->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<c>).
        DATA(o_col) = <c>-r_column.
        o_col->set_short_text( || ).
        o_col->set_medium_text( || ).
        o_col->set_long_text( |{ o_col->get_columnname( ) } [{ o_col->get_long_text( ) }]| ).
      ENDLOOP.

* Handler registrieren
      SET HANDLER lcl_events=>on_double_click FOR o_salv->get_event( ).

      o_salv->display( ).
    CATCH cx_root INTO DATA(e_txt).
      WRITE: / e_txt->get_text( ).
  ENDTRY.
