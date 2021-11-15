@AbapCatalog.sqlViewName: 'ZDEMO_V1'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Demo CDS Example'
define view ZCDS_DEMO as select from mara {
    *
}
