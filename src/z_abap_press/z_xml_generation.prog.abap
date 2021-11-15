*&---------------------------------------------------------------------*
*& Report Z_XML_GENERATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_xml_generation.

*Declarations to create XML document
DATA: lr_ixml      TYPE REF TO if_ixml,          "Reference for iXML object
      lr_document  TYPE REF TO if_ixml_document, "Reference for XML document
      lr_extension TYPE REF TO if_ixml_element,  "Reference for "extension" element in document
      lr_files     TYPE REF TO if_ixml_element,  "Reference for "files" element in document
      lr_media     TYPE REF TO if_ixml_element,  "Reference for "media" element in document
      lr_encoding  TYPE REF TO if_ixml_encoding. "Reference to set encoding

*Declarations to create output stream and render the file to
*application server directory
DATA: lr_streamfactory TYPE REF TO if_ixml_stream_factory,
      lr_ostream       TYPE REF TO if_ixml_ostream,
      lr_renderer      TYPE REF TO if_ixml_renderer.

DATA file_path TYPE string VALUE 'MANIFEST.XML'.

*Create iXML object
lr_ixml = cl_ixml=>create( ).

*Create Document
lr_document = lr_ixml->create_document( ).

*Create encoding
lr_encoding = lr_ixml->create_encoding( byte_order = 0 character_set = 'UTF-8').

*Set encoding
lr_document->set_encoding( lr_encoding ).

*Create element "extension" as root

lr_extension = lr_document->create_simple_element(
  name   = 'extension'
  parent = lr_document ).

*Set attribute for the "extension" element
lr_extension->set_attribute( name  = 'Type'
                             value = 'Component').

*Create "files" element with "extension" element as parent
lr_files = lr_document->create_simple_element(
  name   = 'files'
  parent = lr_extension ).

*Set attribute for "files" element
lr_files->set_attribute( name  = 'Folder'
                         value = 'site').

*Create element content
lr_document->create_simple_element( name   = 'filename'
                                    parent = lr_files
                                    value  = 'index.html').
lr_document->create_simple_element( name   = 'filename'
                                    parent = lr_files
                                    value  = 'site.php').

*Create "media" element with "extension" element as parent
lr_media = lr_document->create_simple_element(
  name   = 'media'
  parent = lr_extension ).

*Set attribute for "media" element
lr_media->set_attribute( name  = 'Folder'
                         value = 'media').

*Create element content
lr_document->create_simple_element( name   = 'folder'
                                    parent = lr_media
                                    value  = 'css').
lr_document->create_simple_element( name   = 'folder'
                                    parent = lr_media
                                    value  = 'images').
lr_document->create_simple_element( name   = 'folder'
                                    parent = lr_media
                                    value  = 'js').

* Create stream factory
lr_streamfactory = lr_ixml->create_stream_factory( ).

* Create output stream
lr_ostream = lr_streamfactory->create_ostream_uri( system_id = file_path ).

* Create renderer
lr_renderer = lr_ixml->create_renderer( ostream  = lr_ostream
                                        document = lr_document ).
* Set pretty print
lr_ostream->set_pretty_print( abap_true ).

* Renders the attached document into output stream
lr_renderer->render( ).

IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
