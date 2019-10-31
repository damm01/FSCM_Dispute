@AbapCatalog.sqlViewName: 'ZI_V_DISPPROT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'protocoll of a dispute case'

define view zi_dispute_srmprotocol 
    as select from srmprotocol
    
    // join to get the case gui id
    
     {

    key poid_id,
    key timestamp,
    key xuser,
    area_id,
    act_id,
    subobj_id,
    arg1,
    arg2,
    arg_string,
    act_otr_ref,
    expiry_date,
    display_name,
    not_del,
    sps_id,
    
    @ObjectModel.readOnly: true
    '00000000000000000000000000000000'  as case_guid
    
}
