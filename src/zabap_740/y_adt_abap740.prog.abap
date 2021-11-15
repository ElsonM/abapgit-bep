*&---------------------------------------------------------------------*
*& Report y_adt_abap740
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_adt_abap740.

*&---------------------------------------------------------------------*
*& New Syntax Nuisances 1
*& Extra care needs to be taken while re-using inline variables
*&---------------------------------------------------------------------*
*TABLES marc.
*SELECT-OPTIONS s_plant FOR marc-werks.
*
*SELECT SINGLE 'Valid plant             ' FROM t001w INTO @DATA(lv_validity)
*  WHERE werks IN @s_plant.
*IF sy-subrc NE 0.
*  lv_validity = 'This is an invalid plant'.
*ENDIF.
*WRITE:/ lv_validity.

*&---------------------------------------------------------------------*
*& New Syntax Nuisances 2
*& If you do no explicitely declare a date field, then you can not
*& perform addition and substraction of dates correctly using inline
*& declared variables
*&---------------------------------------------------------------------*
*DATA lv_cor_date TYPE sy-datum.
*lv_cor_date = sy-datum - 2.
*
*DATA(lv_incor_date) = sy-datum - 2.
*
*WRITE:/ |Correct date: { lv_cor_date } and | && |incorrect date: { lv_incor_date }|.

*&---------------------------------------------------------------------*
*& New Syntax Nuisances 3
*& DUMP during Table Operations
*&---------------------------------------------------------------------*
*TYPES: BEGIN OF ty_po,
*         ebeln TYPE ebeln,
*         lifnr TYPE lifnr,
*         risk  TYPE flag,
*       END OF ty_po.
*TYPES: tt_po TYPE STANDARD TABLE OF ty_po WITH DEFAULT KEY.
*
*DATA(li_item) = VALUE tt_po(
*  ( ebeln = 11 lifnr = 'Vendor 1' risk = ' ' )
*  ( ebeln = 21 lifnr = 'Vendor 2' risk = ' ' )
*  ( ebeln = 31 lifnr = 'Vendor 3' risk = ' ' )
*).
*
**DATA(lwa_line) = li_item[ risk = 'X' ].
**WRITE lwa_line-ebeln.
*
*TRY.
*    DATA(lwa_line) = li_item[ risk = 'X' ].
*  CATCH cx_sy_itab_line_not_found.
*    WRITE:/ 'Not found'.
*ENDTRY.
*
*WRITE lwa_line-ebeln.

*&---------------------------------------------------------------------*
*& New Syntax 21 b. NEW Operator for Class Objects
*&---------------------------------------------------------------------*
*CLASS lcl_class DEFINITION.
*
*  PUBLIC SECTION.
*    DATA: lv_name TYPE char50 VALUE 'Introduction to ABAP 7.4 for S/4 HANA',
*          lv_class TYPE char50 VALUE 'I am in ABAP 7.4 Class'.
*
*    METHODS: show_name,
*             show_class.
*
*  PROTECTED SECTION.
*
*  PRIVATE SECTION.
*
*ENDCLASS.
*
*CLASS lcl_class IMPLEMENTATION.
*
*  METHOD show_name.
*    WRITE:/ 'This is the SHOW_NAME method'.
*    WRITE:/5 lv_name.
*  ENDMETHOD.
*
*  METHOD show_class.
*    WRITE:/ 'This is the SHOW_CLASS method'.
*    WRITE:/5 lv_class.
*  ENDMETHOD.
*
*ENDCLASS.
*
*START-OF-SELECTION.
*
** a) Old method
*  DATA obj1 TYPE REF TO lcl_class.
*
*  CREATE OBJECT obj1.
*  obj1->show_name(  ).
*
** b) New method - 1
*  DATA(obj2) = NEW lcl_class(  ).
*  obj2->show_name(  ).
*
** b) New method - 2
*  DATA obj3 TYPE REF TO lcl_class.
*
*  obj3 = NEW #(  ).
*  obj3->show_name(  ).
*
** c) Variation 3
*  NEW lcl_class(  )->show_name(  ).
*  NEW lcl_class(  )->show_class(  ).

