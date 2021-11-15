*&---------------------------------------------------------------------*
*& Report Z11_HASHED_TABLES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z11_hashed_tables.

TABLES : pernr.
SELECT-OPTIONS : s_pernr FOR pernr-pernr.

TYPES: BEGIN OF ty_address,
         pernr TYPE pa0006-pernr,
         stras TYPE pa0006-stras,
       END   OF ty_address.

DATA: wa_address TYPE ty_address,
      it_address TYPE STANDARD TABLE OF ty_address.


TYPES: BEGIN OF ty_payroll,
         pernr TYPE pa0003-pernr,
         abrdt TYPE pa0003-abrdt,
       END   OF ty_payroll.

DATA: wa_payroll TYPE ty_payroll,
      it_payroll TYPE  HASHED TABLE OF ty_payroll
         WITH UNIQUE KEY pernr.


START-OF-SELECTION.
  SELECT pernr abrdt FROM pa0003
    INTO TABLE it_payroll WHERE pernr IN s_pernr.

  SELECT pernr stras INTO TABLE it_address FROM pa0006
         WHERE pernr IN s_pernr
         AND subty EQ '1'
         AND begda LE sy-datum
         AND endda GE sy-datum.

  LOOP AT it_address INTO wa_address.
    READ TABLE it_payroll WITH TABLE KEY pernr  =  wa_address-pernr
         INTO wa_payroll-pernr.
    WRITE:/ wa_payroll-pernr, wa_payroll-abrdt, wa_address-stras.
  ENDLOOP.
  WRITE :/ sy-dbcnt.
