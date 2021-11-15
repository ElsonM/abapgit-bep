class ZCA_OS_SCARR definition
  public
  inheriting from ZCB_OS_SCARR
  final
  create private .

public section.

  class-data AGENT type ref to ZCA_OS_SCARR read-only .

  class-methods CLASS_CONSTRUCTOR .
protected section.
private section.
ENDCLASS.



CLASS ZCA_OS_SCARR IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
***BUILD 090501
************************************************************************
* Purpose        : Initialize the 'class'.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : Singleton is created.
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 1999-09-20   : (OS) Initial Version
* - 2000-03-06   : (BGR) 2.0 modified REGISTER_CLASS_AGENT
************************************************************************
* GENERATED: Do not modify
************************************************************************

  create object AGENT.

  call method AGENT->REGISTER_CLASS_AGENT
    exporting
      I_CLASS_NAME          = 'ZCL_OS_SCARR'
      I_CLASS_AGENT_NAME    = 'ZCA_OS_SCARR'
      I_CLASS_GUID          = '0050569A50B51EE7AE984EBD067E115C'
      I_CLASS_AGENT_GUID    = '0050569A50B51EE7AE984EFA6EFC515C'
      I_AGENT               = AGENT
      I_STORAGE_LOCATION    = 'SCARR'
      I_CLASS_AGENT_VERSION = '2.0'.

           "CLASS_CONSTRUCTOR
  endmethod.
ENDCLASS.
