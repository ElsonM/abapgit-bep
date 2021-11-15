*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_ex3.

*Global Variables
DATA: it_ekpo TYPE TABLE OF ekpo,
      it_ekko TYPE TABLE OF ekko,
*     ls_ekpo TYPE ekpo,
      wa_ekko TYPE ekko.

*Input Parameters
PARAMETERS p_werks TYPE ekpo-werks.

START-OF-SELECTION.

  SELECT * FROM ekpo INTO TABLE it_ekpo WHERE werks = p_werks.

  IF sy-subrc = 0.

    SELECT * FROM ekko INTO TABLE it_ekko FOR ALL ENTRIES IN it_ekpo
      WHERE ebeln = it_ekpo-ebeln.
    LOOP AT it_ekko INTO wa_ekko.
      AT FIRST.
        WRITE: /     'Purchasing Document Number'       COLOR 4, 28 'Company Code' COLOR 4, 41 'Purchasing Document Type' COLOR 4,
                  66 'Number of the document condition' COLOR 4.
        ULINE.
      ENDAT.
      WRITE: / wa_ekko-ebeln, 28 wa_ekko-bukrs, 41 wa_ekko-bsart, 66 wa_ekko-knumv.
    ENDLOOP.

  ELSE.

    MESSAGE TEXT-e01 TYPE 'E'.

  ENDIF.