*&---------------------------------------------------------------------*
*& New Syntax 21 a. NEW Operator for Internal Tables and Structures
*&---------------------------------------------------------------------*
*TYPES: BEGIN OF ty_po,
*         ebeln TYPE ebeln,
*         lifnr TYPE lifnr,
*         risk  TYPE flag,
*       END OF ty_po.
*TYPES: tt_po TYPE TABLE OF ty_po WITH DEFAULT KEY.

*DATA ls_tab TYPE REF TO ty_po.
*DATA itab TYPE REF TO tt_po.

*ls_tab = NEW #(
*  ebeln = 1452 lifnr = 'Vendor 13' risk = 'X'
*).
*
*cl_demo_output=>display( ls_tab->* ).

*DATA(ls_tab2) = NEW ty_po(
*  ebeln = 1452 lifnr = 'Vendor 13' risk = 'X'
*).
*
*cl_demo_output=>display( ls_tab2->* ).

*itab = NEW #(
*  ( ebeln = 1452 lifnr = 'Vendor 13' risk = 'X' )
*  ( ebeln = 1454 lifnr = 'Vendor 23' risk = ' ' )
*  ( ebeln = 1456 lifnr = 'Vendor 33' risk = 'X' )
*).
*
*cl_demo_output=>display( itab->* ).

*DATA(itab2) = NEW tt_po(
*  ( ebeln = 1452 lifnr = 'Vendor 13' risk = 'X' )
*  ( ebeln = 1454 lifnr = 'Vendor 23' risk = ' ' )
*  ( ebeln = 1456 lifnr = 'Vendor 33' risk = 'X' )
*).
*
*cl_demo_output=>display( itab2->* ).

*SELECT ebeln, ebelp, netwr,
*  CASE
*  WHEN netwr > 1000 THEN 'X'
*  ELSE ' '
*  END AS risk,
*  matnr, werks FROM ekpo INTO TABLE @DATA(li_item) ORDER BY ebeln.
*
*SELECT ebeln, lifnr FROM ekko INTO TABLE @DATA(li_head) ORDER BY ebeln.

*itab = NEW #(
*  FOR ls_head IN li_head
*  FOR ls_item IN li_item WHERE ( ebeln = ls_head-ebeln AND risk = 'X' )
*  ( ebeln = ls_head-ebeln lifnr = ls_head-lifnr risk = ls_item-risk )
*).
*
*cl_demo_output=>display( itab->* ).

*DATA(itab2) = NEW tt_po(
*  FOR ls_head IN li_head
*  FOR ls_item IN li_item WHERE ( ebeln = ls_head-ebeln AND risk = 'X' )
*  ( ebeln = ls_head-ebeln lifnr = ls_head-lifnr risk = ls_item-risk )
*).
*
*cl_demo_output=>display( itab2->* ).

*&---------------------------------------------------------------------*
*& New Syntax 20 Table Operators
*&---------------------------------------------------------------------*
*TYPES: BEGIN OF ty_po,
*         ebeln TYPE ebeln,
*         lifnr TYPE lifnr,
*         netwr TYPE netwr,
*         risk  TYPE flag,
*       END OF ty_po.
*
*DATA: li_final TYPE STANDARD TABLE OF ty_po,
*      ls_final TYPE ty_po.
*
*SELECT ebeln, ebelp, netwr,
*  CASE
*  WHEN netwr > 1000 THEN 'X'
*  ELSE ' '
*  END AS risk,
*  matnr, werks FROM ekpo INTO TABLE @DATA(li_item) ORDER BY ebeln.

*1 Get index of a particular line
*DATA(idx) = line_index( li_item[ risk = 'X' ] ).
*
*WRITE:/ |First risky entry is line { idx }|.

*2 Check table for any particular entry
*IF line_exists( li_item[ risk = 'X' ] ).
*  WRITE:/ |There is a risky entry|.
*ENDIF.

*3 READ Table
*DATA(lwa_line) = li_item[ risk = 'X' ]. "Catch exception cx_sy_itab_line_not_found
*
*WRITE:/ lwa_line-ebeln, lwa_line-risk.

*4 LOOP and WRITE
*DO lines( li_item ) TIMES.
*  DATA(ls_item) = li_item[ sy-index ].
*  WRITE:/ |{ ls_item-ebeln } { ls_item-netwr }|.
*ENDDO.

