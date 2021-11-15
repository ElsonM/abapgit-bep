class ZCL_AOA_ADDR_DISPLAY definition
  public
  abstract
  create public .

public section.

  methods CONSTRUCTOR .
PROTECTED SECTION.

  TYPES:
    BEGIN OF doc_list_rec,
      partner_id   TYPE jv_part,
      doc_number   TYPE vbeln,
      partner_name TYPE name1_gp,
      adrnr        TYPE adrnr,
    END OF doc_list_rec.
  TYPES:
    doc_list_tab
        TYPE SORTED TABLE OF doc_list_rec
        WITH NON-UNIQUE KEY partner_id
        INITIAL SIZE 0.
  TYPES:
    BEGIN OF address_rec,
      street TYPE ad_street,
      city   TYPE ad_city1,
      state  TYPE regio,
      zip    TYPE ad_pstcd1,
    END OF address_rec .
  TYPES:
    BEGIN OF output_rec,
      doc_number   TYPE vbeln,
      partner_name TYPE name1_gp,
      street       TYPE ad_street,
      city         TYPE ad_city1,
      state        TYPE regio,
      zip          TYPE ad_pstcd1,
    END OF output_rec .
  TYPES:
    output_tab
        TYPE STANDARD TABLE OF output_rec
        WITH DEFAULT KEY
        INITIAL SIZE 0 .

  DATA mt_documents TYPE doc_list_tab .
  DATA mt_output TYPE output_tab .
  DATA mo_alv TYPE REF TO cl_salv_table .
  DATA mo_log TYPE REF TO cl_cmd_appllog .
  DATA ms_log_key TYPE cmd_s_logkey .
  DATA ms_log_message_params TYPE cmd_s_msgadd .
  DATA mv_log_handle TYPE balloghndl .
  DATA mv_msg_handle TYPE cmd_s_msghndl .
  DATA mv_msg_handle_orig TYPE cmd_s_msghndl .
  DATA mv_freetext TYPE cmd_logchar200 .
  CONSTANTS mc_error TYPE symsgty VALUE 'E' ##NO_TEXT.
  CONSTANTS mc_info TYPE symsgty VALUE 'I' ##NO_TEXT.
  CONSTANTS mc_warning TYPE symsgty VALUE 'W' ##NO_TEXT.
  CONSTANTS mc_pc_vimportant TYPE balprobcl VALUE '1' ##NO_TEXT.
  CONSTANTS mc_pc_important TYPE balprobcl VALUE '2' ##NO_TEXT.
  CONSTANTS mc_pc_medium TYPE balprobcl VALUE '3' ##NO_TEXT.
  CONSTANTS mc_pc_info TYPE balprobcl VALUE '4' ##NO_TEXT.
  CONSTANTS mc_detl_1 TYPE ballevel VALUE '1' ##NO_TEXT.
  CONSTANTS mc_detl_2 TYPE ballevel VALUE '2' ##NO_TEXT.
  CONSTANTS mc_detl_3 TYPE ballevel VALUE '3' ##NO_TEXT.
  CONSTANTS mc_detl_4 TYPE ballevel VALUE '4' ##NO_TEXT.

  METHODS read_sales_orders
    IMPORTING
      !it_dates           TYPE range_t_dats
    RETURNING
      VALUE(rt_documents) TYPE doc_list_tab
    RAISING
      zcx_aoa .
  METHODS read_purchase_orders
    IMPORTING
      !it_dates           TYPE range_t_dats
    RETURNING
      VALUE(rt_documents) TYPE doc_list_tab
    RAISING
      zcx_aoa .
  METHODS get_address
    IMPORTING
      !iv_adrnr         TYPE adrnr
    RETURNING
      VALUE(rs_address) TYPE address_rec
    RAISING
      zcx_aoa .
  METHODS create_alv
    EXPORTING
      !er_alv  TYPE REF TO cl_salv_table
    CHANGING
      !ct_data TYPE STANDARD TABLE
    RAISING
      zcx_aoa .
  METHODS set_column_header
    IMPORTING
      !iv_name TYPE lvc_fname
      !iv_text TYPE text132
    CHANGING
      !cr_alv  TYPE REF TO cl_salv_table .
  METHODS build_output
    RAISING
      zcx_aoa .
private section.
ENDCLASS.



CLASS ZCL_AOA_ADDR_DISPLAY IMPLEMENTATION.


  METHOD build_output.

    DATA:
*     Exception object
      lo_error TYPE REF TO zcx_aoa,
*     Address data structure
      ls_address TYPE address_rec,
*     Output data structure work area
      lwa_output TYPE output_rec.

    FIELD-SYMBOLS:
*   Input document data row
      <lwa_input> TYPE doc_list_rec.

*   Process input documents
    LOOP AT mt_documents ASSIGNING <lwa_input>.

      AT NEW partner_id.
*       Generate application log entry if log used
        IF mo_log IS BOUND.
          mv_freetext = TEXT-t01 && | | && <lwa_input>-partner_id.
