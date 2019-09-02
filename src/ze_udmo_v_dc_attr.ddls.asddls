@AbapCatalog.sqlViewAppendName: 'ZEUDMOVDCATTR'
@EndUserText.label: 'Extension CDS for Dispute Management'


extend view udmo_dc_attr_view with ZE_UDMO_V_DC_ATTR
 association [0..1] to ZI_RequiredAction_Text as _ActionText
    on udm.zzrequired_action = _ActionText.action_id
{

  udm.zzcreate_time,
  udm.zzchange_time,
  udm.zzclosing_time,  
  @Semantics.address.country: true udm.zzland1,
  udm.zzname1,
  udm.zzname2,
  @Semantics.address.street: true udm.zzstras,
  @Semantics.address.zipCode: true udm.zzpstlz,
  @Semantics.address.city: true udm.zzort01,  
  udm.zzvat_id,
  udm.zzcomment,
  udm.zzprocessor_grp,
  udm.zzcustom_curr,
  udm.zzrevenue_last_year,
  udm.zzrevenue_actual,
  udm.zzto_be_collected,
  udm.zzescal_level,
  udm.zzescal_date,
  @Consumption.valueHelpDefinition: [{association : '_ActionText'}]
  @ObjectModel.foreignKey.association: '_ActionText'
  udm.zzrequired_action 
  
}
