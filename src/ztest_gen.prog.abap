*&---------------------------------------------------------------------*
*& Report ZTEST_GEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_gen.

*Get details from DB table
SELECT *
  FROM sflight
  INTO TABLE @DATA(lt_sflight)
  WHERE connid IN (17, 555).

IF sy-subrc = 0.
*Prepare a range table
  DATA: lr_carrid  TYPE RANGE OF s_carr_id.
*  lr_carrid = VALUE #(   ( sign   = 'I'
*                                                    option = 'EQ'
*                                                    low    = ls_value-carrid ) ).

  LOOP AT lt_sflight INTO DATA(ls_value).
    lr_carrid = VALUE #( BASE lr_carrid ( sign   = 'I'
                                          option = 'EQ'
                                          low    = ls_value-carrid ) ).
  ENDLOOP.

  SORT lr_carrid BY low.
  DELETE ADJACENT DUPLICATES FROM lr_carrid
    COMPARING low.
  cl_demo_output=>display( lr_carrid ).
ENDIF.

*TYPES: BEGIN OF _doc,
*         docnr    TYPE n LENGTH 10,
*         itmno    TYPE n LENGTH 6,
*         category TYPE c LENGTH 2,
*         del_flag TYPE abap_bool,
*       END OF _doc,
*       _docs TYPE SORTED TABLE OF _doc WITH UNIQUE KEY docnr itmno.
*
*DATA(documents) = VALUE _docs(
*  ( docnr = 12001 itmno = 10 category = 'A1' del_flag = 'X' )
*  ( docnr = 12001 itmno = 20 category = 'A1' del_flag = ' ' )
*  ( docnr = 12002 itmno = 10 category = 'A2' del_flag = 'X' )
*  ( docnr = 12003 itmno = 10 category = 'B3' del_flag = ' ' )
*  ( docnr = 12003 itmno = 20 category = 'B1' del_flag = ' ' )  ).
*
*
**LOOP AT documents INTO DATA(document)
**  GROUP BY document-docnr INTO DATA(docgrp).
**
**  LOOP AT GROUP docgrp INTO DATA(docline).
**    WRITE: / docline-docnr, docline-itmno.
**  ENDLOOP.
**
***  WRITE: / docgrp.
**ENDLOOP.
*
*DATA filter_table TYPE SORTED TABLE OF _doc-docnr WITH UNIQUE KEY table_line.
*
*LOOP AT documents INTO DATA(document)
*  GROUP BY ( doc   = document-docnr
*             size  = GROUP SIZE
**             index = GROUP INDEX
*                                 ) DESCENDING INTO DATA(docgrp).
*
*  WRITE: / |Elements in group "{ docgrp-doc }": { docgrp-size ALIGN = LEFT } entries|.
*
*  IF docgrp-size = 1.
*    filter_table = VALUE #( BASE filter_table ( docgrp-doc ) ).
*  ENDIF.
*
**  SORT docgrp BY itmno DESCENDING.
*
**  LOOP AT GROUP docgrp INTO DATA(doc).
**    WRITE: / doc-docnr, doc-itmno.
**  ENDLOOP.
*
*ENDLOOP.
*
*documents = FILTER #( documents EXCEPT IN filter_table WHERE docnr = table_line  ).
*
*BREAK-POINT.

*LOOP AT documents INTO DATA(doc)
*  GROUP BY ( del_group = COND string( WHEN doc-del_flag = space THEN 'valid' ELSE 'deleted' )
*             size      = GROUP SIZE
*             index     = GROUP INDEX ) INTO DATA(docgrp).
*
*  WRITE: / 'Number of', docgrp-del_group, 'entries:', docgrp-size.
*
*ENDLOOP.

*LOOP AT documents INTO DATA(doc)
*  GROUP BY ( cat   = doc-category(1)
*             size  = GROUP SIZE
*             index = GROUP INDEX ) INTO DATA(docgrp).
*
*  WRITE: / 'Number of items in category', docgrp-cat LEFT-JUSTIFIED NO-GAP, ':', docgrp-size.
*
*ENDLOOP.

