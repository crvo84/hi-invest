//
//  RatiosKeys.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#ifndef Villou_Invest_RatiosKeys_h
#define Villou_Invest_RatiosKeys_h

// Sorting Values Identifiers Keys
#define FinancialRatioROA @"Return On Assets"
#define FinancialRatioROE @"Return On Equity"
#define FinancialRatioPriceEarnings @"Price/Earnings"
#define FinancialRatioPriceSales @"Price/Sales"
#define FinancialRatioDividendYield @"Dividend Yield"
#define FinancialRatioDividendPayout @"Dividend Payout"
#define FinancialRatioDebtEquity @"Debt/Equity"
#define FinancialRatioPriceBook @"Price/Book"
#define FinancialRatioCurrentRatio @"Current Ratio"
#define FinancialRatioQuickRatio @"Quick Ratio"
#define FinancialRatioCashRatio @"Cash Ratio"
#define FinancialRatioGrossMargin @"Gross Margin"
#define FinancialRatioEBITDAMargin @"EBITDA Margin"
#define FinancialRatioOperatingMargin @"Operating Margin"
#define FinancialRatioEffectiveTaxRate @"Effective Tax Rate"
#define FinancialRatioProfitMargin @"Profit Margin"
#define FinancialRatioFinancialLeverage @"Financial Leverage"
#define FinancialRatioWeightInPortfolio @"Weight in Portfolio"

// Array containing all Sorting Values Identifiers Keys
#define FinancialSortingValuesIdentifiersArray @[FinancialRatioROA, FinancialRatioROE, FinancialRatioPriceEarnings, FinancialRatioPriceSales, FinancialRatioDividendYield, FinancialRatioDividendPayout, FinancialRatioPriceBook, FinancialRatioDebtEquity, FinancialRatioFinancialLeverage, FinancialRatioCurrentRatio, FinancialRatioQuickRatio, FinancialRatioCashRatio, FinancialRatioGrossMargin, FinancialRatioEBITDAMargin, FinancialRatioOperatingMargin, FinancialRatioEffectiveTaxRate,FinancialRatioProfitMargin, FinancialRatioWeightInPortfolio]

// Array containing all Sorting Values Identifiers Keys which are Financial Ratios
#define FinancialRatioIdentifiersArray @[FinancialRatioROA, FinancialRatioROE, FinancialRatioPriceEarnings, FinancialRatioPriceSales, FinancialRatioDividendYield, FinancialRatioDividendPayout, FinancialRatioPriceBook, FinancialRatioDebtEquity, FinancialRatioFinancialLeverage, FinancialRatioCurrentRatio, FinancialRatioQuickRatio, FinancialRatioCashRatio, FinancialRatioGrossMargin, FinancialRatioEBITDAMargin, FinancialRatioOperatingMargin, FinancialRatioEffectiveTaxRate, FinancialRatioProfitMargin]

// Array containing all Sorting Values Identifiers Keys which are showed as percentage.
#define FinancialSortingValuesPercentValuesArray @[FinancialRatioROA, FinancialRatioROE, FinancialRatioDividendYield, FinancialRatioDividendPayout, FinancialRatioGrossMargin, FinancialRatioEBITDAMargin, FinancialRatioOperatingMargin, FinancialRatioEffectiveTaxRate, FinancialRatioProfitMargin, FinancialRatioWeightInPortfolio]

