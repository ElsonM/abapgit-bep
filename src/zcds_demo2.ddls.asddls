@AbapCatalog.sqlViewName: 'ZDEMO_V2'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Demo CDS Example 2'
define view ZCDS_DEMO2 as select from mara {
    *
}
