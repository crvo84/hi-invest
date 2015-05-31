//
//  GlossaryKeys.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#ifndef Hi_Invest_GlossaryKeys_h
#define Hi_Invest_GlossaryKeys_h


#define GlossaryTypeFinancialStatementTerms @"Financial Statements"
#define GlossaryTypeFinancialRatios @"Financial Ratios"
#define GlossaryTypeStockMarketTerms @"Stock Market"

#define GlossaryTypesArray @[ GlossaryTypeFinancialStatementTerms, GlossaryTypeFinancialRatios, GlossaryTypeStockMarketTerms ]

  // ------------------- //
 // FINANCIAL STATEMENT //
// ------------------- //

 /* Financial Statement Terms */
//----------------------------/
#define FinancialStatementTermFinancialStatement @"Financial Statement"
#define FinancialStatementTermBalanceSheet @"Balance Sheet"
#define FinancialStatementTermIncomeStatement @"Income Statement"
#define FinancialStatementTermCashFlow @"Cash Flow"
// Balance Sheet
#define FinancialStatementTermAsset @"Asset"
#define FinancialStatementTermCurrentAsset @"Current Asset"
#define FinancialStatementTermCash @"Cash"
#define FinancialStatementTermCashEquivalent @"Cash Equivalent"
#define FinancialStatementTermShortTermInvestment @"Short Term Investment"
#define FinancialStatementTermAccountsReceivable @"Accounts Receivable"
#define FinancialStatementTermLongTermAsset @"Long Term Asset"
#define FinancialStatementTermInventory @"Inventory"
#define FinancialStatementTermLongTermInvestment @"Long Term Investment"
#define FinancialStatementTermPropertyPlantAndEquipment @"Property, Plant and Equipment"
#define FinancialStatementTermGoodwill @"Goodwill"
#define FinancialStatementTermIntangibleAsset @"Intangible Asset"
#define FinancialStatementTermAmortization @"Amortization"
#define FinancialStatementTermDepreciation @"Depreciation"
#define FinancialStatementTermDeferredAssetCharge @"Deferred Asset Charge"
#define FinancialStatementTermLiability @"Liability"
#define FinancialStatementTermCurrentLiability @"Current Liability"
#define FinancialStatementTermAccountsPayable @"Accounts Payable"
#define FinancialStatementTermShortTermDebt @"Short Term Debt"
#define FinancialStatementTermLongTermDebt @"Long Term Debt"
#define FinancialStatementTermDeferredLiabilityCharge @"Deferred Liability Charge"
#define FinancialStatementTermMinorityInterest @"Minority Interest"
#define FinancialStatementTermNegativeGoodwill @"Negative Goodwill"
#define FinancialStatementTermShareholdersEquity @"Shareholders' Equity"
#define FinancialStatementTermPreferredStock @"Preferred Stock"
#define FinancialStatementTermCommonStock @"Common Stock"
#define FinancialStatementTermRetainedEarnings @"Retained Earnings"
#define FinancialStatementTermTreasuryStock @"Treasury Stock"
#define FinancialStatementTermCapitalSurplus @"Capital Surplus"
// Income Statement
#define FinancialStatementTermRevenue @"Revenue"
#define FinancialStatementTermCostOfGoodsSold @"Cost of Goods Sold"
#define FinancialStatementTermGrossProfit @"Gross Profit"
#define FinancialStatementTermOperatingExpense @"Operating Expense"
#define FinancialStatementTermResearchAndDevelopment @"Research and Development"
#define FinancialStatementTermSellingGeneralAndAdministrativeExpense @"Selling, General and Administrative Expense"
#define FinancialStatementTermNonRecurringExpense @"Non Recurring Expense"
#define FinancialStatementTermOperatingIncome @"Operating Income"
#define FinancialStatementTermContinuingOperations @"Continuing Operations"
#define FinancialStatementTermEBIT @"EBIT"
#define FinancialStatementTermEBITDA @"EBITDA"
#define FinancialStatementTermInterestExpense @"Interest Expense"
#define FinancialStatementTermIncomeBeforeTax @"Income Before Tax"
#define FinancialStatementTermIncomeTax @"Income Tax"
#define FinancialStatementTermDiscontinuedOperations @"Discontinued Operations"
#define FinancialStatementTermExtraordinaryItems @"Extraordinary Items"
#define FinancialStatementTermAccountingChange @"Accounting Change"
#define FinancialStatementTermNetIncome @"Net Income (or Earnings or Profit)"
// Cash Flow
#define FinancialStatementTermCashFlowFromOperatingActivities @"Cash Flow from Operating Activities"
#define FinancialStatementTermCashFlowFromInvestingActivities @"Cash Flow from Investing Activities"
#define FinancialStatementTermCashFlowFromFinancingActivities @"Cash Flow from Financing Activities"
#define FinancialStatementTermCapitalExpenditure @"Capital Expenditure"
#define FinancialStatementTermDividends @"Dividends"
#define FinancialStatementTermSalePurchaseOfStock @"Sale or Purchase of Stock"
#define FinancialStatementTermNetCashFlow @"Net Cash Flow"