// Sorting Values Definitions
#define FinancialRatioROADefinition @"The amount of profit a company is able to generate for each dollar invested on assets."
#define FinancialRatioROEDefinition @"The amount of profit a company is able to generate for each dollar invested by its shareholders."
#define FinancialRatioPriceEarningsDefinition @"The market price per share divided by annual net income per share."
#define FinancialRatioPriceSalesDefinition @"The market price per share divided by annual revenue per share."
#define FinancialRatioDividendYieldDefinition @"The amount that a company pays out in annual dividends per share relative to its share price."
#define FinancialRatioDividendPayoutDefinition @"The amount that a company pays out in annual dividends relative to its net income."
#define FinancialRatioDebtEquityDefinition @"The relative proportion of shareholders' equity and debt used to finance a company's assets."
#define FinancialRatioPriceBookDefinition @"Compares a company's current market price to its book value."
#define FinancialRatioCurrentRatioDefinition @"An indication of a firm's ability to meet short term creditor's demands with its short-term assets."
#define FinancialRatioQuickRatioDefinition @"An indication of a firm's ability to meet short term creditor's demands with its short-term assets, but excluding Inventories."
#define FinancialRatioCashRatioDefinition @"An indication of a firm's ability to meet short term creditor's demands with its Cash and Marketable Securities."
#define FinancialRatioGrossMarginDefinition @"The proportion of a company's revenue left over after accounting the cost of goods sold."
#define FinancialRatioEBITDAMarginDefinition @"The proportion of a company's revenue left over after variable production costs, but excluding Depreciation and Amortization."
#define FinancialRatioOperatingMarginDefinition @"The proportion of a company's revenue left over after variable production costs." // ??
#define FinancialRatioEffectiveTaxRateDefinition @"The average rate at which a company's pre-tax profits are taxed."
#define FinancialRatioProfitMarginDefinition @"The net profit as a percentage of the revenue."
#define FinancialRatioFinancialLeverageDefinition @"The amount of assets of a company for each dollar invested by its shareholders."
#define FinancialRatioWeightInPortfolioDefinition @"The percentage composition of a particular stock holding in the total portfolio value." // Stock Market Definitions

// Dictionary mapping each Sorting Value Identifier with its corresponding definition
#define FinancialRatiosDefinitionsDictionary @{ FinancialRatioROA : FinancialRatioROADefinition, FinancialRatioROE : FinancialRatioROEDefinition, FinancialRatioPriceEarnings : FinancialRatioPriceEarningsDefinition, FinancialRatioPriceSales : FinancialRatioPriceSalesDefinition, FinancialRatioDividendYield : FinancialRatioDividendYieldDefinition, FinancialRatioDividendPayout : FinancialRatioDividendPayoutDefinition, FinancialRatioDebtEquity : FinancialRatioDebtEquityDefinition, FinancialRatioPriceBook : FinancialRatioPriceBookDefinition, FinancialRatioCurrentRatio : FinancialRatioCurrentRatioDefinition, FinancialRatioQuickRatio : FinancialRatioQuickRatioDefinition, FinancialRatioCashRatio : FinancialRatioCashRatioDefinition, FinancialRatioGrossMargin : FinancialRatioGrossMarginDefinition, FinancialRatioEBITDAMargin : FinancialRatioEBITDAMarginDefinition, FinancialRatioOperatingMargin : FinancialRatioOperatingMarginDefinition, FinancialRatioEffectiveTaxRate : FinancialRatioEffectiveTaxRateDefinition, FinancialRatioProfitMargin : FinancialRatioProfitMarginDefinition, FinancialRatioFinancialLeverage : FinancialRatioFinancialLeverageDefinition}

// Financial Ratio Interpretations
#define FinancialRatioROAInterpretation @"Every $1 invested in total assets during the year produced %@ of net income."
#define FinancialRatioROEInterpretation @"Every $1 of common stockholder's equity during the year earned %@ of net income."
#define FinancialRatioDividendYieldInterpretation @"Investors are willing to pay $1 for every %@ that they company paid as dividends in a year."
#define FinancialRatioDividendPayoutInterpretation @"The company paid %@ as dividends in a year for every $1 of annual earnings generated."
#define FinancialRatioPriceEarningsInterpretation @"Investors are willing to pay %@ for every $1 of annual earnings."
#define FinancialRatioPriceSalesInterpretation @"Investors are willing to pay %@ for every $1 of annual revenue."
#define FinancialRatioDebtEquityInterpretation @"For every $1 of stockholder's equity the company has %@ of total debt."
#define FinancialRatioPriceBookInterpretation @"Investors are willing to pay %@ for every $1 of common stockholder's equity."
#define FinancialRatioCurrentRatioInterpretation @"For every $1 of current liabilities the company has %@ of current assets."
#define FinancialRatioQuickRatioInterpretation @"The company has %@ of liquid assets available to cover each $1 of current liabilities."
#define FinancialRatioCashRatioInterpretation @"The company is able to pay off %@ of every $1 of current liabilities using only its cash and cash equivalents."
#define FinancialRatioGrossMarginInterpretation @"After paying inventory costs, the company still has %@ of every $1 of its sales revenue."
#define FinancialRatioEBITDAMarginInterpretation @"After paying inventory costs and operating expenses (excluding tax, interest, depreciation and amortization), the company still has %@ of every $1 of its sales revenue."
#define FinancialRatioOperatingMarginInterpretation @"After paying inventory costs and operating expenses, the company still has %@ of every $1 of its sales revenue."
#define FinancialRatioEffectiveTaxRateInterpretation @"The company pays %@ in taxes for every $1 of pre-tax profit."
#define FinancialRatioProfitMarginInterpretation @"The company has %@ of net income for every $1 of sales."
#define FinancialRatioFinancialLeverageInterpretation @"The company has %@ of total assets for every $1 of stockholder's equity."
#define FinancialRatioWeightInPortfolioInterpretation @"Investments in this company represent %@ for every $1 of the total portfolio."

