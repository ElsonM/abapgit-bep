*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr21.

* Declaring line structure of database tables
TABLES: ekko, ekpo, t161t.

* Declaring local structures for internal table & work area
TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln, "Purchase Order
         bukrs TYPE ekko-bukrs, "Company Code
         bstyp TYPE ekko-bstyp, "Category
         bsart TYPE ekko-bsart, "Type
         lifnr TYPE ekko-lifnr, "Vendor
       END OF ty_ekko,

       BEGIN OF ty_text,
         spras TYPE t161t-spras,
         bsart TYPE t161t-bsart,
         bstyp TYPE t161t-bstyp,
         batxt TYPE t161t-batxt, "PO Info
       END OF ty_text,

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln, "Purchase Order
         ebelp TYPE ekpo-ebelp, "PO Item
         matnr TYPE ekpo-matnr, "Material
         werks TYPE ekpo-werks, "Plant
         lgort TYPE ekpo-lgort, "Storage Location
         matkl TYPE ekpo-matkl, "Material Group
         menge TYPE ekpo-menge, "Quantity
         meins TYPE ekpo-meins, "Unit
       END OF ty_ekpo,

       BEGIN OF ty_out1,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         bstyp TYPE ekko-bstyp,
         bsart TYPE ekko-bsart,
         lifnr TYPE ekko-lifnr,
         batxt TYPE t161t-batxt,
       END OF ty_out1.

* Declaring work area & internal table
DATA: wa_ekko  TYPE ty_ekko,                   "Header table work area
      it_ekko  TYPE STANDARD TABLE OF ty_ekko, "Header internal table
      wa_text  TYPE ty_text,                   "Info table work area
      it_text  TYPE STANDARD TABLE OF ty_text, "Info internal table
      wa_out1  TYPE ty_out1,                   "Basic output work area
      it_out1  TYPE STANDARD TABLE OF ty_out1, "Basic output internal table
      wa_ekpo  TYPE ty_ekpo,                   "Item table work area
      it_ekpo  TYPE STANDARD TABLE OF ty_ekpo, "Item internal table

      v_repid  TYPE sy-repid,
      v_user   TYPE sy-uname,
      v_date   TYPE sy-datum,

      v_field1 TYPE char40,
      v_field2 TYPE char40,
      v_value1 TYPE char40,
      v_value2 TYPE char40.

* Event Initialization
INITIALIZATION.
  v_repid = sy-repid. "Program Name
  v_user  = sy-uname. "User name
  v_date  = sy-datum. "Current Date

* Declaring selection screen
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_ebeln FOR ekko-ebeln OBLIGATORY.
  SELECTION-SCREEN END OF BLOCK b1.

* Event Start of Selection
START-OF-SELECTION.
  PERFORM get_ekko.     "Get data from header table
  PERFORM get_t161t.    "Get data from Info table
  PERFORM basic_output. "Preparing the primary output
  PERFORM disp_basic.   "Displaying output of first list

* Event At line selection for Double click operation
AT LINE-SELECTION.

* It passes the field and value to the current cursor position
* When double click is happened on the PO field of Primary list
  GET CURSOR FIELD v_field1 VALUE v_value1.

  CASE v_field1.
*   When we double click on PO number on Basic output list
    WHEN 'WA_OUT1-EBELN'.
      PERFORM get_ekpo.    "Get data from Item table
      PERFORM ekpo_output. "Displaying output of second list
  ENDCASE.

* It passes the field and value to the current cursor position
* When double click is happened on the Material field of Secondary list
  GET CURSOR FIELD v_field2 VALUE v_value2.

  CASE v_field2.
*   When we double click on Material on Second list
    WHEN 'WA_EKPO-MATNR'.
      PERFORM get_mara. "Get Information by calling MM03 Transaction
  ENDCASE.

* Event top of page for Basic list / Primary list
TOP-OF-PAGE.
  PERFORM top_page1.

* Event top of page for Second list
TOP-OF-PAGE DURING LINE-SELECTION.
  PERFORM top_page2.

*&---------------------------------------------------------------------*
*&      Form  get_ekko
*&---------------------------------------------------------------------*
*       Get data from header table
*----------------------------------------------------------------------*
FORM get_ekko.

* Selection of header table data
  SELECT ebeln bukrs bstyp bsart lifnr
    FROM ekko INTO TABLE it_ekko
    WHERE ebeln IN s_ebeln.

  IF sy-subrc = 0.
    SORT it_ekko BY ebeln.
  ELSE.
    MESSAGE 'Purchase Order doesn''t exist.' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.                    " get_ekko
*&---------------------------------------------------------------------*
*&      Form  get_t161t
*&---------------------------------------------------------------------*
*       Get data from Info table
*----------------------------------------------------------------------*
FORM get_t161t.

* Seelction of Info table data
  IF it_ekko IS NOT INITIAL.      "Prerequisite of For all Entries
    SELECT spras bsart bstyp batxt
    FROM t161t INTO TABLE it_text
    FOR ALL ENTRIES IN it_ekko
    WHERE spras = sy-langu        "System language at login time
      AND bsart = it_ekko-bsart
      AND bstyp = it_ekko-bstyp.

    IF sy-subrc = 0.
      SORT it_text BY bsart bstyp.
    ENDIF.
  ENDIF.

ENDFORM.                                                    " get_t161t

*&---------------------------------------------------------------------*
*&      Form  basic_output
*&---------------------------------------------------------------------*
*       Preparing the primary output
*----------------------------------------------------------------------*
FORM basic_output.

