//+------------------------------------------------------------------+
//|                                             NasiLemakKerang.mq4  |
//|                                          Copyright 2023, Bazrun  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Bazrun"
#property version   "1.00"
#property strict

int maPeriod1 = 25;
int maPeriod2 = 50;
int maPeriod3 = 75;
int maPeriod4 = 100;
int maShift = 0;
int maMethod = MODE_SMA;
int maApplyTo = PRICE_CLOSE;
bool positionOpen;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    if (OrdersTotal() > 0){
    positionOpen = true;
    } else {
    positionOpen = false;
    }
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    double ma1 = iMA(Symbol(), 0, maPeriod1, maShift, maMethod, maApplyTo, 0);
    double ma2 = iMA(Symbol(), 0, maPeriod2, maShift, maMethod, maApplyTo, 0);
    double ma3 = iMA(Symbol(), 0, maPeriod3, maShift, maMethod, maApplyTo, 0);
    double ma4 = iMA(Symbol(), 0, maPeriod4, maShift, maMethod, maApplyTo, 0);

    // Entry conditions
    if (!positionOpen) {
        if (ma1 > ma2 && ma2 > ma3 && ma3 > ma4) {
            // Execute Buy
            OrderSend(Symbol(), OP_BUY, 0.01, Bid, 3, 0, 0, "Buy Order", 0, 0, Green);
            positionOpen = true;
        }

        if (ma4 > ma3 && ma3 > ma2 && ma2 > ma1) {
            // Execute Sell
            OrderSend(Symbol(), OP_SELL, 0.01, Ask, 3, 0, 0, "Sell Order", 0, 0, Red);
            positionOpen = true;
        }
    }

    // Exit conditions
    if (positionOpen) {
        if ((ma1 > ma3 && ma4 > ma2) || (ma3 > ma1 && ma2 > ma4)) {
            CloseAllPositions();
            positionOpen = false;
        }
    }
}

//+------------------------------------------------------------------+
//| Function to close all open positions                             |
//+------------------------------------------------------------------+
void CloseAllPositions()
{
    int get_out=0,hstTotal=OrdersHistoryTotal();
            if (hstTotal<1) get_out=1;
            while (get_out==0)
            {
               if(!OrderSelect(0,SELECT_BY_POS,MODE_TRADES)) get_out=1;
               else
               {
                  OrderClose(OrderTicket(),OrderLots(),Bid,3);
               }
               hstTotal=OrdersHistoryTotal();
               if (hstTotal<1) get_out=1;
            }
}
