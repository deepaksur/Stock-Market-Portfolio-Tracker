@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Stock Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCIT_STK_C_22IT018
  as projection on ZCIT_STK_I_22IT018
{
  key PortfolioId,
  key StockItemNo,
  @Search.defaultSearchElement: true
  TickerSymbol,
  CompanyName,
  Exchange,
  Sector,
  @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
  Quantity,
  QuantityUnit,
  @Semantics.amount.currencyCode: 'Currency'
  BuyPrice,
  @Semantics.amount.currencyCode: 'Currency'
  CurrentPrice,
  Currency,
  PurchaseDate,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,

  /* Associations */
  _portfolio : redirected to parent ZCIT_PTF_C_22IT018
}