// Array of General Financial Statement Terms
#define FinancialStatementGeneralTermsArray @[FinancialStatementTermFinancialStatement, FinancialStatementTermBalanceSheet, FinancialStatementTermIncomeStatement, FinancialStatementTermCashFlow]

// Array of Balance Sheet Terms
#define FinancialStatementBalanceSheetTermsArray @[FinancialStatementTermAsset, FinancialStatementTermCurrentAsset, FinancialStatementTermCash, FinancialStatementTermCashEquivalent, FinancialStatementTermShortTermInvestment, FinancialStatementTermAccountsReceivable, FinancialStatementTermLongTermAsset, FinancialStatementTermInventory, FinancialStatementTermLongTermInvestment, FinancialStatementTermPropertyPlantAndEquipment, FinancialStatementTermGoodwill, FinancialStatementTermIntangibleAsset, FinancialStatementTermAmortization, FinancialStatementTermDepreciation, FinancialStatementTermDeferredAssetCharge, FinancialStatementTermLiability, FinancialStatementTermCurrentLiability, FinancialStatementTermAccountsPayable, FinancialStatementTermShortTermDebt, FinancialStatementTermLongTermDebt, FinancialStatementTermDeferredLiabilityCharge, FinancialStatementTermMinorityInterest, FinancialStatementTermNegativeGoodwill, FinancialStatementTermShareholdersEquity, FinancialStatementTermPreferredStock, FinancialStatementTermCommonStock, FinancialStatementTermRetainedEarnings, FinancialStatementTermTreasuryStock, FinancialStatementTermCapitalSurplus]
// Array of Income Statement Terms
#define FinancialStatementIncomeStatementTermsArray @[FinancialStatementTermRevenue, FinancialStatementTermCostOfGoodsSold, FinancialStatementTermGrossProfit, FinancialStatementTermOperatingExpense, FinancialStatementTermResearchAndDevelopment, FinancialStatementTermSellingGeneralAndAdministrativeExpense, FinancialStatementTermNonRecurringExpense, FinancialStatementTermOperatingIncome, FinancialStatementTermContinuingOperations, FinancialStatementTermEBIT, FinancialStatementTermEBITDA, FinancialStatementTermInterestExpense, FinancialStatementTermIncomeBeforeTax, FinancialStatementTermIncomeTax, FinancialStatementTermDiscontinuedOperations, FinancialStatementTermExtraordinaryItems, FinancialStatementTermAccountingChange, FinancialStatementTermNetIncome]
// Array of Cash Flow Terms
#define FinancialStatementCashFlowTermsArray @[FinancialStatementTermCashFlowFromOperatingActivities, FinancialStatementTermCashFlowFromInvestingActivities, FinancialStatementTermCashFlowFromFinancingActivities, FinancialStatementTermCapitalExpenditure, FinancialStatementTermDividends, FinancialStatementTermSalePurchaseOfStock, FinancialStatementTermNetCashFlow]

 /* Financial Statement Definitions */
