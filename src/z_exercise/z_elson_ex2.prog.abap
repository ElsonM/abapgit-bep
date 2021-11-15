*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_ex2.

*Input Parameters
PARAMETERS p_blart TYPE bkpf-blart.

*Local Variables
DATA: lt_bkpf TYPE TABLE OF bkpf,
      lt_bseg TYPE TABLE OF bseg,
      ls_bkpf TYPE bkpf,
      ls_bseg TYPE bseg.

DATA nrrows TYPE i.

START-OF-SELECTION.

  SELECT * FROM bkpf INTO TABLE lt_bkpf WHERE blart = p_blart.

  IF sy-subrc = 0.

    SELECT * FROM bseg INTO TABLE lt_bseg FOR ALL ENTRIES IN lt_bkpf
      WHERE belnr = lt_bkpf-belnr.

    LOOP AT lt_bseg INTO ls_bseg.

      AT FIRST.
        WRITE: /     'Company Code' COLOR 5, 14 'Accounting Document Number' COLOR 5, 41 'Fiscal Year'          COLOR 5,
                  53 'Posting Key'  COLOR 5, 65 'Account type'               COLOR 5, 78 'Document Header Text' COLOR 5,
                  99 'Object key'   COLOR 5.
        ULINE.
      ENDAT.
      READ TABLE lt_bkpf WITH KEY belnr = ls_bseg-belnr INTO ls_bkpf.
      WRITE: /    ls_bseg-bukrs, 14 ls_bseg-belnr, 41 ls_bseg-gjahr,
               53 ls_bseg-bschl, 65 ls_bseg-koart, 78 ls_bkpf-bktxt, 99 ls_bkpf-awkey.
*     nrRows = nrRows + 1.
    ENDLOOP.

* WRITE: / 'Nr of rows is: ', nrRows.

  ELSE.

    MESSAGE TEXT-e01 TYPE 'E'.

  ENDIF.

* ABAP 7.4 Syntax (Without prior declaration of the data objects)

*  SELECT * FROM bkpf "belnr, bktxt, awkey
*    INTO TABLE @DATA(lt_bkpf)
*    WHERE blart = @p_blart.
*
*  IF sy-subrc = 0.
*
*    SELECT * FROM bseg "bukrs, belnr, gjahr, bschl, koart
*      INTO TABLE @DATA(lt_bseg) FOR ALL ENTRIES IN @lt_bkpf
*      WHERE belnr = @lt_bkpf-belnr.
*
*    LOOP AT lt_bseg INTO DATA(ls_bseg).
*
*      AT FIRST.
*        WRITE: /     'Company Code' COLOR 5, 14 'Accounting Document Number' COLOR 5, 41 'Fiscal Year'          COLOR 5,
*                  53 'Posting Key'  COLOR 5, 65 'Account type'               COLOR 5, 78 'Document Header Text' COLOR 5,
*                  99 'Object key'   COLOR 5.
*        ULINE.
*      ENDAT.
*      READ TABLE lt_bkpf WITH KEY belnr = ls_bseg-belnr INTO DATA(ls_bkpf).
*      WRITE: /    ls_bseg-bukrs, 14 ls_bseg-belnr, 41 ls_bseg-gjahr,
*               53 ls_bseg-bschl, 65 ls_bseg-koart, 78 ls_bkpf-bktxt, 99 ls_bkpf-awkey.
**     nrRows = nrRows + 1.
*    ENDLOOP.
*
** WRITE: / 'Nr of rows is: ', nrRows.
*
*  ELSE.
*    MESSAGE TEXT-e01 TYPE 'E'.
*
*  ENDIF.

* ABAP 7.4 Syntax (Use of CASE) ---

*CONSTANTS: lc_gender1(15) TYPE c VALUE 'Female',
*           lc_gender2(15) TYPE c VALUE 'Male',
*           lc_gender3(15) TYPE c VALUE 'Other'.
*
*SELECT surname, forename,
*      CASE WHEN title = 'MRS' THEN @lc_gender1
*           WHEN title = 'MR'  THEN @lc_gender2
*           ELSE @lc_gender3
*      END AS gender
*  FROM zemployees
*  ORDER BY gender
*  INTO TABLE @DATA(it_zemployees).
*
*LOOP AT it_zemployees INTO DATA(wa_employees).
*  WRITE:/ wa_employees-surname, wa_employees-forename, wa_employees-gender.
*ENDLOOP.
