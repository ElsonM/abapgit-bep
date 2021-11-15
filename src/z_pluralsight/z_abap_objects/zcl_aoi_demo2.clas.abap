CLASS zcl_aoi_demo2 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        !iv_infile  TYPE string
        !iv_outfile TYPE string.

*   Read data from input file
    METHODS read_file
      IMPORTING
        !iv_file TYPE string
      EXPORTING
        !et_data TYPE STANDARD TABLE
      RAISING
        zcx_aoi_demo.

*   Write data to output file
    METHODS write_file
      IMPORTING
        !iv_file TYPE string
      CHANGING
        !ct_data TYPE STANDARD TABLE
      RAISING
        zcx_aoi_demo.

*   Display file data
    METHODS display_data
      IMPORTING
        !it_data TYPE STANDARD TABLE.

    METHODS xfer
      RAISING
        zcx_aoi_demo.

  PROTECTED SECTION.
*   Input file name
    DATA mv_infile TYPE string.
*   Output file
    DATA mv_outfile TYPE string.
    DATA mt_file TYPE string_t.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_AOI_DEMO2 IMPLEMENTATION.


  METHOD constructor.

* Store parameters as class attributes
    mv_infile  = iv_infile.
    mv_outfile = iv_outfile.

  ENDMETHOD.


  METHOD display_data.

    FIELD-SYMBOLS: <lv_line> TYPE any.

    LOOP AT it_data ASSIGNING <lv_line>.
      WRITE: / <lv_line>.
    ENDLOOP.

  ENDMETHOD.


  METHOD read_file.

    IF iv_file IS INITIAL.
      RAISE EXCEPTION TYPE zcx_aoi_demo
        EXPORTING
          textid = zcx_aoi_demo=>no_input_file.
    ENDIF.

    cl_gui_frontend_services=>gui_upload(
      EXPORTING
        filename = iv_file
      CHANGING
        data_tab = et_data
      EXCEPTIONS
        OTHERS = 1 ).

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_aoi_demo
        EXPORTING
          textid   = zcx_aoi_demo=>file_read_error
          filename = iv_file.
    ENDIF.

  ENDMETHOD.


  METHOD write_file.

    IF iv_file IS INITIAL.
      RAISE EXCEPTION TYPE zcx_aoi_demo
        EXPORTING
          textid = zcx_aoi_demo=>no_output_file.
    ENDIF.

    cl_gui_frontend_services=>gui_download(
      EXPORTING
        filename = iv_file
      CHANGING
        data_tab = ct_data
      EXCEPTIONS
        OTHERS = 1 ).

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_aoi_demo
        EXPORTING
          textid   = zcx_aoi_demo=>file_write_error
          filename = iv_file.
    ENDIF.

  ENDMETHOD.


  METHOD xfer.

* Read input file
    read_file(
      EXPORTING
        iv_file = mv_infile
      IMPORTING
        et_data = mt_file ).

* Write output file
    write_file(
      EXPORTING
        iv_file = mv_outfile
      CHANGING
        ct_data = mt_file ).

* Display transferred data
    display_data( mt_file ).

  ENDMETHOD.
ENDCLASS.
