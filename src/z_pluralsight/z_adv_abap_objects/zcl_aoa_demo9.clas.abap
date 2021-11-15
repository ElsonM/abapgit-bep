CLASS zcl_aoa_demo9 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_table       TYPE tabname
        !iv_description TYPE as4flag
        !iv_contents    TYPE as4flag
      RAISING
        zcx_aoa.

  PROTECTED SECTION.

private section.

  types COMP_TYPE type CHAR10 .
  types:
    BEGIN OF metadata_rec,
        component_name TYPE fieldname,   "Field name
        component_type TYPE comp_type,   "Component type - FIELD or STRUCTURE
        type_name      TYPE rollname,    "Data type name
        type_kind      TYPE char01,      "Component data type - C, N, P, etc
        output_len     TYPE i,           "Output length
      END OF metadata_rec .
  types:
    metadata_tab
        TYPE STANDARD TABLE OF metadata_rec
        WITH DEFAULT KEY
        INITIAL SIZE 0 .

  constants MC_COMP_TYPE_FIELD type COMP_TYPE value 'FIELD' ##NO_TEXT.
  constants MC_COMP_TYPE_STRUCT type COMP_TYPE value 'STRUCTURE' ##NO_TEXT.

  methods BUILD_OUTPUT_TABLE_META
    importing
      !IT_COMPONENTS type ABAP_COMPONENT_TAB
    returning
      value(RO_META) type ref to CL_ABAP_TABLEDESCR
    raising
      ZCX_AOA .
  methods DISPLAY_OUTPUT
    changing
      !CT_DATA type STANDARD TABLE
    raising
      ZCX_AOA .
  methods GET_COLUMNS
    importing
      !IT_COMPONENTS type ABAP_COMPONENT_TAB
    returning
      value(RV_COLUMNS) type STRING .
  methods GET_COMPONENT_DETAILS
    importing
      !IT_COMPONENTS type ABAP_COMPONENT_TAB
    returning
      value(RT_DETAILS) type METADATA_TAB .
  methods GET_METADATA_OBJECT
    importing
      !IV_TABLE type TABNAME
    returning
      value(RO_META) type ref to CL_ABAP_STRUCTDESCR
    raising
      ZCX_AOA .
  methods SHOW_METADATA
    importing
      !IV_TABLE type TABNAME
    raising
      ZCX_AOA .
  methods SHOW_DATA
    importing
      !IV_TABLE type TABNAME
    raising
      ZCX_AOA .
ENDCLASS.



CLASS ZCL_AOA_DEMO9 IMPLEMENTATION.


  METHOD build_output_table_meta.
*
*    DATA: lo_output_struct TYPE REF TO cl_abap_structdescr, "RTTS metadata object for output display structure (first 10 columns)
*          lo_error         TYPE REF TO cx_root,             "Generic error objects
*          lv_error         TYPE string.

    DATA lt_components TYPE abap_component_tab. "Output table structure component list

*   Build ouput table component list from first 10 lines of input list
    APPEND LINES OF it_components
      FROM 1 TO 10
      TO lt_components.

    TRY.
*       Generate the output structure metadata object
        DATA(lo_output_struct) =
          cl_abap_structdescr=>create( lt_components ).

*       Generate and return the output table metadata object
        ro_meta =
          cl_abap_tabledescr=>create( lo_output_struct ).
      CATCH cx_sy_struct_creation
            cx_sy_table_creation INTO DATA(lo_error).
        DATA(lv_error) = lo_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid    = zcx_aoa=>dynamic_error
            long_text = lv_error.
    ENDTRY.

  ENDMETHOD.


  METHOD constructor.

    CASE abap_true.

*     Show table metadata
      WHEN iv_description.
        show_metadata( iv_table ).

*     Show table contents
      WHEN iv_contents.
        show_data( iv_table ).

    ENDCASE.

  ENDMETHOD.


  METHOD display_output.

*    DATA: lo_alv   TYPE REF TO cl_salv_table,
*          lo_error TYPE REF TO cx_salv_msg,
*          lv_error TYPE string.

    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = DATA(lo_alv)
          CHANGING
            t_table = ct_data ).
      CATCH cx_salv_msg INTO DATA(lo_error).
        DATA(lv_error) = lo_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid    = zcx_aoa=>dynamic_error
            long_text = lv_error.
    ENDTRY.

    lo_alv->display( ).

  ENDMETHOD.


  METHOD get_columns.

    DATA:
      lv_columns TYPE string.

*    FIELD-SYMBOLS:
*      <lwa_component> TYPE abap_componentdescr.

*   Read no more than first 10 entries
    LOOP AT it_components ASSIGNING FIELD-SYMBOL(<lwa_component>)
      FROM 1 TO 10.
      IF lv_columns IS INITIAL.
        lv_columns = <lwa_component>-name.
      ELSE.
        lv_columns = lv_columns && | | && <lwa_component>-name.
      ENDIF.
    ENDLOOP.

    rv_columns = lv_columns.

  ENDMETHOD.


  METHOD get_component_details.

*    DATA: lt_components TYPE abap_component_tab,         "Nested structure component list
*          lt_details    TYPE metadata_tab,               "Nested structure metadata table
*          lo_structure  TYPE REF TO cl_abap_structdescr, "Structure description object
*          lo_element    TYPE REF TO cl_abap_elemdescr.   "Element description object
*
*    FIELD-SYMBOLS: <lwa_component> TYPE abap_componentdescr.

    DATA lwa_details TYPE metadata_rec. "Output metadata work area

