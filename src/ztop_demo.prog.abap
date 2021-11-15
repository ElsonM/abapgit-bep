*&---------------------------------------------------------------------*
*&  Include           ZTOP_DEMO
*&---------------------------------------------------------------------*

DATA: name  TYPE vrm_id,
      list  TYPE vrm_values,
      value LIKE LINE OF list.

DATA: wa_spfli TYPE spfli,
      ok_code  TYPE sy-ucomm,
      save_ok  TYPE sy-ucomm.

DATA p_connid TYPE demof4help-carrier2.

DATA: gt_list     TYPE vrm_values.
DATA: gwa_list    TYPE vrm_value.

name = 'P_CONNID'.
