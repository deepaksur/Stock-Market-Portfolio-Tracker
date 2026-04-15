@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Portfolio Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCIT_PTF_C_22IT018
  provider contract transactional_query
  as projection on ZCIT_PTF_I_22IT018
{
  key PortfolioId,
  PortfolioName,
  OwnerName,
  BaseCurrency,
  @Semantics.amount.currencyCode: 'BaseCurrency'
  TotalValue,
  CreatedOn,
  @Search.defaultSearchElement: true
  RiskProfile,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,

  /* Associations */
  _stockitem : redirected to composition child ZCIT_STK_C_22IT018
}
