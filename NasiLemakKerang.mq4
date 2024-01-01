#property copyright "Copyright 2023, Bazrun"
#property version   "1.00"
#property strict

string name = "NasiLemakKerang EA";
bool positionOpen;

int OnInit()
  {
   if(OrdersTotal() > 0)
     {
      positionOpen = true;
     }
   else
     {
      positionOpen = false;
     }

   return(INIT_SUCCEEDED);
  }

void OnTick()
  {
   double ma1 = iMA(Symbol(), 0, 24, 0, MODE_SMMA, PRICE_CLOSE, 0);
   double ma2 = iMA(Symbol(), 0, 38, 0, MODE_SMMA, PRICE_CLOSE, 0);
   double ma3 = iMA(Symbol(), 0, 50, 0, MODE_SMMA, PRICE_CLOSE, 0);
   double ma4 = iMA(Symbol(), 0, 62, 0, MODE_SMMA, PRICE_CLOSE, 0);
   double ma5 = iMA(Symbol(), 0, 100, 0, MODE_SMMA, PRICE_CLOSE, 0);

   if(!positionOpen)
     {

      double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
      double lotSize;
      double var;

      if(accountBalance < 100)
        {
         lotSize = 0.01;
        }
      else
        {
         var = accountBalance/10000;
         lotSize = NormalizeDouble(var, 2);
        }


      if(ma1 > ma2 && ma2 > ma3 && ma3 > ma4 && ma4 > ma5)
        {
         OrderSend(Symbol(), OP_BUY, lotSize, Bid, 3, 0, 0, name, 0, 0, Green);
         positionOpen = true;
        }

      if(ma5 > ma4 && ma4 > ma3 && ma3 > ma2 && ma2 > ma1)
        {
         OrderSend(Symbol(), OP_SELL, lotSize, Ask, 3, 0, 0, name, 0, 0, Red);
         positionOpen = true;
        }
     }

   if(positionOpen)
     {
      if((ma3 > ma5 && ma3 > ma1 && ma3 > ma2) || (ma5 > ma3 && ma1 > ma3 && ma2 > ma3))
        {
         ClosePositions();
         positionOpen = false;
        }
     }
  }

void ClosePositions()
  {
   bool endLoop = false, order = OrdersHistoryTotal();
   if(order < 1)
      endLoop = true;
   while(endLoop == false)
     {
      if(!OrderSelect(0,SELECT_BY_POS,MODE_TRADES))
         endLoop = true;
      else
        {
         OrderClose(OrderTicket(),OrderLots(),Bid,3);
        }
      order = OrdersHistoryTotal();
      if(order < 1)
         endLoop = true;
     }
  }