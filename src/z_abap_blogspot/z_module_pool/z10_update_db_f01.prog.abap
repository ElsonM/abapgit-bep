*&---------------------------------------------------------------------*
*&  Include           Z10_UPDATE_DB_F01
*&---------------------------------------------------------------------*

FORM get_customer.

  IF zcustomers_mod_p-id IS NOT INITIAL.
    SELECT SINGLE *
      FROM zcustomers_mod_p INTO wa_cust
      WHERE id = zcustomers_mod_p-id.

    IF sy-subrc = 0.
      CALL SCREEN 9002.
    ELSE.
      MESSAGE 'Customer doesn''t exist' TYPE 'I'.
    ENDIF.
  ELSE.
    MESSAGE 'Enter a Customer Number' TYPE 'I'.
  ENDIF.

ENDFORM.                    " get_customer

FORM create_customer.

  IF zcustomers_mod_p-id IS NOT INITIAL.

    "Validation is needed if customer is already present
    SELECT SINGLE *
      FROM zcustomers_mod_p INTO wa_cust
      WHERE id = zcustomers_mod_p-id.

    IF sy-subrc = 0. "It means customer is already in database
      MESSAGE 'Customer already exist' TYPE 'I'.
    ELSE. "It means customer is not present in the database
      "Hence it needs to be created
      CLEAR: wa_cust, zcustomers_mod_p-name, zcustomers_mod_p-address.
      "Only zcustomers_mod_p-id needs to be passed to screen 9002
      CALL SCREEN 9002.
    ENDIF.

  ELSE.
    MESSAGE 'Enter a Customer Number' TYPE 'S'.
  ENDIF.

ENDFORM.                    " create_customer

FORM customer_output.

  IF wa_cust IS NOT INITIAL.

    "Screen fields       Work area fields
    zcustomers_mod_p-id      = wa_cust-id.
    zcustomers_mod_p-name    = wa_cust-name.
    zcustomers_mod_p-address = wa_cust-address.
  ENDIF.

ENDFORM.                    " customer_output

FORM update_customer.

  IF zcustomers_mod_p-id IS NOT INITIAL.

    "Passing the values to the internal work area
    wa_cust-id      = zcustomers_mod_p-id.
    wa_cust-name    = zcustomers_mod_p-name.
    wa_cust-address = zcustomers_mod_p-address.

    IF ok_code1 = 'CRT'.

      "Inserting new Customer into database while creating
      INSERT zcustomers_mod_p FROM wa_cust.

    ELSE.

      "Updating the database by using the work area
      UPDATE zcustomers_mod_p FROM wa_cust.

    ENDIF.

    IF sy-subrc = 0. "If the update is successful
      MESSAGE 'Customer details updated successfully' TYPE 'S'.
    ELSE. "If the update is not successful
      MESSAGE 'Customer is not updated' TYPE 'E'.
    ENDIF.

  ENDIF.

ENDFORM.                    " update_customer

FORM delete_customer.

  IF zcustomers_mod_p IS NOT INITIAL.

    "Work area fields     Screen fields
    wa_cust-id          = zcustomers_mod_p-id.
    wa_cust-name        = zcustomers_mod_p-name.
    wa_cust-address     = zcustomers_mod_p-address.

    "Delete data records from database table
    DELETE zcustomers_mod_p FROM wa_cust.

    IF sy-subrc = 0. "If deletion is successful
      CLEAR: wa_cust, zcustomers_mod_p.
      MESSAGE 'Data has been removed successfully' TYPE 'S'.
      LEAVE TO SCREEN 9001.

    ELSE. "If deletion is not successful
      MESSAGE 'Data has not been removed' TYPE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.                    " delete_customer
