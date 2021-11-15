class ZCX_AOA definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of DYNAMIC_ERROR,
      msgid type symsgid value 'ZAOA',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'LONG_TEXT',
      attr2 type scx_attrname value 'SHORT_TEXT',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DYNAMIC_ERROR .
  constants:
    begin of ORDER_LOCKED,
      msgid type symsgid value 'ZAOA',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'SALES_ORDER',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ORDER_LOCKED .
  constants:
    begin of LOCK_SYSTEM_FAILURE,
      msgid type symsgid value 'ZAOA',
      msgno type symsgno value '002',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of LOCK_SYSTEM_FAILURE .
  constants:
    begin of ORDER_NOT_FOUND,
      msgid type symsgid value 'ZAOA',
      msgno type symsgno value '003',
      attr1 type scx_attrname value 'SALES_ORDER',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ORDER_NOT_FOUND .
  constants:
    begin of EMPLOYEE_NOT_FOUND,
      msgid type symsgid value 'ZAOA',
      msgno type symsgno value '004',
      attr1 type scx_attrname value 'EMPLOYEE_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of EMPLOYEE_NOT_FOUND .
  constants:
    begin of EMPLOYEE_ALREADY_EXISTS,
      msgid type symsgid value 'ZAOA',
      msgno type symsgno value '005',
      attr1 type scx_attrname value 'EMPLOYEE_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of EMPLOYEE_ALREADY_EXISTS .
  constants:
    begin of NO_DATA,
      msgid type symsgid value 'ZAOA',
      msgno type symsgno value '007',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_DATA .
  constants:
    begin of NO_ADDRESS,
      msgid type symsgid value 'ZAOA',
      msgno type symsgno value '008',
      attr1 type scx_attrname value 'ADDRESS_ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NO_ADDRESS .
  data SHORT_TEXT type TEXT132 read-only .
  data LONG_TEXT type STRING read-only .
  data SALES_ORDER type VBELN_VA read-only .
  data EMPLOYEE_ID type ZIF_AOA_EMPLOYEE=>EMPLOYEE_ID read-only .
  data ADDRESS_ID type ADRNR .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !SHORT_TEXT type TEXT132 optional
      !LONG_TEXT type STRING optional
      !SALES_ORDER type VBELN_VA optional
      !EMPLOYEE_ID type ZIF_AOA_EMPLOYEE=>EMPLOYEE_ID optional
      !ADDRESS_ID type ADRNR optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_AOA IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->SHORT_TEXT = SHORT_TEXT .
me->LONG_TEXT = LONG_TEXT .
me->SALES_ORDER = SALES_ORDER .
me->EMPLOYEE_ID = EMPLOYEE_ID .
me->ADDRESS_ID = ADDRESS_ID .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