// Dictionary mapping each Sorting Value Identifier with its corresponding interpretation
#define FinancialRatiosInterpretationsDictionary @{ FinancialRatioROA : FinancialRatioROAInterpretation, FinancialRatioROE : FinancialRatioROEInterpretation, FinancialRatioPriceEarnings : FinancialRatioPriceEarningsInterpretation, FinancialRatioPriceSales : FinancialRatioPriceSalesInterpretation, FinancialRatioDividendYield : FinancialRatioDividendYieldInterpretation, FinancialRatioDividendPayout : FinancialRatioDividendPayoutInterpretation, FinancialRatioDebtEquity : FinancialRatioDebtEquityInterpretation, FinancialRatioPriceBook : FinancialRatioPriceBookInterpretation, FinancialRatioCurrentRatio : FinancialRatioCurrentRatioInterpretation, FinancialRatioQuickRatio : FinancialRatioQuickRatioInterpretation, FinancialRatioCashRatio : FinancialRatioCashRatioInterpretation, FinancialRatioGrossMargin : FinancialRatioGrossMarginInterpretation, FinancialRatioEBITDAMargin : FinancialRatioEBITDAMarginInterpretation, FinancialRatioOperatingMargin : FinancialRatioOperatingMarginInterpretation, FinancialRatioEffectiveTaxRate : FinancialRatioEffectiveTaxRateInterpretation, FinancialRatioProfitMargin : FinancialRatioProfitMarginInterpretation, FinancialRatioFinancialLeverage : FinancialRatioFinancialLeverageInterpretation, FinancialRatioWeightInPortfolio : FinancialRatioWeightInPortfolioInterpretation }

// Financial Ratio Maximum and Minimum values for quiz questions
#define FinancialRatioMaxValueKey @"Max ratio value"
#define FinancialRatioMinValueKey @"Min ratio value"
// ----------
#define FinancialRatioROAMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(0.3) }
#define FinancialRatioROEMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(0.75) }
#define FinancialRatioPriceEarningsMaxMinValues @{ FinancialRatioMinValueKey : @(1.0), FinancialRatioMaxValueKey : @(30.0) }
#define FinancialRatioPriceSalesMaxMinValues @{ FinancialRatioMinValueKey : @(0.2), FinancialRatioMaxValueKey : @(7.0) }
#define FinancialRatioDividendYieldMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(0.1) }
#define FinancialRatioDividendPayoutMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(1.0) }
#define FinancialRatioDebtEquityMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(5.0) }
#define FinancialRatioPriceBookMaxMinValues @{ FinancialRatioMinValueKey : @(0.2), FinancialRatioMaxValueKey : @(10.0) }
#define FinancialRatioCurrentRatioMaxMinValues @{ FinancialRatioMinValueKey : @(0.2), FinancialRatioMaxValueKey : @(5.0) }
#define FinancialRatioQuickRatioMaxMinValues @{ FinancialRatioMinValueKey : @(0.2), FinancialRatioMaxValueKey : @(5.0) }
#define FinancialRatioCashRatioMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(3.0) }
#define FinancialRatioGrossMarginMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(0.85) }
#define FinancialRatioEBITDAMarginMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(0.75) }
#define FinancialRatioOperatingMarginMaxMinValues @{ FinancialRatioMinValueKey : @(0.05), FinancialRatioMaxValueKey : @(0.5) }
#define FinancialRatioEffectiveTaxRateMaxMinValues @{ FinancialRatioMinValueKey : @(0.1), FinancialRatioMaxValueKey : @(0.5) }
#define FinancialRatioProfitMarginMaxMinValues @{ FinancialRatioMinValueKey : @(0.02), FinancialRatioMaxValueKey : @(0.4) }
#define FinancialRatioFinancialLeverageMaxMinValues @{ FinancialRatioMinValueKey : @(1.0), FinancialRatioMaxValueKey : @(15.0) }
// ----------

