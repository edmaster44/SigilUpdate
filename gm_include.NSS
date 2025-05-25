

// Gambling Include

// Amount of gold in the house at the start of the server.
int HOUSESTART=100000;
int MAXBET = 5000;

const float BEAST_ODDS = 1.75;
const string BEAR = "Bear";
const string WOLF = "Wolf";
const string DISPLACER_BEAST = "Displacer Beast";
const string NIGHTMARE = "Nightmare";
const string TIGER = "Tiger";
const string LION = "Lion";
const string SPIDER = "Spider";
const string DEINONYCHUS = "Deinonychus";
const int BEAR_NUM = 13;
const int WOLF_NUM = 175;
const int BEAST_NUM = 1508;
const int NIGHTMARE_NUM = 12;
const int TIGER_NUM = 2317;
const int LION_NUM = 2318;
const int SPIDER_NUM = 547;
const int DEINONYCHUS_NUM = 36;

object oMod=GetModule();

void SetHouse(int nAmt)
{
    SetLocalInt(oMod,"HOUSETOTAL",nAmt);
}

int GetHouse()
{
    return GetLocalInt(oMod,"HOUSETOTAL");
}

int CheckPayout(int nAmt)
{
    if( (GetHouse()-nAmt) < 0)
    {
        nAmt=GetHouse();
        SetHouse(0);
        return nAmt;
    }
    return nAmt;
}

void AddHouse(int nAmt)
{
    SetHouse((nAmt+GetHouse()));
}

void SubHouse(int nAmt)
{
    if((GetHouse()-nAmt) < 0)
        SetHouse(0);
    else
        SetHouse((GetHouse()-nAmt));
}