*LOOP AT documents INTO DATA(doc)
*  GROUP BY ( cat   = doc-category(1)
*             size  = GROUP SIZE
*             index = GROUP INDEX ) INTO DATA(docgrp).
*
*  WRITE: /1 'number of items in category',
*    docgrp-cat LEFT-JUSTIFIED NO-GAP,
*    docgrp-size.
*
*  LOOP AT GROUP docgrp INTO DATA(docline)
*    WHERE del_flag = space GROUP BY ( category = docline-category ) ASCENDING INTO DATA(catgrp).
*
*    WRITE: /5 'category', catgrp-category.
*
*    LOOP AT GROUP catgrp INTO DATA(cat).
*      WRITE: /9 cat-docnr, cat-itmno, cat-category.
*    ENDLOOP.
*
*  ENDLOOP.
*
*ENDLOOP.


*DATA(lv_text) = NEW char10( 'ABCD@#@#' ).
*DATA(lv_output) = NEW char10( ).
*
*DO 10 TIMES.
*  DATA(lv_offset) = NEW i( sy-index - 1 ).
*  DATA(lv_char_part) = NEW char1( lv_text->*+lv_offset->*(1) ).
*  DATA(lv_new_part) = SWITCH char1( LET x = '*' IN lv_char_part->*
*    WHEN 'A' THEN 'Z'
*    WHEN 'B' THEN 'Y'
*    WHEN 'C' THEN 'X'
*    WHEN 'D' THEN 'W'
*    WHEN space THEN LET y = x IN y
*    ELSE 0 ).
*  lv_output->*+lv_offset->*(1) = lv_new_part.
*ENDDO.
*
*BREAK-POINT.

*REPORT  zparameter_f4help.

*INITIALIZATION.
*** Table declaration
*  TABLES : pa0001.
*** Type declaration
*  TYPES : BEGIN OF ty_f4pernr,
*            pernr TYPE persno,
*            vorna TYPE pa0002-vorna,
*            nach2 TYPE pa0002-nach2,
*            nachn TYPE pa0002-nachn,
*          END OF ty_f4pernr.
*** Internal table declaration
*  DATA : int_f4pernr TYPE STANDARD TABLE OF ty_f4pernr.
*** Internal table memory clear
*  REFRESH : int_f4pernr.
*
*** Selection Screen Declaration
*** Begin of block with frame name
*  SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001.
*** Select option declaration of pernr field
*  SELECT-OPTIONS s_pernr FOR pa0001-pernr.
*** End of block
*  SELECTION-SCREEN END OF BLOCK a1.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_pernr-low.
*** Calling the perform method when the low field of select option pernr's f4 is clicked
*  PERFORM pernr_f4help.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_pernr-high.
*** Calling the perform method when the high field of select option pernr's f4 is clicked
*  PERFORM pernr_f4help.

*&---------------------------------------------------------------------*
*&      Form  PERNR_F4HELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM pernr_f4help .
*** Retrieve pernr and corressponding first, last and middle name from pa0002 and pa0003 infotype using inner join
*  SELECT a~pernr b~vorna b~nach2 b~nachn INTO TABLE int_f4pernr
*    FROM pa0003 AS a INNER JOIN pa0002 AS b ON a~pernr EQ b~pernr.
*
*** Calling F4 help function module to assign that retrieved value for that select option pernr
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
*      retfield        = 'PERNR'
*      dynpprog        = sy-repid    " Program name
*      dynpnr          = sy-dynnr    " Screen number
*      dynprofield     = 'S_PERNR'   " F4 help need field
*      value_org       = 'S'
*    TABLES
*      value_tab       = int_f4pernr " F4 help values
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*
*ENDFORM.                    " PERNR_F4HELP

