*&---------------------------------------------------------------------*
*& Report Z_ELSON_T1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t1 LINE-SIZE 130. "NO STANDARD PAGE HEADING

*//////////////////////////////////////////////////////////////////////*
MOVE 'Creation of an internal table with ''APPEND itab''' TO sy-title.

*//////////////////////////////////////////////////////////////////////*
************************************************************************
***************         Interne Tabellen          **********************
*
DATA: BEGIN OF t1 OCCURS 30,
        artikelnr(6)  TYPE n,                    "Artikelnummer
        art_bez(16)   TYPE c,                    "Artikelbezeichnung
        art_gruppe(4) TYPE c,                    "Artikelgruppe
        lagernr(2)    TYPE p,                    "Lagernummer
        art_menge     TYPE i,                    "Artikelmenge
      END OF t1.
*

************************************************************************
*--------------------------  Main Section  ----------------------------*
************************************************************************
PERFORM tabellenaufbau-1.
PERFORM display-t1.

************************************************************************
*-------------------------    Subroutines   ---------------------------*
************************************************************************

************************************************************************
*           Here the table T1 is filled with 10 elements               *
************************************************************************
FORM tabellenaufbau-1.

  DATA z_feld1(3) TYPE n. "Zwischenfeld1

  SKIP.
  WRITE: /5 'Step 1: Create the internal table T1          ' COLOR 5.
  ULINE.
  SKIP.
*.......................................................................
  DO 10 TIMES.
    ADD 5 TO t1-artikelnr.
    MOVE 'Schuhgroesse ' TO t1-art_bez.
    ADD 3 TO z_feld1.
    MOVE z_feld1 TO t1-art_bez+13(3).
    ADD 2 TO t1-art_gruppe.
    ADD 8 TO t1-lagernr.
    ADD 33 TO t1-art_menge.
*#######################################################################
    APPEND t1.
*#######################################################################
  ENDDO.

ENDFORM.

************************************************************************
*           The content of the table t1 will be displayed              *
************************************************************************
FORM display-t1.

  WRITE: /5 'Step 2: The content of T1 will be displayed : ' COLOR 5.
  ULINE.
  SKIP.
*.......................................................................
* ................... Head line (only a test) ..........................
  WRITE: /3 'Warennummer' COLOR 1,
         15 'Bezeichnung     ' COLOR 1,
         32 'ArtGrp'      COLOR 1,
         39 'LOrt'        COLOR 1,
         44 'Warenmenge'  COLOR 1.
  ULINE.
*
* ...................... Display of table T1 ...........................
  LOOP AT t1.
    WRITE: /8 t1-artikelnr,
           15 t1-art_bez,
           34 t1-art_gruppe RIGHT-JUSTIFIED,
           40 t1-lagernr    RIGHT-JUSTIFIED,
           44 t1-art_menge  RIGHT-JUSTIFIED.
  ENDLOOP.
*
ENDFORM.

************************************************************************
********************* END OF PROGRAM ***********************************
************************************************************************
