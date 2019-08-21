*----------------------------------------------------------------------*
***INCLUDE LZVFIFSCM_ASSIGNF01.
*----------------------------------------------------------------------*

FORM f_select_actions.
  BREAK mnp8911.

  DATA: t_action TYPE TABLE OF zfifscm_action,
        v_action TYPE zfifscm_action.

  SELECT *
    FROM zfifscm_action
    INTO TABLE t_action.


  LOOP AT t_action INTO v_action.
    MOVE: v_action-action_id TO zfifscm_assign-action_id.
  ENDLOOP.

ENDFORM.