*   Process the input component data
    LOOP AT it_components ASSIGNING FIELD-SYMBOL(<lwa_component>).

*     Transfer the component name / field name
      lwa_details-component_name = <lwa_component>-name.

*     Set component type based on input KIND value
      CASE <lwa_component>-type->kind.
        WHEN cl_abap_typedescr=>kind_elem.
*         Map ELEMENT --> FIELD
          lwa_details-component_type = mc_comp_type_field.
        WHEN cl_abap_typedescr=>kind_struct.
*         Map STRUCTURE --> STRUCTURE
          lwa_details-component_type = mc_comp_type_struct.
        WHEN OTHERS.
*         Shouldn't be anything else!
          CLEAR lwa_details-component_type.
      ENDCASE.

*     Data type name input is prefixed with "\TYPE="
      lwa_details-type_name =
        <lwa_component>-type->absolute_name+6(30).

*     Set the component data type kind
      lwa_details-type_kind = <lwa_component>-type->type_kind.

*     Set the component output length - zero for included structure
      IF <lwa_component>-type->kind = cl_abap_typedescr=>kind_elem.
*       Cast the component TYPE object to ELEMENT object
        DATA(lo_element) = CAST cl_abap_elemdescr( <lwa_component>-type ).
*       Then transfer output length attribute
        lwa_details-output_len =
          lo_element->output_length.
      ELSE.
        CLEAR lwa_details-output_len.
      ENDIF.

*     Write the output row to returned data.
      APPEND lwa_details TO rt_details.

*     Check if current component is a structure
      IF <lwa_component>-type->kind = cl_abap_typedescr=>kind_struct.

*       Cast component TYPE object to STRUCTURE object
        DATA(lo_structure) = CAST cl_abap_structdescr( <lwa_component>-type ).

*       Get structure components into local list table
        DATA(lt_components) = lo_structure->get_components( ).

*       Make a recursive call to this method to get component details
        DATA(lt_details) = get_component_details( lt_components ).

*       And add the returned details to returned data
        APPEND LINES OF lt_details TO rt_details.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_metadata_object.

*    DATA: lo_meta TYPE REF TO cl_abap_typedescr.

*   Get RTTS object for table / structure name
    cl_abap_structdescr=>describe_by_name(
      EXPORTING
        p_name         = iv_table
      RECEIVING
        p_descr_ref    = DATA(lo_meta)
      EXCEPTIONS
        type_not_found = 1 ).

*   Raise exception if dictionary object not found
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid     = zcx_aoa=>dynamic_error
          short_text = TEXT-e01 && | | && iv_table.
*                      --> Dictionary object not found:
    ENDIF.

*   Cast the TYPE object to STRUCTURE object and return
    ro_meta ?= lo_meta.

  ENDMETHOD.


  METHOD show_data.

*    DATA: lo_input      TYPE REF TO cl_abap_structdescr, "RTTS metadata object for complete database table structure
*          lt_components TYPE        abap_component_tab,  "Structure component list
*          lo_output     TYPE REF TO cl_abap_tabledescr,  "RTTS metadata object for output display table
*          lv_columns    TYPE        string,              "Column selection list for dynamic SELECT statement
*          lo_error      TYPE REF TO cx_root,             "Generic error objects
*          lv_error      TYPE        string.

    DATA lt_output  TYPE REF TO data. "Generic output data table object

    FIELD-SYMBOLS: <lt_output> TYPE STANDARD TABLE. "Output data table field symbol

*   Get the input table metadata object
    DATA(lo_input) = get_metadata_object( iv_table ).

*   Get the structure component list
    DATA(lt_components) = lo_input->get_components( ).

*   Build the output table metadata object from component list.
    DATA(lo_output) = build_output_table_meta( lt_components ).

*   Create the output table data object from metadata
    TRY.
        CREATE DATA lt_output
          TYPE HANDLE lo_output.
      CATCH cx_sy_create_data_error INTO DATA(lo_error).
        DATA(lv_error) = lo_error->get_text( ).
        RAISE EXCEPTION TYPE zcx_aoa
          EXPORTING
            textid    = zcx_aoa=>dynamic_error
            long_text = lv_error.
    ENDTRY.

*   Assign the output object to field symbol for accessing
    ASSIGN lt_output->* TO <lt_output>.

*   Build dynamic column list for SELECT statement
    DATA(lv_columns) = get_columns( lt_components ).

*   Read first 10 rows of data from specified table into
*   dynamic data table object
    SELECT (lv_columns)
      UP TO 10 ROWS
      FROM (iv_table)
      INTO TABLE <lt_output>.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_aoa
        EXPORTING
          textid     = zcx_aoa=>dynamic_error
          short_text = TEXT-e02 && | | && iv_table.
*                      --> No data found in table
    ENDIF.

*   Display output data in ALV
    display_output(
      CHANGING
        ct_data = <lt_output> ).

  ENDMETHOD.


  METHOD show_metadata.

*    DATA: lo_table TYPE REF TO cl_abap_structdescr, "RTTS metadata object for database table structure
*          lt_components TYPE abap_component_tab,    "Structure component list
*          lt_output TYPE metadata_tab.              "Output metadata table

*   Get the table metadata object
    DATA(lo_table) = get_metadata_object( iv_table ).

*   Get the structure component list
    DATA(lt_components) = lo_table->get_components( ).

*   Build output description from component list
    DATA(lt_output) = get_component_details( lt_components ).

*   Then display result in ALV table
    display_output(
      CHANGING
        ct_data = lt_output ).

  ENDMETHOD.
ENDCLASS.
