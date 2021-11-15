*&---------------------------------------------------------------------*
*& Report Z_LDB_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z03_ldb_03.

NODES: spfli, sflight, sbook.

DATA: gr_table TYPE REF TO cl_salv_hierseq_table.

DATA: it_spfli   TYPE TABLE OF spfli,
      it_sflight TYPE TABLE OF sflight.

DATA: it_binding TYPE salv_t_hierseq_binding,
      wa_binding LIKE LINE OF it_binding.

GET spfli.
  APPEND spfli TO it_spfli.

GET sflight.
  APPEND sflight TO it_sflight.

END-OF-SELECTION.
  wa_binding-master = 'CARRID'.
  wa_binding-slave  = 'CARRID'.
  APPEND wa_binding TO it_binding.

  wa_binding-master = 'CONNID'.
  wa_binding-slave  = 'CONNID'.
  APPEND wa_binding TO it_binding.

  cl_salv_hierseq_table=>factory(
    EXPORTING
      t_binding_level1_level2 = it_binding
    IMPORTING
      r_hierseq = gr_table
    CHANGING
      t_table_level1 = it_spfli
      t_table_level2 = it_sflight ).

  gr_table->display( ).
