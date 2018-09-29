//Description: Underwater Heartbeat, goes in every underwater area in the OnEnter event.
//Author: TroveLord
#include "i0_underwater"
void main()
{
    DoUnderwaterCheck(GetEnteringObject());
}