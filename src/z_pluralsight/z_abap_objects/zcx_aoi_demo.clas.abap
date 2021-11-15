class ZCX_AOI_DEMO definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  constants NO_INPUT_FILE type SOTR_CONC value '0050569A50B51EE7A1A4A36A0E97C325' ##NO_TEXT.
  constants NO_OUTPUT_FILE type SOTR_CONC value '0050569A50B51EE7A1A4A5A0E0A98328' ##NO_TEXT.
  constants FILE_READ_ERROR type SOTR_CONC value '0050569A50B51EE7A1A4ACC6CD2B832D' ##NO_TEXT.
  constants FILE_WRITE_ERROR type SOTR_CONC value '0050569A50B51EE7A1A4ACC6CD2BA32D' ##NO_TEXT.
  data FILENAME type STRING read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !FILENAME type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_AOI_DEMO IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
me->FILENAME = FILENAME .
  endmethod.
ENDCLASS.
