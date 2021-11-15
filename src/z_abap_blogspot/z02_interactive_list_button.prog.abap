*&---------------------------------------------------------------------*
*& Report Z02_INTERACTIVE_LIST_BUTTON
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_interactive_list_button.

*-------Declaring database tables for using the line type--------------*
TABLES: lfa1, ekko, ekpo.

*------Declaring structures for work area & Internal table-------------*
TYPES: BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         land1 TYPE lfa1-land1,
         name1 TYPE lfa1-name1,
         regio TYPE lfa1-regio,
       END OF ty_lfa1,

       BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         aedat TYPE ekko-aedat,
         ernam TYPE ekko-ernam,
         lifnr TYPE ekko-lifnr,
       END OF ty_ekko,

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         lgort TYPE ekpo-lgort,
       END OF ty_ekpo.

*-----Declaring Work Areas---------------------------------------------*
DATA: wa_lfa1 TYPE ty_lfa1,
      wa_ekko TYPE ty_ekko,
      wa_ekpo TYPE ty_ekpo,

*-----Declaring Internal Tables----------------------------------------*
      it_lfa1 TYPE TABLE OF ty_lfa1,
      it_ekko TYPE TABLE OF ty_ekko,
      it_ekpo TYPE TABLE OF ty_ekpo.

*---Event Initialization-----------------------------------------------*
INITIALIZATION.
  SELECT-OPTIONS: s_lifnr FOR lfa1-lifnr.

*---Event Start of Selection-------------------------------------------*
START-OF-SELECTION.
  PERFORM get_data_lfa1.
  SET PF-STATUS 'PUSH_BUTTON'. "Setting PF status for Push Buttons

*---Event At User Command----------------------------------------------*
AT USER-COMMAND. "When user clicks any button

  CASE sy-ucomm. "It contains the function code of any button
    WHEN 'EKKO'. "Push button Purchase Order
      PERFORM get_data_ekko.

    WHEN 'EKPO'. "Push button Purchase Order Item
      PERFORM get_data_ekpo.

    WHEN 'EXIT'. "Push button Exit
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'. "Push button Cancel
      LEAVE TO SCREEN 0.
  ENDCASE.

*---Event Top of Page for Basic List-----------------------------------*
TOP-OF-PAGE.
  PERFORM top_basic_lfa1.

*---Event Top of Page During Line Selection for Drilled List-----------*
TOP-OF-PAGE DURING LINE-SELECTION.
  CASE sy-lsind. "It counts the drilled number
    WHEN '1'.
      PERFORM top_ekko.
    WHEN '2'.
      PERFORM top_ekpo.
  ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA_LFA1
*&---------------------------------------------------------------------*
*       Select data from Vendor table
*----------------------------------------------------------------------*
FORM get_data_lfa1.

  REFRESH it_lfa1.

  IF s_lifnr[] IS NOT INITIAL.
    SELECT lifnr land1 name1 regio
      FROM lfa1 INTO TABLE it_lfa1
      WHERE lifnr IN s_lifnr.

    IF sy-subrc = 0.
      LOOP AT it_lfa1 INTO wa_lfa1.
        WRITE: / wa_lfa1-lifnr,
              20 wa_lfa1-land1,
              25 wa_lfa1-name1,
              65 wa_lfa1-regio.

        HIDE wa_lfa1-lifnr. "Vendor is keeping Hide to store the data
                            "into system temporarily
        AT LAST.
          SKIP 2.
          WRITE: /25 'End of Vendor Account List'.
        ENDAT.
      ENDLOOP.

    ELSE.
      MESSAGE 'Vendor doesn''t exist' TYPE 'I'.
    ENDIF.
  ELSE.
    MESSAGE 'Please enter a valid Vendor Account Number' TYPE 'I'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.                    "GET_DATA_LFA1

*&---------------------------------------------------------------------*
*&      Form  get_data_ekko
*&---------------------------------------------------------------------*
*       Select data from Purchase Order Header table
*----------------------------------------------------------------------*
FORM get_data_ekko.

  REFRESH it_ekko.

  IF wa_lfa1-lifnr IS NOT INITIAL.
    SELECT ebeln bukrs aedat ernam lifnr
      FROM ekko INTO TABLE it_ekko
      WHERE lifnr = wa_lfa1-lifnr.

    IF sy-subrc = 0.
      LOOP AT it_ekko INTO wa_ekko.
        WRITE: / wa_ekko-ebeln,
              15 wa_ekko-bukrs,
              22 wa_ekko-aedat,
              34 wa_ekko-ernam,
              50 wa_ekko-lifnr.

        HIDE wa_ekko-ebeln. "PO is keeping Hide to store the data
                            "into system temporarily
        AT LAST.
          SKIP 2.
          WRITE: /20 'End of Purchase Order List'.
        ENDAT.
      ENDLOOP.
    ELSE.
      MESSAGE 'Purchase Order doesn''t exist' TYPE 'I'.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_data_ekko

*&---------------------------------------------------------------------*
*&      Form  get_data_ekpo
*&---------------------------------------------------------------------*
*       Select data from Purchase Order Item Table
*----------------------------------------------------------------------*
FORM get_data_ekpo.

  REFRESH it_ekpo.

  IF wa_ekko-ebeln IS NOT INITIAL.
    SELECT ebeln ebelp matnr werks lgort
      FROM ekpo INTO TABLE it_ekpo
      WHERE ebeln = wa_ekko-ebeln.

    IF sy-subrc = 0.
      LOOP AT it_ekpo INTO wa_ekpo.
        WRITE: / wa_ekpo-ebeln,
              15 wa_ekpo-ebelp,
              22 wa_ekpo-matnr,
              42 wa_ekpo-werks,
              50 wa_ekpo-lgort.

        AT LAST.
          SKIP 2.
          WRITE: /25 'End of Material List'.
        ENDAT.
      ENDLOOP.
    ENDIF.
  ELSE.
    MESSAGE 'Select a Purchase Order' TYPE 'I'.
  ENDIF.

ENDFORM.                    " get_data_ekpo

*&---------------------------------------------------------------------*
*&      Form  top_basic_lfa1
*&---------------------------------------------------------------------*
*       Top of page of basic list - Vendor list
*----------------------------------------------------------------------*
FORM top_basic_lfa1 .

  WRITE: / 'Vendor Account List' COLOR 3.
  WRITE: / 'Vendor Account',
        20 'Land',
        25 'Name',
        65 'Region'.

ENDFORM.                    " top_basic_lfa1

*&---------------------------------------------------------------------*
*&      Form  top_ekko
*&---------------------------------------------------------------------*
*       Top of page for first secondary list - PO header list
*----------------------------------------------------------------------*
FORM top_ekko .

  WRITE: / 'Purchase Order List' COLOR 5.
  WRITE: / 'Po Number',
        15 'Company',
        22 'Date',
        34 'Name',
        50 'Vendor Account Number'.

ENDFORM.                    " top_ekko

*&---------------------------------------------------------------------*
*&      Form  top_ekpo
*&---------------------------------------------------------------------*
*       Top of page for second secondary list - PO item list
*----------------------------------------------------------------------*
FORM top_ekpo .

  WRITE: / 'Purchase Order List' COLOR 1.
  WRITE: / 'PO Number',
        15 'PO Item',
        22 'Material',
        42 'Plant',
        50 'Storage'.

ENDFORM.                    " top_ekpo
