*&---------------------------------------------------------------------*
*& Include Z05_TWO_TABLE_CONTROLS_TOP    " Module Pool
*&                                         Z05_TWO_TABLE_CONTROLS
*&---------------------------------------------------------------------*
PROGRAM z05_two_table_controls.

*-------Decalring the database tables for screen fields----------------*
TABLES: scarr, spfli, sflight.

*------Airline structure-----------------------------------------------*
TYPES: BEGIN OF ty_scarr,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
       END OF ty_scarr,

*------Airline structure for screen output-----------------------------*
       BEGIN OF ty_out_scarr,
         mark     TYPE char1,             "Selection box
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
       END OF ty_out_scarr,

*------Flight schedule structure---------------------------------------*
       BEGIN OF ty_spfli,
         carrid    TYPE spfli-carrid,
         connid    TYPE spfli-connid,
         countryfr TYPE spfli-countryfr,
         cityfrom  TYPE spfli-cityfrom,
         airpfrom  TYPE spfli-airpfrom,
         cityto    TYPE spfli-cityto,
         airpto    TYPE spfli-airpto,
       END OF ty_spfli,

*------Flight schedule structure for screen output---------------------*
       BEGIN OF ty_out_spfli,
         mark      TYPE char1,
         carrid    TYPE spfli-carrid,
         connid    TYPE spfli-connid,
         countryfr TYPE spfli-countryfr,
         cityfrom  TYPE spfli-cityfrom,
         airpfrom  TYPE spfli-airpfrom,
         cityto    TYPE spfli-cityto,
         airpto    TYPE spfli-airpto,
       END OF ty_out_spfli.

*-----Airline work areas & internal tables-----------------------------*
DATA: lw_scarr TYPE          ty_scarr,
      wa_scarr TYPE          ty_out_scarr,
      lt_scarr TYPE TABLE OF ty_scarr,
      it_scarr TYPE TABLE OF ty_out_scarr,

*-----Temporary internal table to store data for reusing---------------*
      it_temp_scarr TYPE TABLE OF ty_out_scarr,

*-----To capture the Airline code for different use--------------------*
      v_carrid TYPE scarr-carrid,

*-----Flight schedule work areas & internal tables---------------------*
      lw_spfli      TYPE          ty_spfli,
      wa_spfli      TYPE          ty_out_spfli,
      lt_spfli      TYPE TABLE OF ty_spfli,
      it_spfli      TYPE TABLE OF ty_out_spfli.

DATA: ok_code1 TYPE sy-ucomm, "User command for screen 9001
      ok_code2 TYPE sy-ucomm, "User command for screen 9002
      ok_code3 TYPE sy-ucomm. "User command for screen 9003

*---------Declaring the selection screen as a subscreen of 100---------*
SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.
  SELECT-OPTIONS: s_carrid FOR scarr-carrid.         "Select option
SELECTION-SCREEN END OF SCREEN 100.

*---------Declaring the table controls for different screen------------*
CONTROLS: tab_ctrl_scarr TYPE TABLEVIEW USING SCREEN 9002,
          tab_ctrl_spfli TYPE TABLEVIEW USING SCREEN 9003.