// Mapping Ratio identifiers with ratio dictionary with max and min values for quiz questions
#define FinancialRatioMaxAndMinValuesDictionary @{ FinancialRatioROA : FinancialRatioROAMaxMinValues, FinancialRatioROE : FinancialRatioROEMaxMinValues, FinancialRatioPriceEarnings : FinancialRatioPriceEarningsMaxMinValues, FinancialRatioPriceSales : FinancialRatioPriceSalesMaxMinValues, FinancialRatioDividendYield : FinancialRatioDividendYieldMaxMinValues, FinancialRatioDividendPayout : FinancialRatioDividendPayoutMaxMinValues, FinancialRatioDebtEquity : FinancialRatioDebtEquityMaxMinValues, FinancialRatioPriceBook : FinancialRatioPriceBookMaxMinValues, FinancialRatioCurrentRatio : FinancialRatioCurrentRatioMaxMinValues, FinancialRatioQuickRatio : FinancialRatioQuickRatioMaxMinValues, FinancialRatioCashRatio : FinancialRatioCashRatioMaxMinValues, FinancialRatioGrossMargin : FinancialRatioGrossMarginMaxMinValues, FinancialRatioEBITDAMargin : FinancialRatioEBITDAMarginMaxMinValues, FinancialRatioOperatingMargin : FinancialRatioOperatingMarginMaxMinValues, FinancialRatioEffectiveTaxRate : FinancialRatioEffectiveTaxRateMaxMinValues, FinancialRatioProfitMargin : FinancialRatioProfitMarginMaxMinValues, FinancialRatioFinancialLeverage : FinancialRatioFinancialLeverageMaxMinValues }
// ----------


// Financial Ratios Category Arrays
#define FinancialRatioCategoryLiquidityIdentifiersArray @[FinancialRatioCurrentRatio, FinancialRatioQuickRatio, FinancialRatioCashRatio]
#define FinancialRatioCategoryProfitabilyIdentifiersArray @[FinancialRatioROA, FinancialRatioROE, FinancialRatioPriceEarnings, FinancialRatioGrossMargin, FinancialRatioEBITDAMargin, FinancialRatioOperatingMargin, FinancialRatioEffectiveTaxRate, FinancialRatioProfitMargin]
#define FinancialRatioCategoryDebtIdentifiersArray @[FinancialRatioDebtEquity, FinancialRatioFinancialLeverage]
#define FinancialRatioCategoryInvestmentValuationIdentifiersArray @[FinancialRatioPriceSales, FinancialRatioPriceBook, FinancialRatioDividendYield]
#define FinancialRatioCategoryOperatingPerformanceIdentifiersArray @[]
#define FinancialRatioCategoryCashFlowIdentifiersArray @[FinancialRatioDividendPayout]

// Dictionary mapping each Financial Ratio Identifier with its corresponding formula image filename
#define FinancialRatiosImageFilenamesDictionary @{ FinancialRatioROA : FinancialRatioROA, FinancialRatioROE : FinancialRatioROE, FinancialRatioPriceEarnings : @"Price:Earnings", FinancialRatioPriceSales : @"Price:Sales", FinancialRatioDividendYield : FinancialRatioDividendYield, FinancialRatioDividendPayout : FinancialRatioDividendPayout, FinancialRatioDebtEquity : @"Debt:Equity", FinancialRatioPriceBook : @"Price:Book",FinancialRatioCurrentRatio : FinancialRatioCurrentRatio, FinancialRatioQuickRatio : FinancialRatioQuickRatio, FinancialRatioCashRatio : FinancialRatioCashRatio, FinancialRatioGrossMargin : FinancialRatioGrossMargin, FinancialRatioEBITDAMargin : FinancialRatioEBITDAMargin, FinancialRatioOperatingMargin : FinancialRatioOperatingMargin, FinancialRatioEffectiveTaxRate : FinancialRatioEffectiveTaxRate, FinancialRatioProfitMargin : FinancialRatioProfitMargin, FinancialRatioFinancialLeverage : FinancialRatioFinancialLeverage }














#endif
