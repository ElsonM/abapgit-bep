*&---------------------------------------------------------------------*
*& Report Z_ELSON_T22_TABLE_CONTROL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t22_table_control.

TABLES: sflight.

TYPES: BEGIN OF ty_sflight,
         mark       TYPE c,
         carrid     TYPE s_carr_id,
         connid     TYPE s_conn_id,
         fldate     TYPE s_date,
         price      TYPE s_price,
         currency   TYPE s_currcode,
         planetype  TYPE s_planetye,
         seatsmax   TYPE s_seatsmax,
         seatsocc   TYPE s_seatsocc,
         paymentsum TYPE s_sum,
         seatsmax_b TYPE s_smax_b,
         seatsocc_b TYPE s_socc_b,
         seatsmax_f TYPE s_smax_f,
         seatsocc_f TYPE s_socc_b,
       END OF ty_sflight.

DATA: it_sflight TYPE TABLE OF ty_sflight,
      wa_sflight LIKE LINE OF  it_sflight.

START-OF-SELECTION.
  CALL SCREEN 9000.
* &SPWizard: Data incl. inserted by SP Wizard. DO NOT CHANGE THIS LINE!
  INCLUDE zinclude_table_control .
* &SPWizard: Include inserted by SP Wizard. DO NOT CHANGE THIS LINE!
  INCLUDE zinclude_table_control_pbo .
  INCLUDE zinclude_table_control_pai .
  INCLUDE zinclude_table_control_sub .
