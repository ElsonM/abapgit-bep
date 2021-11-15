class ZCL_AOI_DEMO3 definition
  public
  inheriting from ZCL_AOI_DEMO2
  final
  create public .

public section.

  methods SHOW_LINE .
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOI_DEMO3 IMPLEMENTATION.


  METHOD show_line.

    DATA: lv_lines TYPE sytabix.

    lv_lines = lines( mt_file ).

    MESSAGE ID 'BD'
            TYPE 'S'
            NUMBER '110'
            WITH lv_lines.

  ENDMETHOD.
ENDCLASS.
