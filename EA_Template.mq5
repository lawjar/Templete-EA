//+------------------------------------------------------------------+
//|                                                  EA_Template.mq5 |
//|                                    Copyright 2026, Lawjar-Algo   |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Lawjar-Algo"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\AccountInfo.mqh>

//--- Input Parameters ---
input group             "=== General Settings ==="
input int               MagicNumber = 123456;         // Magic Number
input string            OrderComment = "TemplateEA";  // Order Comment

input group             "=== Risk Settings ==="
input double            LotSize = 0.01;               // Fixed Lot Size
input int               StopLoss = 50;                // Stop Loss (Points)
input int               TakeProfit = 100;             // Take Profit (Points)
input int               MaxSlippage = 10;             // Max Slippage (Points)

//--- Global Objects ---
CTrade                  m_trade;
CSymbolInfo             m_symbol;
CPositionInfo           m_position;
CAccountInfo            m_account;

//--- Global Variables ---
// int                  m_handle_indicator;           // Example: Indicator Handle

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // 1. Initialize Symbol
   if(!m_symbol.Name(Symbol()))
     {
      Print("Failed to initialize system for symbol: ", Symbol());
      return(INIT_FAILED);
     }
   
   // 2. Initialize Trade Object
   m_trade.SetExpertMagicNumber(MagicNumber);
   m_trade.SetMarginMode();
   m_trade.SetTypeFillingBySymbol(Symbol());
   m_trade.SetDeviationInPoints(MaxSlippage);

   // 3. Initialize Indicators (Example)
   // m_handle_indicator = iMA(Symbol(), Period(), ...);
   // if(m_handle_indicator == INVALID_HANDLE) 
   //   { Print("Failed to create indicator handle"); return(INIT_FAILED); }

   Print("EA Template Initialized successfully.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // Release indicator handles if used
   // IndicatorRelease(m_handle_indicator);
   
   Print("EA Template Deinitialized. Reason: ", reason);
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // 1. Refresh Market Data
   if(!RefreshRates()) return;

   // 2. Check for Open Positions
   int total_positions = PositionsTotal();
   
   // 3. Main Strategy Logic (Example Placeholders)
   // if(total_positions == 0) CheckEntrySignals();
   // else                     ManageOpenPositions();
  }

//+------------------------------------------------------------------+
//| Helper: Refresh Symbol Rates                                     |
//+------------------------------------------------------------------+
bool RefreshRates()
  {
   if(!m_symbol.RefreshRates())
     {
      // Silently fail or log debug info, avoiding spam
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