//----------------------------------/
#define FinancialStatementTermFinancialStatementDefinition @"A formal record of the financial activities of a business."
#define FinancialStatementTermBalanceSheetDefinition @"A financial statement that summarizes a company’s assets, liabilities and shareholders’ equity at a specific point in time."
#define FinancialStatementTermIncomeStatementDefinition @"A financial statement that summarizes the company’s revenues, expenses and profits during a specific period of time."
#define FinancialStatementTermCashFlowDefinition @"A financial statement that summarizes the movement of money into or out of a company during a specific period of time."
// Balance Sheet
#define FinancialStatementTermAssetDefinition @"Any owned tangible or intangible resource having economic value useful to the owner."
#define FinancialStatementTermCurrentAssetDefinition @"Asset that one can reasonably expect to convert into cash, sell, or consume in operations within a year."
#define FinancialStatementTermCashDefinition @"Paper currency and coins, negotiable money orders and checks, bank balances, and certain short term government securities."
#define FinancialStatementTermCashEquivalentDefinition @"Short term (less than three months), highly liquid investment that is convertible to known amount of cash."
#define FinancialStatementTermShortTermInvestmentDefinition @"Short term (less than twelve months) investment of excess cash, intended to be held until needed."
#define FinancialStatementTermAccountsReceivableDefinition @"Money owed by customers."
#define FinancialStatementTermLongTermAssetDefinition @"An asset that has a useful life of more than one year, is acquired for use in the operation of a business."
#define FinancialStatementTermInventoryDefinition @"Tangible property held for sale, or materials used in a production process to make a product."
#define FinancialStatementTermLongTermInvestmentDefinition @"An investment that management plans to hold for more than one year."
#define FinancialStatementTermPropertyPlantAndEquipmentDefinition @"Long term tangible assets used in the continuing operation of a business for a long time."
#define FinancialStatementTermGoodwillDefinition @"Intangible asset that arises when one company acquires another for a premium value."
#define FinancialStatementTermIntangibleAssetDefinition @"Asset that has no physical existence such as trademarks and patents."
#define FinancialStatementTermAmortizationDefinition @"Decreasing or accounting for an amount over multiple periods."
#define FinancialStatementTermDepreciationDefinition @"Systematic reduction in the recorded cost of a fixed asset."
#define FinancialStatementTermDeferredAssetChargeDefinition @"Prepayment made for a good or service that has not yet been received."
#define FinancialStatementTermLiabilityDefinition @"Debts or obligations owed by one entity (debtor) to another entity (creditor) payable in money, goods, or services."
#define FinancialStatementTermCurrentLiabilityDefinition @"Liability that will be settled by current assets."
#define FinancialStatementTermAccountsPayableDefinition @"Money owed to suppliers."
#define FinancialStatementTermShortTermDebtDefinition @"Obligation coming due within one year."
#define FinancialStatementTermLongTermDebtDefinition @"Financing or leasing obligations that are to come due more than one year in the future."
#define FinancialStatementTermDeferredLiabilityChargeDefinition @"Prepayment received for a good or service that has not been delivered."
#define FinancialStatementTermMinorityInterestDefinition @"A significant percentage (generally less than 50%) of a subsidiary company owned by another company or investor."
#define FinancialStatementTermNegativeGoodwillDefinition @"A bargain-purchase amount, occurs when a company buys an asset for less than its fair market value."
#define FinancialStatementTermShareholdersEquityDefinition @"A firm’s total assets minus its total liabilities."
#define FinancialStatementTermPreferredStockDefinition @"Stock that carries certain preferences over common stock, such as a prior claim on dividends and assets."
#define FinancialStatementTermCommonStockDefinition @"Ownership of a company, having no preferences generally in terms of dividends, voting rights or distributions."
#define FinancialStatementTermRetainedEarningsDefinition @"Accumulated undistributed earnings of a company."
#define FinancialStatementTermTreasuryStockDefinition @"Stock reacquired by the issuing company. It may be held indefinitely, retired or resold."
#define FinancialStatementTermCapitalSurplusDefinition @"Equity created from stock issued at a premium over par value."
// Income Statement
#define FinancialStatementTermRevenueDefinition @"Income that a company receives from its normal business activities, usually from the sale of goods and services to customers."
#define FinancialStatementTermCostOfGoodsSoldDefinition @"The cost of buying raw materials for producing finished goods."
#define FinancialStatementTermGrossProfitDefinition @"Difference between revenue and cost of goods sold."
#define FinancialStatementTermOperatingExpenseDefinition @"An expense other than cost of goods sold that is incurred in running a business."
#define FinancialStatementTermResearchAndDevelopmentDefinition @"Activity aimed at discovering new knowledge and using it to design new improved products and services."
#define FinancialStatementTermSellingGeneralAndAdministrativeExpenseDefinition @"Expenses incurred to promote, sell, or deliver products and services or to manage the overall company."
#define FinancialStatementTermNonRecurringExpenseDefinition @"An expense originated by an unusual event."
#define FinancialStatementTermOperatingIncomeDefinition @"Earnings excluding non-operating income or expense, interest and tax."
#define FinancialStatementTermContinuingOperationsDefinition @"Portion of a business expected to remain active."
#define FinancialStatementTermEBITDefinition @"Earnings excluding interest and tax."
#define FinancialStatementTermEBITDADefinition @"Earnings excluding interest, tax, depreciation and amortization"
#define FinancialStatementTermInterestExpenseDefinition @"Payment for the use of borrowed money."
#define FinancialStatementTermIncomeBeforeTaxDefinition @"Earnings excluding tax."
#define FinancialStatementTermIncomeTaxDefinition @"Income before tax multiplied by the appropiate tax rate."
#define FinancialStatementTermDiscontinuedOperationsDefinition @"Portion of a business that is planned to be or is discontinued."
#define FinancialStatementTermExtraordinaryItemsDefinition @"Unusual events and transactions"
#define FinancialStatementTermAccountingChangeDefinition @"Change in an accounting principle, an accounting estimate or the reporting entity."
#define FinancialStatementTermNetIncomeDefinition @"Revenues minus expenses."
// Cash Flow
#define FinancialStatementTermCashFlowFromOperatingActivitiesDefinition @"Cash flow from the company's core operations. Cash earnings plus changes in current assets and liabilities."
#define FinancialStatementTermCashFlowFromInvestingActivitiesDefinition @"Cash flow from the sale of long term assets and capital expenditure"
#define FinancialStatementTermCashFlowFromFinancingActivitiesDefinition @"Cash flow from the issue or payment of debt, issue or repurchase of stock or dividend payments."
#define FinancialStatementTermCapitalExpenditureDefinition @"Outlay of money to acquire or improve capital assets such as buildings and machinery."
#define FinancialStatementTermDividendsDefinition @"Distribution of earnings to shareholders in cash, stock or other assets."
#define FinancialStatementTermSalePurchaseOfStockDefinition @"The sale or purchase by a company of its own stock. Affects the number of outstanding shares."
#define FinancialStatementTermNetCashFlowDefinition @"Difference between a company's total cash inflows and outflows during a specific period of time."

