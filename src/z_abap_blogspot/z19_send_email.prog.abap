*&---------------------------------------------------------------------*
*& Report Z19_SEND_EMAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z19_send_email NO STANDARD PAGE HEADING.

TABLES: ekko.

TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
       END OF ty_ekko.

DATA: wa_ekko       TYPE          ty_ekko,
      it_ekko       TYPE TABLE OF ty_ekko,

      lv_date       TYPE sy-datum,
      date_external TYPE char12,

      i_title       TYPE char100,
      i_recipient   TYPE char50.

START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM convert_date.
  PERFORM send_email.

*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       Fetch data of PO from EKKO
*----------------------------------------------------------------------*
FORM fetch_data.

  CLEAR lv_date.
  lv_date = sy-datum - 30.

  SELECT ebeln FROM ekko
    INTO TABLE it_ekko
    WHERE aedat GT lv_date.

  IF sy-subrc = 0.
    SORT it_ekko.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CONVERT_DATE
*&---------------------------------------------------------------------*
*       Convert date to External format
*----------------------------------------------------------------------*
FORM convert_date.

  CLEAR lv_date.
  CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
    EXPORTING
      date_internal            = sy-datum
    IMPORTING
      date_external            = date_external
    EXCEPTIONS
      date_internal_is_invalid = 1
      OTHERS                   = 2.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SEND_EMAIL
*&---------------------------------------------------------------------*
*       Sending mail
*----------------------------------------------------------------------*
FORM send_email.
  IF it_ekko IS NOT INITIAL.

    CONCATENATE 'Purchase Order List on:' date_external
      INTO i_title SEPARATED BY ' '.

    i_recipient = 'elson.meco@gmail.com'.

    CALL FUNCTION 'EFG_GEN_SEND_EMAIL'
      EXPORTING
        i_title                = i_title
        i_sender               = sy-uname
        i_recipient            = i_recipient
        i_flg_commit           = 'X'
        i_flg_send_immediately = 'X'
      TABLES
        i_tab_lines            = it_ekko
*       I_TAB_RECIPIENTS       =
      EXCEPTIONS
        not_qualified          = 1
        failed                 = 2
        OTHERS                 = 3.
  ENDIF.
ENDFORM.
