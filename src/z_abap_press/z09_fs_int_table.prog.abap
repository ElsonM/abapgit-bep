*&---------------------------------------------------------------------*
*& Report Z09_FS_INT_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z09_fs_int_table.

*TYPES: BEGIN OF ty_mara,
*         matnr TYPE matnr,
*         ersda TYPE ersda,
*         mtart TYPE mtart,
*       END OF ty_mara.
*
*DATA: it_mara TYPE TABLE OF ty_mara.
*FIELD-SYMBOLS: <fs_mara> LIKE LINE OF it_mara.
*PARAMETERS p_matnr TYPE matnr.
*SELECT matnr ersda mtart FROM mara
*  INTO TABLE it_mara
*    WHERE matnr EQ p_matnr.
*
*READ TABLE it_mara ASSIGNING <fs_mara> INDEX 1.
*
*IF <fs_mara> IS ASSIGNED.
*  <fs_mara>-mtart = 'BOH'.
*ENDIF.

*DATA text(8) TYPE c VALUE '20111201'.
*FIELD-SYMBOLS <fs> TYPE sy-datum.
*ASSIGN text TO <fs> CASTING.
*WRITE <fs>.

*DATA v_matnr TYPE matnr VALUE '100'.
*
*DATA dref  TYPE REF TO matnr.
*DATA dref1 TYPE REF TO matnr.
*
*FIELD-SYMBOLS <fs> TYPE matnr.
*
*ASSIGN v_matnr TO <fs>.
*
**Getting reference from data object
*GET REFERENCE OF v_matnr INTO dref.
*
**Getting reference from dereferenced reference variable
*GET REFERENCE OF dref->* INTO dref1.
*
**Getting reference from field symbol
*GET REFERENCE OF <fs> INTO dref1.
*
*WRITE dref->*.

*DATA format_date TYPE c LENGTH 8 VALUE 'SY-DATUM'.
*
*DATA date1 TYPE c LENGTH 10.
*DATA date2 TYPE c LENGTH 10.
*
*date1 = sy-datum.
*date2 = sy-datum.
*
*WRITE (format_date) TO date1.
*WRITE sy-datum      TO date2.
*
*BREAK-POINT.