// Dictionary of Financial Statement Term Definitions
#define FinancialStatementTermDefinitionsDictionary @{ FinancialStatementTermFinancialStatement : FinancialStatementTermFinancialStatementDefinition, FinancialStatementTermBalanceSheet : FinancialStatementTermBalanceSheetDefinition, FinancialStatementTermIncomeStatement : FinancialStatementTermIncomeStatementDefinition, FinancialStatementTermCashFlow : FinancialStatementTermCashFlowDefinition, FinancialStatementTermAsset : FinancialStatementTermAssetDefinition, FinancialStatementTermCurrentAsset : FinancialStatementTermCurrentAssetDefinition, FinancialStatementTermCash : FinancialStatementTermCashDefinition, FinancialStatementTermCashEquivalent : FinancialStatementTermCashEquivalentDefinition, FinancialStatementTermShortTermInvestment : FinancialStatementTermShortTermInvestmentDefinition, FinancialStatementTermAccountsReceivable : FinancialStatementTermAccountsReceivableDefinition, FinancialStatementTermLongTermAsset : FinancialStatementTermLongTermAssetDefinition, FinancialStatementTermInventory : FinancialStatementTermInventoryDefinition, FinancialStatementTermLongTermInvestment : FinancialStatementTermLongTermInvestmentDefinition, FinancialStatementTermPropertyPlantAndEquipment : FinancialStatementTermPropertyPlantAndEquipmentDefinition, FinancialStatementTermGoodwill : FinancialStatementTermGoodwillDefinition, FinancialStatementTermIntangibleAsset : FinancialStatementTermIntangibleAssetDefinition, FinancialStatementTermAmortization : FinancialStatementTermAmortizationDefinition, FinancialStatementTermDepreciation : FinancialStatementTermDepreciationDefinition, FinancialStatementTermDeferredAssetCharge : FinancialStatementTermDeferredAssetChargeDefinition, FinancialStatementTermLiability : FinancialStatementTermLiabilityDefinition, FinancialStatementTermCurrentLiability : FinancialStatementTermCurrentLiabilityDefinition, FinancialStatementTermAccountsPayable : FinancialStatementTermAccountsPayableDefinition, FinancialStatementTermShortTermDebt : FinancialStatementTermShortTermDebtDefinition, FinancialStatementTermLongTermDebt : FinancialStatementTermLongTermDebtDefinition, FinancialStatementTermDeferredLiabilityCharge : FinancialStatementTermDeferredLiabilityChargeDefinition, FinancialStatementTermMinorityInterest : FinancialStatementTermMinorityInterestDefinition, FinancialStatementTermNegativeGoodwill : FinancialStatementTermNegativeGoodwillDefinition, FinancialStatementTermShareholdersEquity : FinancialStatementTermShareholdersEquityDefinition, FinancialStatementTermPreferredStock : FinancialStatementTermPreferredStockDefinition, FinancialStatementTermCommonStock : FinancialStatementTermCommonStockDefinition, FinancialStatementTermRetainedEarnings : FinancialStatementTermRetainedEarningsDefinition, FinancialStatementTermTreasuryStock : FinancialStatementTermTreasuryStockDefinition, FinancialStatementTermCapitalSurplus : FinancialStatementTermCapitalSurplusDefinition, FinancialStatementTermRevenue : FinancialStatementTermRevenueDefinition, FinancialStatementTermCostOfGoodsSold : FinancialStatementTermCostOfGoodsSoldDefinition, FinancialStatementTermGrossProfit : FinancialStatementTermGrossProfitDefinition, FinancialStatementTermOperatingExpense : FinancialStatementTermOperatingExpenseDefinition, FinancialStatementTermResearchAndDevelopment : FinancialStatementTermResearchAndDevelopmentDefinition, FinancialStatementTermSellingGeneralAndAdministrativeExpense : FinancialStatementTermSellingGeneralAndAdministrativeExpenseDefinition, FinancialStatementTermNonRecurringExpense : FinancialStatementTermNonRecurringExpenseDefinition, FinancialStatementTermOperatingIncome : FinancialStatementTermOperatingIncomeDefinition, FinancialStatementTermContinuingOperations : FinancialStatementTermContinuingOperationsDefinition, FinancialStatementTermEBIT : FinancialStatementTermEBITDefinition, FinancialStatementTermEBITDA : FinancialStatementTermEBITDADefinition, FinancialStatementTermInterestExpense : FinancialStatementTermInterestExpenseDefinition, FinancialStatementTermIncomeBeforeTax : FinancialStatementTermIncomeBeforeTaxDefinition, FinancialStatementTermIncomeTax : FinancialStatementTermIncomeTaxDefinition, FinancialStatementTermDiscontinuedOperations : FinancialStatementTermDiscontinuedOperationsDefinition, FinancialStatementTermExtraordinaryItems : FinancialStatementTermExtraordinaryItemsDefinition, FinancialStatementTermAccountingChange : FinancialStatementTermAccountingChangeDefinition, FinancialStatementTermNetIncome : FinancialStatementTermNetIncomeDefinition, FinancialStatementTermCashFlowFromOperatingActivities : FinancialStatementTermCashFlowFromOperatingActivitiesDefinition, FinancialStatementTermCashFlowFromInvestingActivities : FinancialStatementTermCashFlowFromInvestingActivitiesDefinition, FinancialStatementTermCashFlowFromFinancingActivities : FinancialStatementTermCashFlowFromFinancingActivitiesDefinition, FinancialStatementTermCapitalExpenditure : FinancialStatementTermCapitalExpenditureDefinition, FinancialStatementTermDividends : FinancialStatementTermDividendsDefinition, FinancialStatementTermSalePurchaseOfStock : FinancialStatementTermSalePurchaseOfStockDefinition, FinancialStatementTermNetCashFlow : FinancialStatementTermNetCashFlowDefinition }



  //------------- //
 // STOCK MARKET //
