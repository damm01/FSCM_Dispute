@AbapCatalog.sqlViewAppendName: 'ZEUDMOVDCATTR'
@EndUserText.label: 'Extension CDS for Dispute Management'


extend view udmo_dc_attr_view with ZE_UDMO_V_DC_ATTR

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
  udm.zzprocessor_grp,
  udm.zzcustom_curr,
  udm.zzrevenue_last_year,
  udm.zzrevenue_actual,
  udm.zzto_be_collected,
  udm.zzescal_level,
  udm.zzescal_date,  
  udm.zzrequired_action_text,  
  udm.zzreason_code_text
    
}
