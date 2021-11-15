*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCUSTOMER_XML...................................*
DATA:  BEGIN OF STATUS_ZCUSTOMER_XML                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCUSTOMER_XML                 .
CONTROLS: TCTRL_ZCUSTOMER_XML
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCUSTOMER_XML                 .
TABLES: ZCUSTOMER_XML                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