// ------------ //

 /* Stock Market Terms */
//---------------------/
#define StockMarketTermAnnualizedReturn @"Annualized Return"
#define StockMarketTermBankruptcy @"Bankruptcy"
#define StockMarketTermBear @"Bear"
#define StockMarketTermBearMarket @"Bear Market"
#define StockMarketTermBull @"Bull"
#define StockMarketTermBullMarket @"Bull Market"
#define StockMarketTermBlueChipStock @"Blue Chip Stock"
#define StockMarketTermBookValue @"Book Value"
#define StockMarketTermMarket @"Market"
#define StockMarketTermMarketValue @"Market Value"
#define StockMarketTermMarketCapitalization @"Market Capitalization"
#define StockMarketTermCommission @"Commission"
#define StockMarketTermCrash @"Crash"
#define StockMarketTermFinancialRatio @"Financial Ratio"
#define StockMarketTermInitialPublicOffering @"Initial Public Offering"
#define StockMarketTermInvestmentRisk @"Investment Risk"
#define StockMarketTermLimitOrder @"Limit Order"
#define StockMarketTermLiquidity @"Liquidity"
#define StockMarketTermMarketOrder @"Market Order"
#define StockMarketTermStockMarketIndex @"Stock Market Index"
#define StockMarketTermPortfolio @"Portfolio"
#define StockMarketTermPortfolioDiversification @"Portfolio Diversification"
#define StockMarketTermPublicCompany @"Public Company"
#define StockMarketTermStockMarket @"Stock Market"
#define StockMarketTermStockExchange @"Stock Exchange"
#define StockMarketTermOverTheCounter @"Over the Counter"
#define StockMarketTermReturn @"Return"
#define StockMarketTermStock @"Stock"
#define StockMarketTermStockbroker @"Stockbroker"
#define StockMarketTermStockSplit @"Stock Split"
#define StockMarketTermReverseStockSplit @"Reverse Stock Split"
#define StockMarketTermSecurity @"Security"
#define StockMarketTermSEC @"SEC"
#define StockMarketTermSharesOutstanding @"Shares Outstanding"
#define StockMarketTermShareholder @"Shareholder"
#define StockMarketTermSpeculation @"Speculation"
#define StockMarketTermInvestment @"Investment"
#define StockMarketTermTickerSymbol @"Ticker Symbol"
#define StockMarketTermFundamentalAnalysis @"Fundamental Analysis"
#define StockMarketTermTechnicalAnalysis @"Technical Analysis"
#define StockMarketTermTrading @"Trading"
#define StockMarketTermTradingVolume @"Trading Volume"
#define StockMarketTermTrend @"Trend"
#define StockMarketTermWeightInPortfolio @"Weigth in Portfolio"

 /* Stock Market Definitions */
