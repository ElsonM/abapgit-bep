*&---------------------------------------------------------------------*
*&  Include           ZSR_TEST1_TOP
*&---------------------------------------------------------------------*

*------Declaring structure for item table------------------------------*
TYPES: BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
       END OF ty_ekpo.

*-----Declaring work area for PO header--------------------------------*
DATA: BEGIN OF wa_ekko,
        ebeln TYPE ekko-ebeln,
        bukrs TYPE ekko-bukrs,
        ernam TYPE ekko-ernam,
        lifnr TYPE ekko-lifnr,
      END OF wa_ekko.

*-----Declaring work area for Vendor Master----------------------------*
DATA: BEGIN OF wa_lfa1,
        lifnr TYPE lfa1-lifnr,
        land1 TYPE lfa1-land1,
        name1 TYPE lfa1-name1,
        ort01 TYPE lfa1-ort01,
      END OF wa_lfa1.

*-----Declaring work area for Vendor Company Master--------------------*
DATA: BEGIN OF wa_lfb1,
        lifnr TYPE lfb1-lifnr,
        bukrs TYPE lfb1-bukrs,
        erdat TYPE lfb1-erdat,
        ernam TYPE lfb1-ernam,
        akont TYPE lfb1-akont,
      END OF wa_lfb1.

*-----Declaring work area & internal table for line item---------------*
DATA: wa_ekpo TYPE          ty_ekpo,
      it_ekpo TYPE TABLE OF ty_ekpo.