*DATA: lt_flights_all TYPE STANDARD TABLE OF spfli
*                     WITH NON-UNIQUE SORTED KEY carrid
*                     COMPONENTS carrid,
*      lt_flight_final TYPE STANDARD TABLE OF spfli.
*
** Create a filter internal table with multiple values
*DATA filter_tab TYPE SORTED TABLE OF scarr-carrid
*                WITH UNIQUE KEY table_line.
*
*SELECT *  FROM spfli
*          INTO TABLE @lt_flights_all.
*
*filter_tab = VALUE #( ( 'AA ' ) ( 'LH ' ) ).
*
** Apply filters
*lt_flight_final = FILTER #( lt_flights_all IN filter_tab
*                                           WHERE carrid = table_line ).
*cl_demo_output=>write_data( lt_flights_all ).
*cl_demo_output=>write_data( lt_flight_final ).
*cl_demo_output=>display( ).

*DATA: lt_flights_all TYPE STANDARD TABLE OF spfli,
*      lt_flight_lh   TYPE STANDARD TABLE OF spfli.
*
*SELECT * FROM spfli INTO TABLE lt_flights_all.
*
*IF sy-subrc = 0.
*  LOOP AT lt_flights_all INTO DATA(ls_flight) WHERE carrid = 'LH'.
*    APPEND ls_flight TO lt_flight_lh.
*    CLEAR ls_flight.
*  ENDLOOP.
*ENDIF.
*
*BREAK-POINT.

*TYPES: BEGIN OF ty_alv,
*        lights(1) TYPE c, "Exception, holding the value of the lights
*        text(20)  TYPE c, "Some text
*       END OF ty_alv.
*
*DATA: gs_alv TYPE          ty_alv,
*      gt_alv TYPE TABLE OF ty_alv,
*
*      gr_alv     TYPE REF TO cl_salv_table,
*      gr_columns TYPE REF TO cl_salv_columns_table.
*
*START-OF-SELECTION.
*
*  gs_alv-lights = '1'.           "Color red
*  gs_alv-text = 'RED SIGNAL'.
*  APPEND gs_alv TO gt_alv.
*
*  gs_alv-lights = '2'.           "Color yellow
*  gs_alv-text = 'YELLOW SIGNAL'.
*  APPEND gs_alv TO gt_alv.
*
*  gs_alv-lights = '3'.           "Color green
*  gs_alv-text = 'GREEN SIGNAL'.
*  APPEND gs_alv TO gt_alv.
*
*  CALL METHOD cl_salv_table=>factory
*    IMPORTING
*      r_salv_table = gr_alv
*    CHANGING
*      t_table      = gt_alv.
*
*  gr_columns = gr_alv->get_columns( ).
*  gr_columns->set_exception_column( value = 'LIGHTS' ).
*
*  CALL METHOD gr_alv->display.