//---------------------------/
#define StockMarketTermAnnualizedReturnDefinition @"Return of an investment over a period of time, expressed as a time weighted annual percentage."
#define StockMarketTermBankruptcyDefinition @"Legal status of a company that cannot repay the debts it owes to creditors."
#define StockMarketTermBearDefinition @"An investor who believes a stock or the overall market will decline."
#define StockMarketTermBearMarketDefinition @"A market in which prices exhibit a declining trend."
#define StockMarketTermBullDefinition @"An investor who thinks the market will rise."
#define StockMarketTermBullMarketDefinition @"Any market in which prices are in an upward trend."
#define StockMarketTermBlueChipStockDefinition @"Common stock of well known companies with a history of growth and dividend payments."
#define StockMarketTermBookValueDefinition @"A company's total assets minus intangible assets and liabilities. Might be higher or lower than its market capitalization."
#define StockMarketTermMarketValueDefinition @"The price at which an asset would trade in a competitive auction setting."
#define StockMarketTermMarketCapitalizationDefinition @"The total dollar value of all outstanding shares at market value."
#define StockMarketTermCommissionDefinition @"The fee paid to a broker to execute a trade."
#define StockMarketTermCrashDefinition @"A sudden dramatic decline of stock prices."
#define StockMarketTermFinancialRatioDefinition @"The result of dividing one financial statement item by another. They quantify many aspects of a business."
#define StockMarketTermInitialPublicOfferingDefinition @"A company's first sale of stock to the public."
#define StockMarketTermInvestmentRiskDefinition @"Uncertainty about the future benefits to be realized from an investment."
#define StockMarketTermLimitOrderDefinition @"An order to buy a stock at or below a specified price, or to sell a stock at or above a specified price."
#define StockMarketTermLiquidityDefinition @"The ease and quickness with which assets can be converted to cash."
#define StockMarketTermMarketOrderDefinition @"An order to buy or sell a stock immediately at current market prices."
#define StockMarketTermStockMarketIndexDefinition @"A measurement of the value of a section of the stock market. Computed from the prices of selected stocks."
#define StockMarketTermPortfolioDefinition @"A collection of investments."
#define StockMarketTermPortfolioDiversificationDefinition @"Investing in different assets in an attempt to reduce overall investment risk."
#define StockMarketTermPublicCompanyDefinition @"A company that has held an initial public offering and whose shares are traded on the stock market."
#define StockMarketTermStockMarketDefinition @"The aggregation of buyers and sellers of stocks."
#define StockMarketTermStockExchangeDefinition @"A formal place or organization by which stock traders (people and companies) can trade stocks."
#define StockMarketTermOverTheCounterDefinition @"A decentralized market (as opposed to an exchange market) where geographically dispersed dealers trade stocks."
#define StockMarketTermReturnDefinition @"The change in the value of a portfolio over an evaluation period."
#define StockMarketTermStockDefinition @"Ownership of a corporation indicated by shares, which represent a piece of the corporation's assets and earnings."
#define StockMarketTermStockbrokerDefinition @"A regulated professional who buys and sells stocks for clients through the stock market."
#define StockMarketTermStockSplitDefinition @"Shares are effectively divided to form a larger number of proportionally less valuable shares."
#define StockMarketTermReverseStockSplitDefinition @"Shares are effectively merged to form a smaller number of proportionally more valuable shares."
#define StockMarketTermSecurityDefinition @"Paper certificate or electronic record evidencing ownership of stocks or bonds."
#define StockMarketTermSECDEfinition @"U.S. Securities and Exchange Commission. Federal agency that regulates the US financial markets."
#define StockMarketTermSharesOutstandingDefinition @"Shares that are currently owned by investors."
#define StockMarketTermShareholderDefinition @"Person or entity that owns shares or equity in a corporation."
#define StockMarketTermSpeculationDefinition @"The practice of engaging in risky transactions in an attempt to profit from fluctuations in the market price."
#define StockMarketTermInvestmentDefinition @"The practice of purchasing an asset with the expectation that it will generate income or appreciate in the future."
#define StockMarketTermTickerSymbolDefinition @"An abbreviation assigned to a security for trading purposes."
#define StockMarketTermFundamentalAnalysisDefinition @"Study of the assets, profits, and business trends of a company to derive an estimated value for the stock."
#define StockMarketTermTechnicalAnalysisDefinition @"Study of past market data (price and trading volume) to attempt to forecast the direction of stock prices."
#define StockMarketTermTradingDefinition @"Buying and selling securities."
#define StockMarketTermTradingVolumeDefinition @"The number of shares transacted every day."
#define StockMarketTermTrendDefinition @"A tendency of financial markets to move in a particular direction over time."
#define StockMarketTermWeightInPortfolioDefinition @"The percentage composition of a particular stock holding in the total portfolio value."

