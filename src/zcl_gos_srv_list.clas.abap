class ZCL_GOS_SRV_LIST definition
  public
  inheriting from CL_GOS_SERVICE
  final
  create public .

public section.
  METHODS execute REDEFINITION.
protected section.
PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GOS_SRV_LIST IMPLEMENTATION.


  method EXECUTE.
    WRITE: 'Test EM'.
  endmethod.
ENDCLASS.
