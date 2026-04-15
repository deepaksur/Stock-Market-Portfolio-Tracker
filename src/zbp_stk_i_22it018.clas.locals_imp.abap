CLASS lhc_StockItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE StockItem.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE StockItem.
    METHODS read FOR READ
      IMPORTING keys FOR READ StockItem RESULT result.
    METHODS rba_Portfolio FOR READ
      IMPORTING keys_rba FOR READ StockItem\_Portfolio
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_StockItem IMPLEMENTATION.

  METHOD update.
    DATA: ls_stk_itm TYPE zcit_ptf_s_it018.
    LOOP AT entities INTO DATA(ls_entities).
      ls_stk_itm = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_stk_itm-portfolioid IS NOT INITIAL.
        SELECT FROM zcit_ptf_s_it018 FIELDS *
          WHERE portfolioid = @ls_stk_itm-portfolioid
            AND stockitemno = @ls_stk_itm-stockitemno
          INTO TABLE @DATA(lt_stk_itm).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_ptf_ut_22it018=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_stk_itm = ls_stk_itm
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #(
              portfolioid = ls_stk_itm-portfolioid
              stockitemno = ls_stk_itm-stockitemno )
            TO mapped-stockitem.
            APPEND VALUE #( %key = ls_entities-%key
              %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
                v1 = 'Stock Item Updated Successfully'
                severity = if_abap_behv_message=>severity-success ) )
            TO reported-stockitem.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid = ls_entities-%cid_ref
            portfolioid = ls_stk_itm-portfolioid
            stockitemno = ls_stk_itm-stockitemno )
          TO failed-stockitem.
          APPEND VALUE #(
            %cid = ls_entities-%cid_ref
            portfolioid = ls_stk_itm-portfolioid
            %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
              v1 = 'Stock Item Not Found'
              severity = if_abap_behv_message=>severity-error ) )
          TO reported-stockitem.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    TYPES: BEGIN OF ty_stk_itm,
             portfolioid TYPE zcit_ptf_ele_018 ,
             stockitemno TYPE int2,
           END OF ty_stk_itm.
    DATA ls_stk_itm TYPE ty_stk_itm.
    DATA(lo_util) = zcl_ptf_ut_22it018=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_stk_itm.
      ls_stk_itm-portfolioid = ls_key-portfolioid.
      ls_stk_itm-stockitemno = ls_key-stockitemno.
      lo_util->set_itm_t_deletion( im_stk_info = ls_stk_itm ).
      APPEND VALUE #(
        %cid        = ls_key-%cid_ref
        portfolioid = ls_key-portfolioid
        stockitemno = ls_key-stockitemno
        %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
          v1 = 'Stock Item Deleted Successfully'
          severity = if_abap_behv_message=>severity-success ) )
      TO reported-stockitem.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    " Optional for transactional flow
  ENDMETHOD.

  METHOD rba_Portfolio.
    " Optional read by association
  ENDMETHOD.

ENDCLASS.