*5 READ Internal Table
*SELECT ebeln, lifnr FROM ekko INTO TABLE @DATA(li_head) ORDER BY ebeln.
*
*LOOP AT li_head INTO DATA(ls_head).
*  ls_final-ebeln = ls_head-ebeln.
*  ls_final-lifnr = ls_head-lifnr.
*
**  ls_final-netwr = li_item[ ebeln = ls_head-ebeln ]-netwr.
**  ls_final-risk  = li_item[ ebeln = ls_head-ebeln ]-risk.
*
*  TRY.
*      DATA(ls_item) = li_item[ ebeln = ls_head-ebeln ].
*      ls_final-netwr = ls_item-netwr.
*      ls_final-risk  = ls_item-risk.
*    CATCH cx_sy_itab_line_not_found.
**      WRITE:/ 'Not found'.
*  ENDTRY.
*
**  DATA(ls_item) = li_item[ ebeln = ls_head-ebeln ].
**  ls_final-netwr = ls_item-netwr.
**  ls_final-risk  = ls_item-risk.
*
*  APPEND ls_final TO li_final.
*  CLEAR:ls_item.
*  CLEAR ls_final.
*ENDLOOP.
*
*cl_demo_output=>display( li_final ).

*&---------------------------------------------------------------------*
*& New Syntax 18 MOVE-CORRESPONDING between Internal Tables
*&---------------------------------------------------------------------*
*TYPES: BEGIN OF ty_po,
*         ebeln TYPE ebeln,
*         lifnr TYPE lifnr,
*         risk  TYPE flag,
*       END OF ty_po.
*TYPES: tt_po TYPE STANDARD TABLE OF ty_po WITH DEFAULT KEY.
*
*DATA: itab TYPE STANDARD TABLE OF ty_po.
*
*SELECT ebeln, ebelp, netwr,
*  CASE
*  WHEN netwr > 1000 THEN 'X'
*  ELSE ' '
*  END AS risk,
*  matnr, werks FROM ekpo INTO TABLE @DATA(li_item) ORDER BY ebeln.
*
*SELECT ebeln, lifnr FROM ekko INTO TABLE @DATA(li_head) ORDER BY ebeln.
*
*MOVE-CORRESPONDING li_item TO itab.
*MOVE-CORRESPONDING li_head TO itab KEEPING TARGET LINES.
*
*itab = VALUE #(
*  FOR ls_head IN li_head
*  FOR ls_item IN li_item WHERE ( ebeln = ls_head-ebeln )
*  ( ebeln = ls_head-ebeln lifnr = ls_head-lifnr risk = ls_item-risk )
*).
*
*cl_demo_output=>display( itab ).

*DATA(run_itab) = VALUE tt_po(
*  FOR ls_head IN li_head
*  FOR ls_item IN li_item WHERE ( ebeln = ls_head-ebeln )
*  ( ebeln = ls_head-ebeln lifnr = ls_head-lifnr risk = ls_item-risk )
*).
*
*cl_demo_output=>display( run_itab ).

*&---------------------------------------------------------------------*
*& New Syntax 17 FOR Operator
*&---------------------------------------------------------------------*
*TYPES: tt_c1 TYPE TABLE OF c1 WITH DEFAULT KEY.

*DATA inp TYPE c LENGTH 20 VALUE 'xyzabc123'.
*DATA itab TYPE TABLE OF c1.
*
*DATA(no_char) = strlen( inp ).
*
*itab = VALUE #(
*  FOR i = 0 UNTIL i >= no_char ( inp+i(1) )
*).
*
*LOOP AT itab INTO DATA(ls).
*  WRITE:/ |Value of row { sy-tabix } is { ls }|.
*ENDLOOP.

*DATA(run_table) = VALUE tt_c1(
*  FOR i = 0 UNTIL i >= no_char ( inp+i(1) )
*).
*
*LOOP AT run_table INTO DATA(ls).
*  WRITE:/ |Value of row { sy-tabix } is { ls }|.
*ENDLOOP.

