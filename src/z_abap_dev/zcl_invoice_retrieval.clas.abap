"!<p class="shorttext synchronized">Global Class to retrieve Invoices</p>
"! <ol>
"!    <li>Reads Invoices</li>
"!    <li>Changes value of payment status</li>
"! </ol>
"! The default value is {@link ..DATA:'Test'}
CLASS zcl_invoice_retrieval DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "!<p class="shorttext synchronized">Table type of Invoices</p>
    TYPES: ty_table_of_zso_invoice_item TYPE STANDARD TABLE OF zso_invoice_item WITH DEFAULT KEY.
    "! <p class="shorttext synchronized"> Method reads invoices</p>
    METHODS get_items_from_db
      RETURNING
        VALUE(lt_result) TYPE ty_table_of_zso_invoice_item.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_INVOICE_RETRIEVAL IMPLEMENTATION.


  METHOD get_items_from_db.

    SELECT
     snwd_bpa~company_name,
     snwd_so_inv_item~gross_amount,
     snwd_so_inv_item~currency_code,
     snwd_so_inv_head~payment_status

   FROM
    snwd_so_inv_item
    JOIN snwd_so_inv_head ON snwd_so_inv_item~parent_key = snwd_so_inv_head~node_key
    JOIN snwd_bpa ON snwd_so_inv_head~buyer_guid = snwd_bpa~node_key

   WHERE
    snwd_so_inv_item~currency_code = 'USD'

   ORDER BY
    snwd_bpa~company_name

   INTO TABLE @lt_result.

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<entry>).
      CASE <entry>-payment_status.
        WHEN 'P'.
          <entry>-payment_status = abap_true.
        WHEN OTHERS.
          <entry>-payment_status = abap_false.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