// Dictionary of Stock Market Term Definitions
#define StockMarketTermDefinitionsDictionary @{ StockMarketTermAnnualizedReturn : StockMarketTermAnnualizedReturnDefinition, StockMarketTermBankruptcy : StockMarketTermBankruptcyDefinition, StockMarketTermBear : StockMarketTermBearDefinition, StockMarketTermBearMarket : StockMarketTermBearMarketDefinition, StockMarketTermBull : StockMarketTermBullDefinition, StockMarketTermBullMarket : StockMarketTermBullMarketDefinition, StockMarketTermBlueChipStock : StockMarketTermBlueChipStockDefinition, StockMarketTermBookValue : StockMarketTermBookValueDefinition, StockMarketTermMarketValue : StockMarketTermMarketValueDefinition, StockMarketTermMarketCapitalization : StockMarketTermMarketCapitalizationDefinition, StockMarketTermCommission : StockMarketTermCommissionDefinition, StockMarketTermCrash : StockMarketTermCrashDefinition, StockMarketTermFinancialRatio : StockMarketTermFinancialRatioDefinition, StockMarketTermInitialPublicOffering : StockMarketTermInitialPublicOfferingDefinition, StockMarketTermInvestmentRisk : StockMarketTermInvestmentRiskDefinition, StockMarketTermLimitOrder : StockMarketTermLimitOrderDefinition, StockMarketTermLiquidity : StockMarketTermLiquidityDefinition, StockMarketTermMarketOrder : StockMarketTermMarketOrderDefinition, StockMarketTermStockMarketIndex : StockMarketTermStockMarketIndexDefinition, StockMarketTermPortfolio : StockMarketTermPortfolioDefinition, StockMarketTermPortfolioDiversification : StockMarketTermPortfolioDiversificationDefinition, StockMarketTermPublicCompany : StockMarketTermPublicCompanyDefinition, StockMarketTermStockMarket : StockMarketTermStockMarketDefinition, StockMarketTermStockExchange : StockMarketTermStockExchangeDefinition, StockMarketTermOverTheCounter : StockMarketTermOverTheCounterDefinition, StockMarketTermReturn : StockMarketTermReturnDefinition, StockMarketTermStock : StockMarketTermStockDefinition, StockMarketTermStockbroker : StockMarketTermStockbrokerDefinition, StockMarketTermStockSplit : StockMarketTermStockSplitDefinition, StockMarketTermReverseStockSplit : StockMarketTermReverseStockSplitDefinition, StockMarketTermSecurity : StockMarketTermSecurityDefinition, StockMarketTermSEC : StockMarketTermSECDEfinition, StockMarketTermSharesOutstanding : StockMarketTermSharesOutstandingDefinition, StockMarketTermShareholder : StockMarketTermShareholderDefinition, StockMarketTermSpeculation : StockMarketTermSpeculationDefinition, StockMarketTermInvestment : StockMarketTermInvestmentDefinition, StockMarketTermTickerSymbol : StockMarketTermTickerSymbolDefinition, StockMarketTermFundamentalAnalysis : StockMarketTermFundamentalAnalysisDefinition, StockMarketTermTechnicalAnalysis : StockMarketTermTechnicalAnalysisDefinition, StockMarketTermTrading : StockMarketTermTradingDefinition, StockMarketTermTradingVolume : StockMarketTermTradingVolumeDefinition, StockMarketTermTrend : StockMarketTermTrendDefinition, StockMarketTermWeightInPortfolio : StockMarketTermWeightInPortfolioDefinition }



