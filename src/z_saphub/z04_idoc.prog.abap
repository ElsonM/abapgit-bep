*&---------------------------------------------------------------------*
*& Report Z04_IDOC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_idoc.

PARAMETERS: p_idoc TYPE edidd-docnum.

DATA: o_idoc_xml TYPE REF TO cl_idoc_xml1.
DATA: gv_string  TYPE string.
DATA: gt_string  TYPE TABLE OF string.

* Create IDoc object
CREATE OBJECT o_idoc_xml
  EXPORTING
    docnum = p_idoc
  EXCEPTIONS
    OTHERS = 1.

IF sy-subrc NE 0.
  WRITE: /'Error creating idoc object'.
  EXIT.
ENDIF.

* Get IDoc data as string
CALL METHOD o_idoc_xml->get_xmldata_as_string
  IMPORTING
    data_string = gv_string.

APPEND gv_string TO gt_string.

IF sy-subrc NE 0 OR o_idoc_xml IS INITIAL.
  WRITE: /'Error getting xml data as string'.
  EXIT.
ENDIF.

* Download IDoc data as XML file
CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    filename = 'C:\TEMP\idoc.xml'
  TABLES
    data_tab = gt_string.
