*&---------------------------------------------------------------------*
*& Report Z_ANONYMOUS_DATA_OBJECTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_anonymous_data_objects.

*First possibility (Anonymous object of type "i" is created)

FIELD-SYMBOLS <fs1> TYPE data.
DATA dref1 TYPE REF TO data.
CREATE DATA dref1 TYPE i.
ASSIGN dref1->* TO <fs1>.
<fs1> = 5.

*Second possibility

FIELD-SYMBOLS <fs2> TYPE data.
DATA dref2 TYPE REF TO data.
dref2 = NEW i( 5 ).
ASSIGN dref2->* TO <fs2>.

* Accessing Components of Anonymous Data Objects

TYPES: BEGIN OF ty_mara,
         matnr TYPE matnr,
         mtart TYPE mtart,
       END OF ty_mara.

DATA dref3 TYPE REF TO ty_mara.
CREATE DATA dref3.
dref3->matnr = '100'.

WRITE:  'First Data Object: ', <fs1>,
      / 'Second Data Object:', <fs2>,
      / 'Third Data Object:',
      / 'MATNR:', dref3->matnr,
        'MTART:', dref3->mtart.

*TYPES: ty_type TYPE p DECIMALS 2.
*DATA: v_data      TYPE ty_type,
*      r_typedescr TYPE REF TO cl_abap_typedescr.
*
*START-OF-SELECTION.
*  r_typedescr = cl_abap_typedescr=>describe_by_data( v_data ).
*  WRITE: / 'Kind:', r_typedescr->type_kind.
*  WRITE: / 'Length:', r_typedescr->length.
*  WRITE: / 'Decimals:', r_typedescr->decimals.