*                       --> Processing Partner ID
          TRY.
              mo_log->set_message_freetext(
                EXPORTING
                  iv_msgtype    = mc_info
                  iv_probcl     = mc_pc_medium
                  iv_freetext   = mv_freetext
                  is_msgadd     = ms_log_message_params
                  iv_detlevel   = mc_detl_2
                IMPORTING
                  es_msg_handle = mv_msg_handle ).
            CATCH cx_cmd_log_wrong_call.
*             Ignore!
          ENDTRY.
        ENDIF.

*       Read partner address
        TRY.
            ls_address = get_address( <lwa_input>-adrnr ).
          CATCH zcx_aoa INTO lo_error.
*           Write exception text to application log if log used
            IF mo_log IS BOUND.
              TRY.
                  mo_log->set_exception(
                    EXPORTING
                      iv_msgtype           = mc_warning
                      iv_probcl            = mc_pc_info
                      ir_exception         = lo_error
                      is_excadd            = ms_log_message_params
                      iv_detlevel          = mc_detl_3
                    IMPORTING
                      es_msg_handle        = mv_msg_handle
                      es_msg_handle_origin = mv_msg_handle_orig ).
                CATCH cx_cmd_log_wrong_call.
*                 Ignore!
              ENDTRY.
            ENDIF.

*           Set address to "Unknown" if no address returned
            CLEAR ls_address.
            ls_address-street = TEXT-e01.
*                               --> Unknown address
        ENDTRY.
      ENDAT.

*     Transfer data to output work area and add to table
      MOVE-CORRESPONDING <lwa_input> TO lwa_output.
      MOVE-CORRESPONDING ls_address TO lwa_output.
      APPEND lwa_output TO mt_output.

    ENDLOOP.

*   Create ALV object
    create_alv(
      IMPORTING
        er_alv = mo_alv
      CHANGING
        ct_data = mt_output ).

  ENDMETHOD.


  METHOD constructor.

*   Set default application log message parameters
    ms_log_message_params-lifetime = cl_cmd_appllog=>gc_permanent.
    ms_log_message_params-category = cl_cmd_appllog=>gc_process.
    ms_log_message_params-msgkind  = cl_cmd_appllog=>gc_msgkind_all.

  ENDMETHOD.


  METHOD create_alv.

    DATA:
*     Generic error objects
      lo_error TYPE REF TO cx_salv_msg,
      lv_error TYPE string.

    TRY.
*       Create ALV object
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = er_alv
          CHANGING
            t_table = ct_data ).
      CATCH cx_salv_msg INTO lo_error.
*       Map ALV exception to standard exception object
        lv_error = lo_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid    = zcx_aoa=>dynamic_error
            long_text = lv_error.
    ENDTRY.

  ENDMETHOD.


  METHOD get_address.

*   Read address data
    SELECT SINGLE street city1 region post_code1
      INTO rs_address
      FROM adrc
      WHERE addrnumber = iv_adrnr AND
            date_from <= sy-datum.

*   Raise exception if no address found
    IF sy-subrc <> 0 OR
*      NOTE: IDES has empty address records!
       rs_address IS INITIAL.
      RAISE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid     = zcx_aoa=>no_address
          address_id = iv_adrnr.
    ENDIF.

  ENDMETHOD.


  METHOD read_purchase_orders.

*   Read purchase order & customer data
    SELECT purch~ebeln purch~lifnr vend~name1 vend~adrnr
      INTO TABLE rt_documents
      FROM ekko AS purch
      INNER JOIN lfa1 AS vend
      ON purch~lifnr = vend~lifnr
      WHERE purch~aedat IN it_dates.

*   Raise exception if no data found
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid = zcx_aoa=>no_data.
    ENDIF.

  ENDMETHOD.


  METHOD read_sales_orders.

*   Read sales order & customer data
    SELECT ord~kunnr ord~vbeln cust~name1 cust~adrnr
      INTO TABLE rt_documents
      FROM vbak AS ord INNER JOIN kna1 AS cust
        ON ord~kunnr = cust~kunnr
     WHERE ord~erdat IN it_dates.

*   Raise exception if no data found
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid = zcx_aoa=>no_data.
    ENDIF.

  ENDMETHOD.


  METHOD set_column_header.

    DATA:
*     ALV columns collection object
      lo_columns     TYPE REF TO cl_salv_columns_table,
*     Individual ALV column object
      lo_col         TYPE REF TO cl_salv_column,
*     ALV column header texts - short / medium / long
      lv_short_text  TYPE scrtext_s,
      lv_medium_text TYPE scrtext_m,
      lv_long_text   TYPE scrtext_l.

*   Get the columns collection
    lo_columns = cr_alv->get_columns( ).

*   Get the named column object
    TRY.
        lo_col = lo_columns->get_column( iv_name ).
      CATCH cx_salv_not_found.
*        Not a fatal error; column header will simply be unchanged!
        RETURN.
    ENDTRY.

*   Convert header text to correct formats
    lv_short_text  = iv_text.
    lv_medium_text = iv_text.
    lv_long_text   = iv_text.

*   Change headers to requested value
    lo_col->set_short_text( lv_short_text ).
    lo_col->set_medium_text( lv_medium_text ).
    lo_col->set_long_text( lv_long_text ).

  ENDMETHOD.
ENDCLASS.