*&---------------------------------------------------------------------*
*& New Syntax 16 VALUE Expression
*&---------------------------------------------------------------------*
*TYPES: BEGIN OF ty_po,
*         ebeln TYPE ebeln,
*         lifnr TYPE lifnr,
*         risk  TYPE flag,
*       END OF ty_po.
*
*TYPES: tt_po TYPE TABLE OF ty_po WITH DEFAULT KEY.

*DATA: itab TYPE STANDARD TABLE OF ty_po.

* 1 VALUE with #
* # means the field name and type would be derived from LHS
* itab table will be the structure of the rows in VALUE #

*itab = VALUE #(
*  ( ebeln = 11 lifnr = 'Vendor 1' risk = ''  )
*  ( ebeln = 21 lifnr = 'Vendor 2' risk = 'X' )
*  ( ebeln = 31 lifnr = 'Vendor 3' risk = 'X' )
*).
*
*cl_demo_output=>display( itab ).

* 2 VALUE with no #
* VALUE without # means the structure would be derived from RHS table TYPE ( tt_po )

*DATA(run_table) = VALUE tt_po(
*  ( ebeln = 11 lifnr = 'Vendor 1' risk = ''  )
*  ( ebeln = 21 lifnr = 'Vendor 2' risk = 'X' )
*  ( ebeln = 31 lifnr = 'Vendor 3' risk = 'X' )
*).
*
*cl_demo_output=>display( run_table ).

*&---------------------------------------------------------------------*
*& New Syntax 15 DATE
*&---------------------------------------------------------------------*
*DATA p_date TYPE sy-datum VALUE '20180527'.
*
*WRITE:/ |Original date: { p_date }|.
*WRITE:/ |ISO format: { p_date DATE = ISO }|.
*WRITE:/ |User format: { p_date DATE = USER }|.

*&---------------------------------------------------------------------*
*& New Syntax 14 ALPHA
*&---------------------------------------------------------------------*
*DATA(lv_matnr) = '000000001012398019'.
*
*WRITE:/ |Before conversion: { lv_matnr }|.
*
**lv_matnr = |{ lv_matnr ALPHA = OUT }|.
**WRITE:/ |After Alpha Conversion OUT: { lv_matnr }|.
*
*WRITE:/ |After Alpha Conversion OUT: { lv_matnr ALPHA = OUT }|.
*
**lv_matnr = |{ lv_matnr ALPHA = IN }|.
**WRITE:/ |After Alpha Conversion IN: { lv_matnr }|.
*
*WRITE:/ |After Alpha Conversion IN: { lv_matnr ALPHA = IN }|.

*&---------------------------------------------------------------------*
*& New Syntax 13 BOOLC
*&---------------------------------------------------------------------*
*SELECT po~ebeln, po~ebelp, po~matnr, po~werks, po~brtwr, plant~land1, plant~regio
*  INTO TABLE @DATA(li_po)
*  FROM ekpo AS po
*  INNER JOIN t001w AS plant
*  ON po~werks = plant~werks
*  ORDER BY ebeln.
*
*IF sy-subrc EQ 0.
*  LOOP AT li_po INTO DATA(ls_po).
*    IF boolc( ls_po-brtwr > 5000 ) = abap_true.
*      WRITE:/ |PO { ls_po-ebeln } is extra sensitive|.
*    ELSEIF boolc( ls_po-brtwr > 1000 ) = abap_true.
*      WRITE:/ |PO { ls_po-ebeln } is sensitive|.
*    ELSE.
*      WRITE:/ |PO { ls_po-ebeln } is normal|.
*    ENDIF.
*  ENDLOOP.
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 12 RIGHT OUTER JOIN
*&---------------------------------------------------------------------*
*SELECT p~werks, v~bwkey INTO TABLE @DATA(li_plant_valuation)
*  FROM t001w AS p
*  RIGHT OUTER JOIN t001k AS v ON p~werks = v~bwkey. "Delete one record from table T001W
*
*IF sy-subrc EQ 0.
*  LOOP AT li_plant_valuation INTO DATA(lwa).
*    WRITE:/ |Plant = { lwa-werks }, Valuation area = { lwa-bwkey }|.
*  ENDLOOP.
*
*  WRITE:/ |No. of entries in internal table = { lines( li_plant_valuation ) }|.
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 11 CASES in SELECT
*&---------------------------------------------------------------------*
*SELECT ebeln, ebelp, matnr, werks,
*  CASE loekz                           "Simple Case
*    WHEN ' ' THEN 'Active'
*    WHEN 'L' THEN 'Deleted'
*    ELSE 'Doubtful'
*  END AS status,
*  CASE                                 "Search Case
*    WHEN brtwr > 5000 THEN 'Extra sensitive PO'
*    WHEN brtwr > 1000 THEN 'Sensitive PO'
*    ELSE 'Normal PO'
*  END AS po_sensitivity
*  FROM ekpo INTO TABLE @DATA(li_po) ORDER BY ebeln.
*
*IF sy-subrc EQ 0.
*  LOOP AT li_po INTO DATA(lwa).
*    WRITE:/ lwa-ebeln, lwa-status, lwa-po_sensitivity.
*  ENDLOOP.
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 10 COALESCE
*&---------------------------------------------------------------------*
SELECT p~werks, v~bwkey, COALESCE( p~werks, v~bwkey ) AS coal_plant
  INTO TABLE @DATA(li_valuation_plant) FROM t001k AS v
  LEFT OUTER JOIN t001w AS p ON v~bwkey = p~werks. "Delete one record from table T001W

