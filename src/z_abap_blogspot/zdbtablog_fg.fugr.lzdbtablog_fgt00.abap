*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDBTABLOG.......................................*
DATA:  BEGIN OF STATUS_ZDBTABLOG                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDBTABLOG                     .
CONTROLS: TCTRL_ZDBTABLOG
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDBTABLOG                     .
TABLES: ZDBTABLOG                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
