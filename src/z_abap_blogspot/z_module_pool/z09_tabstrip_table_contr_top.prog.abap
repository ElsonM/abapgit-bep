*&---------------------------------------------------------------------*
*& Include Z09_TABSTRIP_TABLE_CONTR_TOP      Module Pool
*&                                           Z09_TABSTRIP_TABLE_CONTR
*&---------------------------------------------------------------------*
PROGRAM z09_tabstrip_table_contr.

*-------Declaring tables for screen fields-----------------------------*
TABLES: scarr, spfli, sflight.

*-------Airline internal structure-------------------------------------*
TYPES: BEGIN OF ty_scarr,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
       END OF ty_scarr.

*-------Flight schedule internal structure-----------------------------*
TYPES: BEGIN OF ty_spfli,
         carrid   TYPE spfli-carrid,
         connid   TYPE spfli-connid,
         cityfrom TYPE spfli-cityfrom,
         airpfrom TYPE spfli-airpfrom,
         cityto   TYPE spfli-cityto,
         airpto   TYPE spfli-airpto,
         deptime  TYPE spfli-deptime,
         arrtime  TYPE spfli-arrtime,
         distance TYPE spfli-distance,
       END OF ty_spfli,

*------Flight internal structure---------------------------------------*
       BEGIN OF ty_sflight,
         carrid   TYPE sflight-carrid,
         connid   TYPE sflight-connid,
         fldate   TYPE sflight-fldate,
         price    TYPE sflight-price,
         currency TYPE sflight-currency,
         seatsmax TYPE sflight-seatsmax,
         seatsocc TYPE sflight-seatsocc,
       END OF ty_sflight.

*-----Work area & internal table declaration---------------------------*
DATA: wa_scarr TYPE ty_scarr,

      wa_spfli TYPE          ty_spfli,
      it_spfli TYPE TABLE OF ty_spfli,

      wa_sflight TYPE          ty_sflight,
      it_sflight TYPE TABLE OF ty_sflight.

DATA: ok_code  TYPE sy-ucomm,     "User command capturing variable
      v_carrid TYPE scarr-carrid. "Screen field variable

*---------Declaring the tab strip--------------------------------------*
CONTROLS: ts_air TYPE TABSTRIP,

*---------Declaring the table controls---------------------------------*
          tc_spfli   TYPE TABLEVIEW USING SCREEN 9003,
          tc_sflight TYPE TABLEVIEW USING SCREEN 9004.
