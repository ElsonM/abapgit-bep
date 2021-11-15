*&---------------------------------------------------------------------*
*& Report Z_ABAP101_052
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_052.

DATA gv_a TYPE i VALUE 1.
DATA gv_b TYPE i VALUE 2.
DATA gv_c TYPE i VALUE 3.
DATA gv_d TYPE i VALUE 4.

*&---------------------------------------------------------------------*
*&    Form form_parameters
*&---------------------------------------------------------------------*
*     Get 4 parameters in different ways
*----------------------------------------------------------------------*
* --> US_A text
* --> (USV_B) text
* --> CH_C text
* --> (CHV_D) text
*----------------------------------------------------------------------*

FORM form_parameters
    USING    us_a         TYPE i
             VALUE(usv_b) TYPE i
    CHANGING ch_c         TYPE i
             VALUE(chv_d) TYPE i.

  WRITE: 'Inside FORM, before update'. NEW-LINE.
  WRITE: 'us_a: ', us_a.  NEW-LINE.
  WRITE: 'usv_b:', usv_b. NEW-LINE.
  WRITE: 'ch_c: ', ch_c.  NEW-LINE.
  WRITE: 'chv_d:', chv_d. NEW-LINE.

  us_a  = us_a  + 10.
  usv_b = usv_b + 10.
  ch_c  = ch_c  + 10.
  chv_d = chv_d + 10.

  WRITE: 'Inside FORM, after update - Local variables'. NEW-LINE.
  WRITE: 'us_a: ', us_a.  NEW-LINE.
  WRITE: 'usv_b:', usv_b. NEW-LINE.
  WRITE: 'ch_c: ', ch_c.  NEW-LINE.
  WRITE: 'chv_d:', chv_d. NEW-LINE.

  WRITE: 'Inside FORM, after update - Global variables'. NEW-LINE.
  WRITE: 'gv_a: ', gv_a. NEW-LINE.
  WRITE: 'gv_b: ', gv_b. NEW-LINE.
  WRITE: 'gv_c: ', gv_c. NEW-LINE.
  WRITE: 'gv_d: ', gv_d. NEW-LINE.

ENDFORM. " form_parameters

START-OF-SELECTION.
  WRITE: 'Before FORM'.  NEW-LINE.
  WRITE: 'gv_a: ', gv_a. NEW-LINE.
  WRITE: 'gv_b: ', gv_b. NEW-LINE.
  WRITE: 'gv_c: ', gv_c. NEW-LINE.
  WRITE: 'gv_d: ', gv_d. NEW-LINE.

  PERFORM form_parameters
    USING
      gv_a
      gv_b
    CHANGING
      gv_c
      gv_d.

  WRITE: 'After FORM'.   NEW-LINE.
  WRITE: 'gv_a: ', gv_a. NEW-LINE.
  WRITE: 'gv_b: ', gv_b. NEW-LINE.
  WRITE: 'gv_c: ', gv_c. NEW-LINE.
  WRITE: 'gv_d: ', gv_d. NEW-LINE.
