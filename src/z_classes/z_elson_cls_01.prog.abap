*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_01.

*Step 1 -- We declare classes using REF TO because they are objects
DATA: lr_class1 TYPE REF TO zcl_sapn1,
      lr_class2 TYPE REF TO zcl_sapn1.

*Step 2 -- Create objectes for the class
CREATE OBJECT lr_class1.
CREATE OBJECT lr_class2.

*Call class component with the instance
lr_class1->av_name = 'FIRST ATTRIBUTE NAME'.
lr_class2->av_name = 'SECOND ATTRIBUTE NAME'.

WRITE:/ lr_class1->av_name. "Output will be 'FIRST ATTRIBUTE NAME'
WRITE:/ lr_class2->av_name. "Output will be 'SECOND ATTRIBUTE NAME'