* Preparing the basic output table
  IF it_ekko IS NOT INITIAL.
    LOOP AT it_ekko INTO wa_ekko.
      wa_out1-ebeln = wa_ekko-ebeln.
      wa_out1-bukrs = wa_ekko-bukrs.
      wa_out1-bstyp = wa_ekko-bstyp.
      wa_out1-bsart = wa_ekko-bsart.
      wa_out1-lifnr = wa_ekko-lifnr.

      READ TABLE it_text INTO wa_text
      WITH KEY bsart = wa_ekko-bsart
               bstyp = wa_ekko-bstyp BINARY SEARCH.
      IF sy-subrc = 0.
        wa_out1-batxt = wa_text-batxt.
      ENDIF.

      APPEND wa_out1 TO it_out1.
      CLEAR: wa_out1, wa_ekko, wa_text.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " basic_output

*&---------------------------------------------------------------------*
*&      Form  disp_basic
*&---------------------------------------------------------------------*
*       Displaying output of first list
*----------------------------------------------------------------------*
FORM disp_basic.

  IF it_out1 IS NOT INITIAL.
    LOOP AT it_out1 INTO wa_out1.
      AT FIRST. "Control Break Statement - triggers at first
        WRITE: /  'Purchase Order',
               20 'Company',
               30 'Category',
               40 'Type',
               50 'Vendor',
               65 'PO Info.'.
        ULINE.
        SKIP.
      ENDAT.

      WRITE: /  wa_out1-ebeln,
             20 wa_out1-bukrs,
             33 wa_out1-bstyp,
             40 wa_out1-bsart,
             50 wa_out1-lifnr,
             65 wa_out1-batxt.

      AT LAST. "Control Break Statement - triggers at last
        SKIP.
        ULINE.
        WRITE: /12 '~~End of Report~~'.
      ENDAT.
    ENDLOOP.
  ENDIF.

ENDFORM.                    " disp_basic

*&---------------------------------------------------------------------*
*&      Form  get_ekpo
*&---------------------------------------------------------------------*
*       Get data from Item table
*----------------------------------------------------------------------*
FORM get_ekpo.

* Local temporary variable for conversion
  DATA: lv_ebeln TYPE ekko-ebeln.

  IF v_value1 IS NOT INITIAL.

*   To convert the value from output format to input format
*   and passing it from input format to output format
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = v_value1
      IMPORTING
        output = lv_ebeln.

    IF lv_ebeln IS NOT INITIAL.

*     Selection of Item table
      SELECT ebeln ebelp matnr werks lgort
             matkl menge meins
        FROM ekpo INTO TABLE it_ekpo
        WHERE ebeln = lv_ebeln.

      IF sy-subrc <> 0.
        MESSAGE 'PO Item doesn''t Exist.' TYPE 'I'.
        LEAVE LIST-PROCESSING.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_ekpo

*&---------------------------------------------------------------------*
*&      Form  ekpo_output
*&---------------------------------------------------------------------*
*       Displaying output of second list
*----------------------------------------------------------------------*
FORM ekpo_output.

* Preparing secondary output
  IF it_ekpo IS NOT INITIAL.
    LOOP AT it_ekpo INTO wa_ekpo.

      AT FIRST.
        WRITE: /  'Purchase Order',
               20 'PO Item',
               30 'Material',
               48 'Plant',
               55 'Storage',
               65 'Material Group',
               83 'PO Quantity',
              100 'Unit'.
        ULINE.
        SKIP.
      ENDAT.

      WRITE: /  wa_ekpo-ebeln,
             20 wa_ekpo-ebelp,
             30 wa_ekpo-matnr,
             48 wa_ekpo-werks,
             55 wa_ekpo-lgort,
             70 wa_ekpo-matkl,
             75 wa_ekpo-menge,
            100 wa_ekpo-meins.

      AT LAST.
        SKIP.
        ULINE.
        WRITE: /12 '~~End of PO Item~~'.
      ENDAT.

    ENDLOOP.
  ENDIF.

ENDFORM.                    " ekpo_output

*&---------------------------------------------------------------------*
*&      Form  get_mara
*&---------------------------------------------------------------------*
*       Get Information by calling MM03 Transaction
*----------------------------------------------------------------------*
FORM get_mara .

* Local temporary variable for conversion
  DATA: lv_matnr TYPE mara-matnr.

  IF v_value2 IS NOT INITIAL.

*   Converting material from output format to input format
*   and passing it from input format to output format
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = v_value2
      IMPORTING
        output       = lv_matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    IF lv_matnr IS NOT INITIAL.

*     Calling the MM03 transaction needs parameter ID
*     which is available on domain of MATNR
      SET PARAMETER ID 'MAT' FIELD lv_matnr.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_mara

*&---------------------------------------------------------------------*
*&      Form  top_page1
*&---------------------------------------------------------------------*
*       Event top of page for Basic list / Primary list
*----------------------------------------------------------------------*
FORM top_page1 .

  WRITE: / 'Purchase Order Header',
         / 'Date: ',   12 v_date DD/MM/YYYY,
         / 'User: ',   12 v_user,
         / 'Report: ', 12 v_repid.
  ULINE.
  SKIP.

ENDFORM.                                                    " top_page1

*&---------------------------------------------------------------------*
*&      Form  top_page2
*&---------------------------------------------------------------------*
*       Event top of page for Second list
*----------------------------------------------------------------------*
FORM top_page2 .

  WRITE: / 'Purchase Order Item List',
         / 'Date: ',   12 v_date DD/MM/YYYY,
         / 'User: ',   12 v_user,
         / 'Report: ', 12 v_repid.
  ULINE.
  SKIP.

ENDFORM.                                                    " top_page2