*TABLES: trdir, tstc.
*
**================*
**Selection Screen
**================*
*
*SELECTION-SCREEN SKIP.
*SELECTION-SCREEN BEGIN OF BLOCK selection WITH FRAME TITLE a1title.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (32) a1line1 FOR FIELD p_datef.
*PARAMETERS: p_datef LIKE sy-datum DEFAULT space OBLIGATORY.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (32) a1line2 FOR FIELD p_datet.
*PARAMETERS:     p_datet LIKE sy-datum DEFAULT sy-datum OBLIGATORY.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN SKIP.
*SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE b1title.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (30) b1line1 FOR FIELD p_summ.
*PARAMETERS :     p_summ  RADIOBUTTON GROUP rad1.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (30) b1line2 FOR FIELD p_detl.
*PARAMETERS :     p_detl  RADIOBUTTON GROUP rad1.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF BLOCK option WITH FRAME TITLE c1title.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (28) c1line1 FOR FIELD p_prog.
*PARAMETERS p_prog RADIOBUTTON GROUP rad2.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN BEGIN OF LINE.
*SELECTION-SCREEN COMMENT (28) c1line2 FOR FIELD p_tran.
*PARAMETERS p_tran RADIOBUTTON GROUP rad2.
*SELECTION-SCREEN END OF LINE.
*SELECTION-SCREEN END OF BLOCK option.
*SELECTION-SCREEN END OF BLOCK b1.
*SELECTION-SCREEN SKIP.
*SELECTION-SCREEN BEGIN OF BLOCK dest WITH FRAME TITLE e1title.
*PARAMETERS :     dest LIKE rfcdisplay-rfcdest DEFAULT 'NONE'.
*SELECTION-SCREEN END OF BLOCK dest.
*SELECTION-SCREEN BEGIN OF BLOCK optional WITH FRAME TITLE d1title.
*SELECT-OPTIONS : s_prog   FOR trdir-name.              "Programs
*SELECT-OPTIONS : s_tcode  FOR tstc-tcode.              "Transaction Code
*SELECTION-SCREEN END OF BLOCK optional.
*SELECTION-SCREEN END OF BLOCK selection.
*
*INITIALIZATION.
*  PERFORM selection_screen_text.
**&---------------------------------------------------------------------*
**&      Form  selection_screen_text
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*FORM selection_screen_text.
*  a1title = 'Enter Dates for Analysis'.
*  a1line1 = 'Analysis Start Date?'.
*  a1line2 = 'Analysis End Date?'.
*  b1title = 'Summary or Detail Report'.
*  b1line1 = 'Summary Report'.
*  b1line2 = 'Detail Report'.
*  c1title = 'Analyze Programs or Transactions'.
*  c1line1 = 'Usage of Standard Programs'.
*  c1line2 = 'Usage of Standard Transactions'.
*  d1title =
* 'Optional: Enter Standard Transaction Codes and Programs for Analysis'.
*  e1title = 'RFC Destination'.
*ENDFORM.                    " selection_screen_text

*PARAMETERS: p_carrid TYPE sflight-carrid,
*            p_connid TYPE sflight-connid,
*            p_fldate TYPE sflight-fldate.
*
*SELECT SINGLE @abap_true
*  FROM sflight
*  WHERE carrid = @p_carrid
*    AND connid = @p_connid
*    AND fldate = @p_fldate
*  INTO @DATA(result).
*
*IF result = abap_true.
*  WRITE 'OK'.
*ELSE.
*  WRITE 'KO'.
*ENDIF.

* ab ABAP 7.50

** Koverter-Objekt erzeugen
*DATA(o_auth) = cl_auth_objects_to_sql=>create_for_open_sql( ).
*
** Objekte für AUTHORITY-CHECK hinzufügen
*o_auth->add_authorization_object( iv_authorization_object = 'S_CARRID'
*                                  it_activities = VALUE #( ( auth_field = 'ACTVT' value = '03' ) )
*                                  it_field_mapping = VALUE #( ( auth_field = 'CARRID'
*                                                                view_field = VALUE #( table_ddic_name = 'SFLIGHT'
*                                                                                      field_name      = 'CARRID'
*                                                                                    )
*                                                              )
*                                                            )
*                                ).
*
** Ist der Benutzer berechtigt?
*IF abap_true = o_auth->is_authorized( ).
*
** WHERE-Condition erzeugen
*  DATA(lv_where_cond) = o_auth->get_sql_condition( ).
*
** Wenn leer, dann hat der Benutzer alle Berechtigungen
*  IF lv_where_cond IS INITIAL.
*    cl_demo_output=>write_data( 'Alle Berechtigungen.' ).
*  ELSE.
** Ansonsten eingeschränkte Berechtigungen
*    cl_demo_output=>write_data( |Eingeschränkte Berechtigungen: { lv_where_cond }| ).
*  ENDIF.
*
** SELECT mit WHERE-Condition durchführen
*  SELECT *
*    INTO TABLE @DATA(it_sflight)
*    FROM sflight
*    WHERE (lv_where_cond).
*
** Datenausgabe
*  cl_demo_output=>write_data( it_sflight ).
*  cl_demo_output=>display( ).
*
*ENDIF.
