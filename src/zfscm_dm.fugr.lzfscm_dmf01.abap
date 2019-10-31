*----------------------------------------------------------------------*
***INCLUDE LZFSCM_DMF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F_REASON_CODE_TEXT
*&---------------------------------------------------------------------*
FORM f_reason_code_text  USING    text
                          fieldvalue
                          p_type TYPE scmgcase_type
                          p_subrc TYPE sy-subrc.

  READ TABLE gt_scmgattr_reasont WITH KEY case_type = p_type
                                          langu = sy-langu
                                          reason_code = fieldvalue.

  IF sy-subrc = 0.
    MOVE gt_scmgattr_reasont-description TO text.
    CLEAR p_subrc.
    EXIT.
  ENDIF.

  SELECT * FROM scmgattr_reasont INTO TABLE gt_scmgattr_reasont.

  READ TABLE gt_scmgattr_reasont WITH KEY case_type = p_type
                                           langu = sy-langu
                                           reason_code = fieldvalue.

  IF sy-subrc = 0.
    MOVE gt_scmgattr_reasont-description TO text.
    CLEAR p_subrc.
  ELSE.
    MOVE 4 TO p_subrc.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_REQUIRED_ACTION_TEXT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*

FORM f_required_action_text  USING    text
                          fieldvalue
                          p_type TYPE scmgcase_type
                          p_subrc TYPE sy-subrc.

  READ TABLE gt_zfscm_dm_actt WITH KEY case_type = p_type
                                          langu = sy-langu
                                          action_id = fieldvalue.

  IF sy-subrc = 0.
    MOVE gt_zfscm_dm_actt-action_text TO text.
    CLEAR p_subrc.
    EXIT.
  ENDIF.

  SELECT * FROM zfscm_dm_actt INTO TABLE gt_zfscm_dm_actt.

  READ TABLE gt_zfscm_dm_actt WITH KEY case_type = p_type
                                           langu = sy-langu
                                           action_id = fieldvalue.

  IF sy-subrc = 0.
    MOVE gt_zfscm_dm_actt-action_text TO text.
    CLEAR p_subrc.
  ELSE.
    MOVE 4 TO p_subrc.
  ENDIF.

ENDFORM.
