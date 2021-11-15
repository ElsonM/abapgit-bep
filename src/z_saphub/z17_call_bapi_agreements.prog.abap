*&---------------------------------------------------------------------*
*& Report Z17_CALL_BAPI_AGREEMENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z17_call_bapi_agreements.

*&---------------------------------------------------------------------*
*& Data Declaration
*&---------------------------------------------------------------------*
DATA: gt_bapi_agreements  TYPE TABLE OF bapiagrmnt.
DATA: gt_bapiret2         TYPE TABLE OF bapiret2.
DATA: gt_bapiknumas       TYPE TABLE OF bapiknumas.
DATA: gwa_bapi_agreements TYPE bapiagrmnt.
DATA: gwa_bapiret2        TYPE bapiret2.
DATA: gwa_bapiknumas      TYPE bapiknumas.

*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
PARAMETERS: p_vkorg TYPE bapiagrmnt-sales_org  OBLIGATORY,
            p_vtweg TYPE bapiagrmnt-distr_chan OBLIGATORY,
            p_spart TYPE bapiagrmnt-division   OBLIGATORY,
            p_auart TYPE bapiagrmnt-agr_type   OBLIGATORY,
            p_kunnr TYPE bapiagrmnt-recipient  OBLIGATORY,
            p_waers TYPE bapiagrmnt-agrmt_curr OBLIGATORY,
            p_grp   TYPE bapiagrmnt-cond_group OBLIGATORY.

*&---------------------------------------------------------------------*
*& Start of Selection
*&---------------------------------------------------------------------*
START-OF-SELECTION.

**Fill Rebate agreement details
  gwa_bapi_agreements-agree_cond = '$00001'.
  gwa_bapi_agreements-sales_org  = p_vkorg.
  gwa_bapi_agreements-distr_chan = p_vtweg.
  gwa_bapi_agreements-division   = p_spart.
  gwa_bapi_agreements-agr_type   = p_auart.
  gwa_bapi_agreements-recipient  = p_kunnr.
  gwa_bapi_agreements-agrmt_curr = p_waers.
  gwa_bapi_agreements-valid_from = sy-datum.
  gwa_bapi_agreements-valid_to   = '99991231'.
  gwa_bapi_agreements-operation  = '009'.
  gwa_bapi_agreements-category   = 'A'.
  gwa_bapi_agreements-applicatio = 'V'.
  gwa_bapi_agreements-cond_group = p_grp.

  APPEND gwa_bapi_agreements TO gt_bapi_agreements.

**Create Rebate agreement
  CALL FUNCTION 'BAPI_AGREEMENTS'
    TABLES
      ti_bapiagrmnt = gt_bapi_agreements
      to_bapiret2   = gt_bapiret2
      to_bapiknumas = gt_bapiknumas
    EXCEPTIONS
      update_error  = 1
      OTHERS        = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF gt_bapiknumas IS NOT INITIAL.

****Display Rebate agreement number
    READ TABLE gt_bapiknumas INTO gwa_bapiknumas INDEX 1.
    IF sy-subrc = 0.
      WRITE:/ 'Rebate Agreement', gwa_bapiknumas-agr_no_new,
              'Created'.
    ENDIF.

  ELSE.

****Display error
    READ TABLE gt_bapiret2 INTO gwa_bapiret2 WITH KEY type = 'E'.
    IF sy-subrc EQ 0.
      WRITE:/ gwa_bapiret2-message.
    ENDIF.

  ENDIF.
