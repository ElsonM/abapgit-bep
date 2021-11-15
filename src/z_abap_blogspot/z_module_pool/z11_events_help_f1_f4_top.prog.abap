*&---------------------------------------------------------------------*
*& Include Z11_EVENTS_HELP_F1_F4_TOP        "Module Pool
*&                                          "Z11_EVENTS_HELP_F1_F4
*&---------------------------------------------------------------------*
PROGRAM z11_events_help_f1_f4.

*------Structure for value table---------------------------------------*
TYPES: BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         name1 TYPE kna1-name1,
       END OF ty_kna1.

*-----Work area & internal table for help request----------------------*
DATA: it_kna1     TYPE TABLE OF ty_kna1,

      wa_kna1_ret TYPE          ddshretval,
      it_kna1_ret TYPE TABLE OF ddshretval.

*-----Declaring OK code to capture user command------------------------*
DATA: ok_code TYPE sy-ucomm.

*-----Declaring custom date & time field to capture from screen--------*
DATA: inp1 TYPE char35,
      inp2 TYPE sy-datum,
      inp3 TYPE sy-uzeit.
