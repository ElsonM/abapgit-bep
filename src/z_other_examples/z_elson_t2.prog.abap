*&---------------------------------------------------------------------*
*& Report Z_ELSON_T2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t2.

*Simple report to create graph in ABAP
*using GRAPH_MATRIX_3D function module
*The graph shows the performance of 3 companies for the four
*quarters of a single year
*AUTHOR: Swarna. S.

*Structure declaration for performance measurement
TYPES: BEGIN OF ty_performance,
         company(15) TYPE c,
         q1          TYPE i,
         q2          TYPE i,
         q3          TYPE i,
         q4          TYPE i,
       END OF ty_performance.

*Structure declaration for options table
TYPES : BEGIN OF ty_opttable,
          options(30) TYPE c,
        END OF ty_opttable.

*Internal table and work area declarations
DATA: it_performance TYPE STANDARD TABLE OF ty_performance,
      wa_performance TYPE                   ty_performance.

DATA: it_opttable TYPE STANDARD TABLE OF ty_opttable,
      wa_opttable TYPE                   ty_opttable.


*Start of selection event
START-OF-SELECTION.

* Appending values into the performance internal table
  wa_performance-company = 'Company ELSON'.
  wa_performance-q1      = 78.
  wa_performance-q2      = 68.
  wa_performance-q3      = 79.
  wa_performance-q4      = 80.
  APPEND wa_performance TO it_performance.

  wa_performance-company = 'Company JETON'.
  wa_performance-q1      = 48.
  wa_performance-q2      = 68.
  wa_performance-q3      = 69.
  wa_performance-q4      = 70.
  APPEND wa_performance TO it_performance.

  wa_performance-company = 'Company ARNOLD'.
  wa_performance-q1      = 78.
  wa_performance-q2      = 48.
  wa_performance-q3      = 79.
  wa_performance-q4      = 85.
  APPEND wa_performance TO it_performance.

* Appending values into the options internal table
  wa_opttable-options = 'P3TYPE = TO'.
  APPEND wa_opttable TO it_opttable.

  wa_opttable-options = 'P2TYPE = VB'.
  APPEND wa_opttable TO it_opttable.

  wa_opttable-options = 'TISIZE = 1'.
  APPEND wa_opttable TO it_opttable.

* Calling the graph function module
  CALL FUNCTION 'GRAPH_MATRIX_3D'
    EXPORTING
      col1      = 'Quarter 1'
      col2      = 'Quarter 2'
      col3      = 'Quarter 3'
      col4      = 'Quarter 4'
      dim1      = 'In Percentage %'
      set_focus = 'X'
      titl      = 'Company Performances'
    TABLES
      data      = it_performance
      opts      = it_opttable
    EXCEPTIONS
      OTHERS    = 1.
