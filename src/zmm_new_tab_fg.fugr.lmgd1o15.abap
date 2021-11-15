*------------------------------------------------------------------
*      FELDHISTORIE
*
* Ein geändertes Feld wird beim Anzeigen der Änderungsbeleghistorie =
* MM13 helleuchtend.
*------------------------------------------------------------------
MODULE FELDHISTORIE OUTPUT.

* check t130m-aktyp eq aktypz.

* loop at screen.
*   loop at positions
*       where fname eq screen-name+5(10).
*     screen-intensified = 1.
*     modify screen.
*   endloop.
* endloop.

ENDMODULE.