//-------------------- //
// DEFINITION SOURCES //
// ----------------- //

#define FinancialDefinitionSourceNYSSCPATermsArray @[FinancialStatementTermCurrentAssetDefinition, FinancialStatementTermCashDefinition, FinancialStatementTermCashEquivalent, FinancialStatementTermShortTermInvestmentDefinition, FinancialStatementTermLongTermAssetDefinition, FinancialStatementTermInventoryDefinition, FinancialStatementTermLongTermInvestmentDefinition, FinancialStatementTermPropertyPlantAndEquipmentDefinition, FinancialStatementTermIntangibleAssetDefinition, FinancialStatementTermLiabilityDefinition, FinancialStatementTermShortTermDebtDefinition, FinancialStatementTermLongTermDebtDefinition, FinancialStatementTermPreferredStockDefinition, FinancialStatementTermTreasuryStockDefinition, FinancialStatementTermCapitalSurplusDefinition, FinancialStatementTermCostOfGoodsSoldDefinition, FinancialStatementTermOperatingExpenseDefinition, FinancialStatementTermResearchAndDevelopmentDefinition, FinancialStatementTermContinuingOperationsDefinition, FinancialStatementTermDiscontinuedOperationsDefinition, FinancialStatementTermAccountingChangeDefinition, FinancialStatementTermCapitalExpenditureDefinition, FinancialStatementTermCapitalExpenditureDefinition]

#define FinancialDefinitionSourceNASDAQTermsArray @[ StockMarketTermAnnualizedReturnDefinition, StockMarketTermBankruptcyDefinition,StockMarketTermBearDefinition, StockMarketTermCommissionDefinition, StockMarketTermCrashDefinition, StockMarketTermFinancialRatioDefinition, StockMarketTermInitialPublicOfferingDefinition, StockMarketTermInvestmentRiskDefinition, StockMarketTermLimitOrderDefinition, StockMarketTermStockMarketIndexDefinition, StockMarketTermPortfolioDefinition, StockMarketTermPortfolioDiversificationDefinition, StockMarketTermPublicCompanyDefinition, StockMarketTermStockMarketDefinition, StockMarketTermStockExchangeDefinition, StockMarketTermOverTheCounterDefinition, StockMarketTermReturnDefinition, StockMarketTermStockDefinition, StockMarketTermSharesOutstandingDefinition, StockMarketTermShareholderDefinition, StockMarketTermTickerSymbolDefinition, StockMarketTermTradingDefinition, StockMarketTermTradingVolumeDefinition ]



#endif
