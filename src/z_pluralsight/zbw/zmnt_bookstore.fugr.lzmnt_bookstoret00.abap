*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADDRESS........................................*
DATA:  BEGIN OF STATUS_ZADDRESS                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZADDRESS                      .
CONTROLS: TCTRL_ZADDRESS
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZAUTHOR.........................................*
DATA:  BEGIN OF STATUS_ZAUTHOR                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAUTHOR                       .
CONTROLS: TCTRL_ZAUTHOR
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZBOOK...........................................*
DATA:  BEGIN OF STATUS_ZBOOK                         .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBOOK                         .
CONTROLS: TCTRL_ZBOOK
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZCITY...........................................*
DATA:  BEGIN OF STATUS_ZCITY                         .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCITY                         .
CONTROLS: TCTRL_ZCITY
            TYPE TABLEVIEW USING SCREEN '0004'.
*...processing: ZCOUNTRY........................................*
DATA:  BEGIN OF STATUS_ZCOUNTRY                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCOUNTRY                      .
CONTROLS: TCTRL_ZCOUNTRY
            TYPE TABLEVIEW USING SCREEN '0005'.
*...processing: ZCUSTOMER.......................................*
DATA:  BEGIN OF STATUS_ZCUSTOMER                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCUSTOMER                     .
CONTROLS: TCTRL_ZCUSTOMER
            TYPE TABLEVIEW USING SCREEN '0006'.
*...processing: ZORDER..........................................*
DATA:  BEGIN OF STATUS_ZORDER                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZORDER                        .
CONTROLS: TCTRL_ZORDER
            TYPE TABLEVIEW USING SCREEN '0007'.
*...processing: ZORDERITEM......................................*
DATA:  BEGIN OF STATUS_ZORDERITEM                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZORDERITEM                    .
CONTROLS: TCTRL_ZORDERITEM
            TYPE TABLEVIEW USING SCREEN '0008'.
*...processing: ZPUBLISHER......................................*
DATA:  BEGIN OF STATUS_ZPUBLISHER                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPUBLISHER                    .
CONTROLS: TCTRL_ZPUBLISHER
            TYPE TABLEVIEW USING SCREEN '0009'.
*...processing: ZSTATE..........................................*
DATA:  BEGIN OF STATUS_ZSTATE                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSTATE                        .
CONTROLS: TCTRL_ZSTATE
            TYPE TABLEVIEW USING SCREEN '0010'.
*...processing: ZSTREET.........................................*
DATA:  BEGIN OF STATUS_ZSTREET                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSTREET                       .
CONTROLS: TCTRL_ZSTREET
            TYPE TABLEVIEW USING SCREEN '0011'.
*.........table declarations:.................................*
TABLES: *ZADDRESS                      .
TABLES: *ZAUTHOR                       .
TABLES: *ZBOOK                         .
TABLES: *ZCITY                         .
TABLES: *ZCOUNTRY                      .
TABLES: *ZCUSTOMER                     .
TABLES: *ZORDER                        .
TABLES: *ZORDERITEM                    .
TABLES: *ZPUBLISHER                    .
TABLES: *ZSTATE                        .
TABLES: *ZSTREET                       .
TABLES: ZADDRESS                       .
TABLES: ZAUTHOR                        .
TABLES: ZBOOK                          .
TABLES: ZCITY                          .
TABLES: ZCOUNTRY                       .
TABLES: ZCUSTOMER                      .
TABLES: ZORDER                         .
TABLES: ZORDERITEM                     .
TABLES: ZPUBLISHER                     .
TABLES: ZSTATE                         .
TABLES: ZSTREET                        .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
