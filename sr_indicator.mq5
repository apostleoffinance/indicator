//+------------------------------------------------------------------+
//|                                                  srindicator.mq5 |
//|                                               Apostle of finance |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Apostle of finance"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Lime        // Buy signal
#property indicator_color2 Red         // Sell signal

// Define input parameters
input int supportPeriod = 20;          // Period to detect support zones
input int resistancePeriod = 20;       // Period to detect resistance zones
input double supportThreshold = 0.1;   // Sensitivity for support zones
input double resistanceThreshold = 0.1;// Sensitivity for resistance zones
input int trendPeriod = 50;            // Period to determine trend direction

// Indicator buffers
double BuyBuffer[];
double SellBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Set indicator buffers
   SetIndexBuffer(0, BuyBuffer);
   SetIndexBuffer(1, SellBuffer);

   // Set indicator name
   string indicatorName = "MyIndicator";
   string shortName = "ShortName";
   IndicatorSetString(INDICATOR_SHORTNAME, shortName);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   // Calculate support and resistance zones
   double supportZone = iLowest(Symbol(), Period(), MODE_LOW, supportPeriod, 0);
   double resistanceZone = iHighest(Symbol(), Period(), MODE_HIGH, resistancePeriod, 0);

   // Calculate trend direction
   double ma_current = iMA(NULL, 0, trendPeriod, 0, MODE_SMA, PRICE_CLOSE);
   double ma_previous = iMA(NULL, 0, trendPeriod, 1, MODE_SMA, PRICE_CLOSE); // Changed variable name to 'ma_previous'
   double trend = ma_current - ma_previous;

   // Check for buy signal
   if (close[0] <= supportZone && MathAbs(close[0] - supportZone) < supportThreshold && trend > 0)
      BuyBuffer[0] = low[0];
   else
      BuyBuffer[0] = 0;

   // Check for sell signal
   if (close[0] >= resistanceZone && MathAbs(close[0] - resistanceZone) < resistanceThreshold && trend < 0)
      SellBuffer[0] = high[0];
   else
      SellBuffer[0] = 0;

   return(rates_total);
  }
