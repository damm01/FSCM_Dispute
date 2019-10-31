@AbapCatalog.sqlViewName: 'ZC_V_DISPPROT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'consumption view dipute protocol'


@UI:{
  headerInfo:{
    typeName: 'Dispute Log',
    typeNamePlural: 'Dispute Logs',
    title:{type: #STANDARD, value: 'poid_id'}
  },
  presentationVariant: [{sortOrder: [{by: 'timestamp', direction: #DESC }] }]
}
//@Search.searchable: true

//@OData.publish: true

define view zc_dispute_srmprotocol
  as select from zi_dispute_srmprotocol
{

  key poid_id,
  
      @UI:{ lineItem: [{position: 10,importance: #HIGH }],
            identification: [{position: 10 }]
          }
      @EndUserText.label: 'Time Stamp'
  key timestamp,
  
      @UI:{ lineItem: [{position: 20,importance: #HIGH }],
            identification: [{position: 20 }]
          }
      @EndUserText.label: 'User'
  key xuser,
      area_id,
      act_id,
      subobj_id,
      arg1,
      arg2,
      
      @UI:{ lineItem: [{position: 50,importance: #HIGH }],
            identification: [{position: 50 }]
          }
      @EndUserText.label: 'Arg String'
      arg_string,
      
      act_otr_ref,
      expiry_date,
      display_name,
      not_del,
      sps_id,
      case_guid

}