IF sy-subrc EQ 0.
  LOOP AT li_valuation_plant INTO DATA(lwa).
    WRITE:/ |Plant = { lwa-werks }, Valuation = { lwa-bwkey }, Coalesce = { lwa-coal_plant }|.
  ENDLOOP.
ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 9 CEIL FLOOR
*&---------------------------------------------------------------------*
*DATA: lv_discount TYPE p LENGTH 4 DECIMALS 4 VALUE '0.912',
*      lv_tax      TYPE p LENGTH 2 DECIMALS 2 VALUE '2.0'.
*
*SELECT ebeln, ebelp, brtwr, brtwr * @lv_discount AS dis_price,
*  ceil( brtwr * @lv_discount ) AS ceil_dis_price,
*  floor( brtwr * @lv_discount ) AS floor_dis_price
*  FROM ekpo INTO TABLE @DATA(li_po)
*  ORDER BY ebeln, ebelp.
*
*IF sy-subrc EQ 0.
*  LOOP AT li_po ASSIGNING FIELD-SYMBOL(<lf_po>).
*    WRITE:/ <lf_po>-ebeln, <lf_po>-ebelp.
*    WRITE:/ |Original price = { <lf_po>-brtwr }, Discounted price = { <lf_po>-dis_price }|.
*    WRITE:/ |Ceil discounted price = { <lf_po>-ceil_dis_price }, Floor Discounted price = { <lf_po>-floor_dis_price }|.
*  ENDLOOP.
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 8 Arithmetic Expression in SELECT Query
*&---------------------------------------------------------------------*
*DATA: lv_discount TYPE p LENGTH 2 DECIMALS 2 VALUE '0.9',
*      lv_tax      TYPE p LENGTH 2 DECIMALS 2 VALUE '2.0'.
*
*SELECT ebeln, ebelp, brtwr, brtwr * @lv_discount AS dis_price, brtwr + @lv_tax AS tax_incl
*  FROM ekpo INTO TABLE @DATA(li_po)
*  ORDER BY ebeln, ebelp.
*
*IF sy-subrc EQ 0.
*  LOOP AT li_po ASSIGNING FIELD-SYMBOL(<lf_po>).
*    WRITE:/ <lf_po>-ebeln, <lf_po>-ebelp.
*    WRITE:/ |Original price = { <lf_po>-brtwr }, Discounted price = { <lf_po>-dis_price }, Total taxable price = { <lf_po>-tax_incl }|.
*  ENDLOOP.
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 7 HAVING Clause
*&---------------------------------------------------------------------*
*TABLES ekpo.
*SELECT-OPTIONS s_matnr FOR ekpo-matnr.
*PARAMETERS p_ebeln TYPE ekpo-ebeln.
*
*SELECT ebeln, matnr,
*  MAX( brtwr ) AS max_price,
*  SUM( brtwr ) AS tot_price,
*  AVG( brtwr ) As avg_price
*  FROM ekpo INTO TABLE @DATA(li_po)
*  GROUP BY ebeln, matnr
*  HAVING matnr IN @s_matnr AND ebeln LT @p_ebeln
*  ORDER BY ebeln, matnr.
*
*IF sy-subrc EQ 0.                   "Try PO - 4500000105
*  LOOP AT li_po INTO DATA(wa_po).
*    WRITE:/ |For PO { wa_po-ebeln } & Material { wa_po-matnr }:|.
*    WRITE:/ |Maximum Price = { wa_po-max_price }, Total Price = { wa_po-tot_price }, Average Price = { wa_po-avg_price }|.
*  ENDLOOP.
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 6 AGGREGATE Functions
*&---------------------------------------------------------------------*
*SELECT ebeln, matnr,
*  MAX( brtwr ) AS max_price,
*  SUM( brtwr ) AS tot_price,
*  AVG( brtwr ) As avg_price
*  FROM ekpo INTO TABLE @DATA(li_po)
*  GROUP BY ebeln, matnr
*  ORDER BY ebeln, matnr.
*
*IF sy-subrc EQ 0.                   "Try PO - 4500000105
*  LOOP AT li_po INTO DATA(wa_po).
*    WRITE:/ |For PO { wa_po-ebeln } & Material { wa_po-matnr }:|.
*    WRITE:/ |Maximum Price = { wa_po-max_price }, Total Price = { wa_po-tot_price }, Average Price = { wa_po-avg_price }|.
*  ENDLOOP.
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 5 CLIENT SPECIFIED replaced with USING CLIENT
*&---------------------------------------------------------------------*
*SELECT mandt, werks, regio, name1 UP TO 10 ROWS INTO TABLE @DATA(it_plant)
*  FROM t001w CLIENT SPECIFIED WHERE mandt = '250' AND fabkl = 'IT'.
*
*SELECT mandt, werks, regio, name1 UP TO 10 ROWS INTO TABLE @DATA(it_plant)
*  FROM t001w USING CLIENT '350' WHERE fabkl = 'IT'. "Use '350' as an example
*IF sy-subrc EQ 0.
*
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 4 CONCATENATE using Pipe (||)
*&---------------------------------------------------------------------*
*SELECT mandt, werks, regio, name1 UP TO 10 ROWS FROM t001w
*  INTO TABLE @DATA(it_plant).
*IF sy-subrc EQ 0.
*  LOOP AT it_plant INTO DATA(wa_plant).
**    CONCATENATE wa_plant-werks '->' wa_plant-name1 INTO wa_plant-name1
**      SEPARATED BY space.
**    WRITE:/ wa_plant-name1.
*    WRITE:/ |{ wa_plant-werks } -> { wa_plant-name1 }|.
*    WRITE:/ |This is Loop { sy-tabix }|.
*    WRITE:/ |This is Loop | && |{ sy-tabix }|.
*  ENDLOOP.
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 3 Comma in SELECT Query
*&---------------------------------------------------------------------*
*SELECT mandt, werks, regio, name1 UP TO 10 ROWS FROM t001w
*  INTO TABLE @DATA(it_plant).
*IF sy-subrc EQ 0.
*
*ENDIF.

*&---------------------------------------------------------------------*
*& New Syntax 2 String Literals in SELECT Queries
*&---------------------------------------------------------------------*
*TABLES: t001w.
*SELECT-OPTIONS: s_plant FOR t001w-werks.
*
*SELECT SINGLE 'Valid plant' FROM t001w INTO @DATA(lv_validity) "lv_validity created with type C(11)
*  WHERE werks IN @s_plant.
*IF sy-subrc NE 0.
*  lv_validity = 'This is an invalid plant'.
*ENDIF.
*WRITE:/ lv_validity.

*&---------------------------------------------------------------------*
*& New Syntax 1 Inline Declaration
*&---------------------------------------------------------------------*
*DATA: it_mara TYPE STANDARD TABLE OF mara,
*      wa_mara TYPE mara.
*
*SELECT * FROM mara INTO TABLE it_mara
*  UP TO 10 ROWS.

*SELECT * FROM mara INTO TABLE @DATA(it_mara)
*  UP TO 10 ROWS.
*
*LOOP AT it_mara INTO DATA(wa_mara).
*
*ENDLOOP.
