class ZCL_COLLECTION definition
  public
  create public .

public section.
  type-pools ABAP .

  methods CONSTRUCTOR
    importing
      !IV_ELEMENT_TYPE type CSEQUENCE .
  methods ADD_ELEMENT
    importing
      !IO_ELEMENT type ref to OBJECT .
  methods REMOVE_ELEMENT
    importing
      !IO_ELEMENT type ref to OBJECT
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods GET_ITERATOR
    returning
      value(RO_ITERATOR) type ref to CL_SWF_UTL_ITERATOR .
  methods SORT .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_element_type TYPE string .
    DATA mt_elements TYPE STANDARD TABLE OF REF TO object.
    DATA mo_element_metadata TYPE REF TO cl_abap_objectdescr .

    METHODS check_element_type
      IMPORTING
        !io_element      TYPE REF TO object
      RETURNING
        VALUE(rv_result) TYPE abap_bool .
ENDCLASS.



CLASS ZCL_COLLECTION IMPLEMENTATION.


  METHOD add_element.
    IF check_element_type( io_element ) EQ abap_true.
      APPEND io_element TO me->mt_elements.
    ENDIF.
  ENDMETHOD.


  METHOD check_element_type.
    DATA lo_comparable TYPE REF TO zif_comparable.

    IF io_element IS NOT BOUND.
      rv_result = abap_false.
      RETURN.
    ENDIF.

    IF me->mo_element_metadata->applies_to( io_element ) EQ abap_true.
      TRY.
          lo_comparable ?= io_element.
          rv_result = abap_true.
        CATCH cx_sy_move_cast_error.
          rv_result = abap_false.
      ENDTRY.
    ELSE.
      rv_result = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD constructor.
    "Determine the fully-qualified name of the element type:
    IF cl_abap_matcher=>matches( pattern     = `^LCL_.*$`
                                 text        = iv_element_type
                                 ignore_case = abap_true ) EQ abap_true.
      me->mv_element_type = |\\PROGRAM={ sy-cprog }\\CLASS={ iv_element_type }|.
    ELSE.
      me->mv_element_type = iv_element_type.
    ENDIF.

    "Access RTTI to fetch metadata about the type:
    me->mo_element_metadata ?=
      cl_abap_typedescr=>describe_by_name( me->mv_element_type ).
  ENDMETHOD.


  METHOD get_iterator.
    CREATE OBJECT ro_iterator
      EXPORTING
        im_object_list = me->mt_elements.
  ENDMETHOD.


  METHOD remove_element.
    DATA lo_element TYPE REF TO zif_comparable.
    DATA lo_temp TYPE REF TO object.

    "Sanity check - make sure we're dealing with a valid element:
    IF check_element_type( io_element ) EQ abap_false.
      RETURN.
    ENDIF.

    "Perform a widening cast so that we can compare the element:
    lo_element ?= io_element.

    "Scan the element list to find a match:
    LOOP AT me->mt_elements INTO lo_temp.
      IF lo_element->compare_to( lo_temp ) EQ zif_comparable=>co_equal_to.
        DELETE me->mt_elements.
        rv_result = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.

    "No matches were found:
    rv_result = abap_false.
  ENDMETHOD.


  METHOD sort.
    DATA: lo_key     TYPE REF TO object,
          lo_element TYPE REF TO object,
          lo_compare TYPE REF TO zif_comparable,
          lo_temp    TYPE REF TO object,
          lv_i       TYPE i,
          lv_j       TYPE i VALUE 2,
          lv_index   TYPE i.

    "Sort the collection elements using the Insertion Sort
    "algorithm:
    LOOP AT me->mt_elements INTO lo_key FROM 2.
      lv_i = lv_j - 1.
      READ TABLE me->mt_elements INDEX lv_i INTO lo_element.
      lo_compare ?= lo_element.

      WHILE lv_i GT 0 AND
            lo_compare->compare_to( lo_key ) EQ zif_comparable=>co_greater_than.
        READ TABLE me->mt_elements INDEX lv_i INTO lo_temp.
        lv_index = lv_i + 1.
        MODIFY me->mt_elements FROM lo_temp INDEX lv_index.

        lv_i = lv_i - 1.
        READ TABLE me->mt_elements INDEX lv_i INTO lo_element.
        lo_compare ?= lo_element.
      ENDWHILE.

      lv_index = lv_i + 1.
      MODIFY me->mt_elements FROM lo_key INDEX lv_index.
      lv_j = lv_j + 1.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
