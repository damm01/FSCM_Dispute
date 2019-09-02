class ZCL_IM_FDM_AR_DISP_COMPLET definition
  public
  final
  create public .

public section.

  interfaces IF_EX_FDM_AR_DISP_COMPLETE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_FDM_AR_DISP_COMPLET IMPLEMENTATION.


METHOD if_ex_fdm_ar_disp_complete~complete_dispute.

*"--------------------------------------------------------------------
* JIRA ticket: S4HANA-1497 O2C - Country field [...] must be added
* Transports : Task S4DK900683
* Date       : 2019-08-13
* Developer  : Jochen Teufel (JTN3283)
* Description: Provide default value for country field by
*              enhancing BAdI FDM_AR_DISP_COMPLETE.
*              Adoption of implementation by PATT03 on SAP MTS.
*-----------------------------------------------------------------------

  TYPES: BEGIN OF lty_but020,
           partner    TYPE bu_partner,
           addrnumber	TYPE ad_addrnum,
         END OF lty_but020,

         BEGIN OF lty_land,
           country TYPE land1,
         END OF lty_land.

  DATA: ls_attribute TYPE fdm_attribute,
        ls_add_attr  TYPE fdm_attribute,
        ls_but020    TYPE lty_but020,
        ls_land      TYPE lty_land.

  CLEAR: ls_attribute, ls_add_attr, ls_but020, ls_land.

  READ TABLE t_attributes INTO ls_attribute WITH KEY attr_id = 'FIN_KUNNR'.
  IF sy-subrc EQ 0.
    SELECT SINGLE partner addrnumber FROM but020 INTO ls_but020 WHERE partner = ls_attribute-attr_value.
    IF sy-subrc EQ 0.
      SELECT SINGLE country FROM adrc INTO ls_land WHERE addrnumber = ls_but020-addrnumber.
      IF sy-subrc EQ 0.
        ls_add_attr-attr_id = 'ZZLAND1'.
        ls_add_attr-attr_value = ls_land-country.
        APPEND ls_add_attr TO c_additional_attributes.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.
ENDCLASS.
