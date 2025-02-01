#include "ff_safevar"

//Modified by Stephen Spann (sspann@worldnet.att.net)
//to include the 00 slot, Five-Number bets, Corner Bets, and Split Bets.
//now uses SetListeningPattern() cues instead of a conversation.

///////////////////////////////////
//Made by: Charles Adams
//xezol@xezol.com
//////////////////////////////////
#include "gm_include"

int EndRouletteRound(object PC, int random)
{
object oPC = PC;
int nMoney = 0;
int ixBet = PS_GetLocalInt(oPC,"iBet");
int ixWinnings = PS_GetLocalInt(oPC,"iWinnings");
int ixFive = PS_GetLocalInt(oPC,"iFive");
int ixRed = PS_GetLocalInt(oPC,"iRed");
int ixBlack = PS_GetLocalInt(oPC,"iBlack");
int ixHigh = PS_GetLocalInt(oPC,"iHigh");
int ixLow = PS_GetLocalInt(oPC,"iLow");
int ixEven = PS_GetLocalInt(oPC,"iEven");
int ixOdd = PS_GetLocalInt(oPC,"iOdd");
int ixDoz1 = PS_GetLocalInt(oPC,"iDoz1");
int ixDoz2 = PS_GetLocalInt(oPC,"iDoz2");
int ixDoz3 = PS_GetLocalInt(oPC,"iDoz3");
int ixCol1 = PS_GetLocalInt(oPC,"iCol1");
int ixCol2 = PS_GetLocalInt(oPC,"iCol2");
int ixCol3 = PS_GetLocalInt(oPC,"iCol3");
int ix0su = PS_GetLocalInt(oPC,"i0su");
int ix00su = PS_GetLocalInt(oPC,"i0su");
int ix1su = PS_GetLocalInt(oPC,"i1su");
int ix2su = PS_GetLocalInt(oPC,"i2su");
int ix3su = PS_GetLocalInt(oPC,"i3su");
int ix4su = PS_GetLocalInt(oPC,"i4su");
int ix5su = PS_GetLocalInt(oPC,"i5su");
int ix6su = PS_GetLocalInt(oPC,"i6su");
int ix7su = PS_GetLocalInt(oPC,"i7su");
int ix8su = PS_GetLocalInt(oPC,"i8su");
int ix9su = PS_GetLocalInt(oPC,"i9su");
int ix10su = PS_GetLocalInt(oPC,"i10su");
int ix11su = PS_GetLocalInt(oPC,"i11su");
int ix12su = PS_GetLocalInt(oPC,"i12su");
int ix13su = PS_GetLocalInt(oPC,"i13su");
int ix14su = PS_GetLocalInt(oPC,"i14su");
int ix15su = PS_GetLocalInt(oPC,"i15su");
int ix16su = PS_GetLocalInt(oPC,"i16su");
int ix17su = PS_GetLocalInt(oPC,"i17su");
int ix18su = PS_GetLocalInt(oPC,"i18su");
int ix19su = PS_GetLocalInt(oPC,"i19su");
int ix20su = PS_GetLocalInt(oPC,"i20su");
int ix21su = PS_GetLocalInt(oPC,"i21su");
int ix22su = PS_GetLocalInt(oPC,"i22su");
int ix23su = PS_GetLocalInt(oPC,"i23su");
int ix24su = PS_GetLocalInt(oPC,"i24su");
int ix25su = PS_GetLocalInt(oPC,"i25su");
int ix26su = PS_GetLocalInt(oPC,"i26su");
int ix27su = PS_GetLocalInt(oPC,"i27su");
int ix28su = PS_GetLocalInt(oPC,"i28su");
int ix29su = PS_GetLocalInt(oPC,"i29su");
int ix30su = PS_GetLocalInt(oPC,"i30su");
int ix31su = PS_GetLocalInt(oPC,"i31su");
int ix32su = PS_GetLocalInt(oPC,"i32su");
int ix33su = PS_GetLocalInt(oPC,"i33su");
int ix34su = PS_GetLocalInt(oPC,"i34su");
int ix35su = PS_GetLocalInt(oPC,"i35su");
int ix36su = PS_GetLocalInt(oPC,"i36su");
int ixLine1 = PS_GetLocalInt(oPC,"iLine1");
int ixLine2 = PS_GetLocalInt(oPC,"iLine2");
int ixLine3 = PS_GetLocalInt(oPC,"iLine3");
int ixLine4 = PS_GetLocalInt(oPC,"iLine4");
int ixLine5 = PS_GetLocalInt(oPC,"iLine5");
int ixLine6 = PS_GetLocalInt(oPC,"iLine6");
int ixLine7 = PS_GetLocalInt(oPC,"iLine7");
int ixLine8 = PS_GetLocalInt(oPC,"iLine8");
int ixLine9 = PS_GetLocalInt(oPC,"iLine9");
int ixLine10 = PS_GetLocalInt(oPC,"iLine10");
int ixLine11 = PS_GetLocalInt(oPC,"iLine11");
int ixStreet1 = PS_GetLocalInt(oPC,"iStreet1");
int ixStreet2 = PS_GetLocalInt(oPC,"iStreet2");
int ixStreet3 = PS_GetLocalInt(oPC,"iStreet3");
int ixStreet4 = PS_GetLocalInt(oPC,"iStreet4");
int ixStreet5 = PS_GetLocalInt(oPC,"iStreet5");
int ixStreet6 = PS_GetLocalInt(oPC,"iStreet6");
int ixStreet7 = PS_GetLocalInt(oPC,"iStreet7");
int ixStreet8 = PS_GetLocalInt(oPC,"iStreet8");
int ixStreet9 = PS_GetLocalInt(oPC,"iStreet9");
int ixStreet10 = PS_GetLocalInt(oPC,"iStreet10");
int ixStreet11 = PS_GetLocalInt(oPC,"iStreet11");
int ixStreet12 = PS_GetLocalInt(oPC,"iStreet12");
int ixCorner1 = PS_GetLocalInt(oPC,"iCorner1");
int ixCorner2 = PS_GetLocalInt(oPC,"iCorner2");
int ixCorner3 = PS_GetLocalInt(oPC,"iCorner3");
int ixCorner4 = PS_GetLocalInt(oPC,"iCorner4");
int ixCorner5 = PS_GetLocalInt(oPC,"iCorner5");
int ixCorner6 = PS_GetLocalInt(oPC,"iCorner6");
int ixCorner7 = PS_GetLocalInt(oPC,"iCorner7");
int ixCorner8 = PS_GetLocalInt(oPC,"iCorner8");
int ixCorner9 = PS_GetLocalInt(oPC,"iCorner9");
int ixCorner10 = PS_GetLocalInt(oPC,"iCorner10");
int ixCorner11 = PS_GetLocalInt(oPC,"iCorner11");
int ixCorner12 = PS_GetLocalInt(oPC,"iCorner12");
int ixCorner13 = PS_GetLocalInt(oPC,"iCorner13");
int ixCorner14 = PS_GetLocalInt(oPC,"iCorner14");
int ixCorner15 = PS_GetLocalInt(oPC,"iCorner15");
int ixCorner16 = PS_GetLocalInt(oPC,"iCorner16");
int ixCorner17 = PS_GetLocalInt(oPC,"iCorner17");
int ixCorner18 = PS_GetLocalInt(oPC,"iCorner18");
int ixCorner19 = PS_GetLocalInt(oPC,"iCorner19");
int ixCorner20 = PS_GetLocalInt(oPC,"iCorner20");
int ixCorner21 = PS_GetLocalInt(oPC,"iCorner21");
int ixCorner22 = PS_GetLocalInt(oPC,"iCorner22");
int ixSplit1 = PS_GetLocalInt(oPC,"iSplit1");
int ixSplit2 = PS_GetLocalInt(oPC,"iSplit2");
int ixSplit3 = PS_GetLocalInt(oPC,"iSplit3");
int ixSplit4 = PS_GetLocalInt(oPC,"iSplit4");
int ixSplit5 = PS_GetLocalInt(oPC,"iSplit5");
int ixSplit6 = PS_GetLocalInt(oPC,"iSplit6");
int ixSplit7 = PS_GetLocalInt(oPC,"iSplit7");
int ixSplit8 = PS_GetLocalInt(oPC,"iSplit8");
int ixSplit9 = PS_GetLocalInt(oPC,"iSplit9");
int ixSplit10 = PS_GetLocalInt(oPC,"iSplit10");
int ixSplit11 = PS_GetLocalInt(oPC,"iSplit11");
int ixSplit12 = PS_GetLocalInt(oPC,"iSplit12");
int ixSplit13 = PS_GetLocalInt(oPC,"iSplit13");
int ixSplit14 = PS_GetLocalInt(oPC,"iSplit14");
int ixSplit15 = PS_GetLocalInt(oPC,"iSplit15");
int ixSplit16 = PS_GetLocalInt(oPC,"iSplit16");
int ixSplit17 = PS_GetLocalInt(oPC,"iSplit17");
int ixSplit18 = PS_GetLocalInt(oPC,"iSplit18");
int ixSplit19 = PS_GetLocalInt(oPC,"iSplit19");
int ixSplit20 = PS_GetLocalInt(oPC,"iSplit20");
int ixSplit21 = PS_GetLocalInt(oPC,"iSplit21");
int ixSplit22 = PS_GetLocalInt(oPC,"iSplit22");
int ixSplit23 = PS_GetLocalInt(oPC,"iSplit23");
int ixSplit24 = PS_GetLocalInt(oPC,"iSplit24");
int ixSplit25 = PS_GetLocalInt(oPC,"iSplit25");
int ixSplit26 = PS_GetLocalInt(oPC,"iSplit26");
int ixSplit27 = PS_GetLocalInt(oPC,"iSplit27");
int ixSplit28 = PS_GetLocalInt(oPC,"iSplit28");
int ixSplit29 = PS_GetLocalInt(oPC,"iSplit29");
int ixSplit30 = PS_GetLocalInt(oPC,"iSplit30");
int ixSplit31 = PS_GetLocalInt(oPC,"iSplit31");
int ixSplit32 = PS_GetLocalInt(oPC,"iSplit32");
int ixSplit33 = PS_GetLocalInt(oPC,"iSplit33");
int ixSplit34 = PS_GetLocalInt(oPC,"iSplit34");
int ixSplit35 = PS_GetLocalInt(oPC,"iSplit35");
int ixSplit36 = PS_GetLocalInt(oPC,"iSplit36");
int ixSplit37 = PS_GetLocalInt(oPC,"iSplit37");
int ixSplit38 = PS_GetLocalInt(oPC,"iSplit38");
int ixSplit39 = PS_GetLocalInt(oPC,"iSplit39");
int ixSplit40 = PS_GetLocalInt(oPC,"iSplit40");
int ixSplit41 = PS_GetLocalInt(oPC,"iSplit41");
int ixSplit42 = PS_GetLocalInt(oPC,"iSplit42");
int ixSplit43 = PS_GetLocalInt(oPC,"iSplit43");
int ixSplit44 = PS_GetLocalInt(oPC,"iSplit44");
int ixSplit45 = PS_GetLocalInt(oPC,"iSplit45");
int ixSplit46 = PS_GetLocalInt(oPC,"iSplit46");
int ixSplit47 = PS_GetLocalInt(oPC,"iSplit47");
int ixSplit48 = PS_GetLocalInt(oPC,"iSplit48");
int ixSplit49 = PS_GetLocalInt(oPC,"iSplit49");
int ixSplit50 = PS_GetLocalInt(oPC,"iSplit50");
int ixSplit51 = PS_GetLocalInt(oPC,"iSplit51");
int ixSplit52 = PS_GetLocalInt(oPC,"iSplit52");
int ixSplit53 = PS_GetLocalInt(oPC,"iSplit53");
int ixSplit54 = PS_GetLocalInt(oPC,"iSplit54");
int ixSplit55 = PS_GetLocalInt(oPC,"iSplit55");
int ixSplit56 = PS_GetLocalInt(oPC,"iSplit56");
int ixSplit57 = PS_GetLocalInt(oPC,"iSplit57");
int ixSplit58 = PS_GetLocalInt(oPC,"iSplit58");
int ixSplit59 = PS_GetLocalInt(oPC,"iSplit59");
int ixSplit60 = PS_GetLocalInt(oPC,"iSplit60");
int ixSplit61 = PS_GetLocalInt(oPC,"iSplit61");
int ixSplit62 = PS_GetLocalInt(oPC,"iSplit62");

string sxFive = PS_GetLocalString(OBJECT_SELF,"sFive");
sxFive = "";
PS_SetLocalString(OBJECT_SELF,"sFive","sxFive");

string sxSUHit = PS_GetLocalString(OBJECT_SELF,"sSUHit");
sxSUHit = "";
PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");

string sxRB = PS_GetLocalString(OBJECT_SELF,"sRB");
sxRB = "";
PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");

string sxHL = PS_GetLocalString(OBJECT_SELF,"sHL");
sxHL = "";
PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");

string sxEO = PS_GetLocalString(OBJECT_SELF,"sEO");
sxEO = "";
PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");

string sxDoz = PS_GetLocalString(OBJECT_SELF,"sDoz");
sxDoz = "";
PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");

string sxCol = PS_GetLocalString(OBJECT_SELF,"sCol");
sxCol = "";
PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");

string sxLine = PS_GetLocalString(OBJECT_SELF,"sLine");
sxLine = "";
PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");

string sxLine2 = PS_GetLocalString(OBJECT_SELF,"sLine2");
sxLine2 = "";
PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");

string sxStreet = PS_GetLocalString(OBJECT_SELF,"sStreet");
sxStreet = "";
PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");

string sxCorner = PS_GetLocalString(OBJECT_SELF,"sCorner");
sxCorner = "";
PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");

string sxCorner2 = PS_GetLocalString(OBJECT_SELF,"sCorner2");
sxCorner2 = "";
PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");

string sxCorner3 = PS_GetLocalString(OBJECT_SELF,"sCorner3");
sxCorner3 = "";
PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");

string sxCorner4 = PS_GetLocalString(OBJECT_SELF,"sCorner4");
sxCorner4 = "";
PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");

string sxSplit1 = PS_GetLocalString(OBJECT_SELF,"sSplit1");
sxSplit1 = "";
PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");

string sxSplit2 = PS_GetLocalString(OBJECT_SELF,"sSplit2");
sxSplit2 = "";
PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");

string sxSplit3 = PS_GetLocalString(OBJECT_SELF,"sSplit3");
sxSplit3 = "";
PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");

string sxSplit4 = PS_GetLocalString(OBJECT_SELF,"sSplit4");
sxSplit4 = "";
PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");

string sxSplit5 = PS_GetLocalString(OBJECT_SELF,"sSplit5");
sxSplit5 = "";
PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit5");


int ixSpot1 = PS_GetLocalInt(OBJECT_SELF,"iSpot1");
string sxSpot1Color = PS_GetLocalString(OBJECT_SELF,"sSpot1Color");


ixSpot1 = random;
PS_SetLocalInt(OBJECT_SELF,"iSpot1", ixSpot1);

switch(ixSpot1)
    {
    case 0:
    nMoney = nMoney + (ix0su*16) + (ixFive*7) + (ixSplit1*11) + (ixSplit2*11) + (ixSplit3*11);
    sxSpot1Color = "Green";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ix0su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix0su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixFive >= 1)
        {
        sxFive = "" + GetName(oPC) + "'s Five-Number bet of "+IntToString(ixFive)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sFive","sxFive");
        }
    if (ixSplit1 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit2 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit3 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 1:
    nMoney = nMoney + (ix1su*16) + (ixFive*7) + (ixRed*2) + (ixLow*2) + (ixOdd*2) + (ixCol1*3) + (ixDoz1*3) + (ixLine1*6) + (ixCorner1*9) + (ixStreet1*10) + (ixSplit2*11) + (ixSplit6*11) + (ixSplit7*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix1su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix1su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine1 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixStreet1 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixFive >= 1)
        {
        sxFive = "" + GetName(oPC) + "'s Five-Number bet of "+IntToString(ixFive)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sFive","sxFive");
        }
    if (ixCorner1 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixSplit2 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit6 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit7 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 2:
    nMoney = nMoney + (ix2su*16) + (ixFive*7) + (ixBlack*2) + (ixLow*2) + (ixEven*2) + (ixCol2*3) + (ixDoz1*3) + (ixLine1*6) + (ixCorner1*9) + (ixCorner2*9) + (ixStreet1*10) + (ixSplit3*11) + (ixSplit4*11) + (ixSplit6*11) + (ixSplit8*11) + (ixSplit9*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix2su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix2su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine1 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixStreet1 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixFive >= 1)
        {
        sxFive = "" + GetName(oPC) + "'s Five-Number bet of "+IntToString(ixFive)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sFive","sxFive");
        }
    if (ixCorner1 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner2 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit3 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit4 >= 1)
        {
        sxSplit5 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit5","sxSplit5");
        }
    if (ixSplit6 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit8 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit9 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 3:
    nMoney = nMoney + (ix3su*16) + (ixFive*7) + (ixRed*2) + (ixLow*2) + (ixOdd*2) + (ixCol3*3) + (ixDoz1*3) + (ixLine1*6) + (ixCorner2*9) + (ixStreet1*10) + (ixSplit5*11) + (ixSplit8*11) + (ixSplit10*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
	if (CheckPayout(ixRed*2)) {
    	GiveGoldToCreature(oPC,ixRed*2);
		SubHouse(ixRed*2);
	}
	else {
    	GiveGoldToCreature(oPC,ixRed*2);
		SubHouse(ixRed*2);
		SpeakString("" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet has broken the house! That's all for now, folks.");
		return FALSE;
	}
    if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(oPC,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix3su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix3su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine1 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixStreet1 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixFive >= 1)
        {
        sxFive = "" + GetName(oPC) + "'s Five-Number bet of "+IntToString(ixFive)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sFive","sxFive");
        }
    if (ixCorner2 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixSplit5 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit8 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit10 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 4:
    nMoney = nMoney + (ix4su*16) + (ixBlack*2) + (ixLow*2) + (ixEven*2) + (ixCol1*3) + (ixDoz1*3) + (ixLine1*6) + (ixLine2*6) + (ixCorner1*9) + (ixCorner3*9) + (ixStreet2*10) + (ixSplit7*11) + (ixSplit11*11) + (ixSplit12*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix4su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix4su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine1 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine2 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
    if (ixStreet2 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner1 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner3 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit7 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit11 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit12 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 5:
    nMoney = nMoney + (ix5su*16) + (ixRed*2) + (ixLow*2) + (ixOdd*2) + (ixCol2*3) + (ixDoz1*3) + (ixLine1*6) + (ixLine2*6) + (ixCorner1*9) + (ixCorner2*9) + (ixCorner3*9) + (ixCorner4*9)+ (ixStreet2*10) + (ixSplit9*11) + (ixSplit11*11) + (ixSplit13*11) + (ixSplit14*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix5su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix5su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine1 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine2 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
    if (ixStreet2 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner1 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner2 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner3 >= 1)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner4 >= 1)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit9 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit11 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit13 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit13)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit14 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit14)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 6:
    nMoney = nMoney + (ix6su*16) + (ixBlack*2) + (ixLow*2) + (ixEven*2) + (ixCol3*3) + (ixDoz1*3) + (ixLine1*6)+ (ixLine2*6) + (ixCorner2*9) + (ixCorner4*9)+ (ixStreet2*10) + (ixSplit9*11) + (ixSplit10*11) + (ixSplit13*11) + (ixSplit15*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix6su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix6su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine1 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine2 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
    if (ixStreet2 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner2 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner4 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit10 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit13 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit13)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit15 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit15)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 7:
    nMoney = nMoney + (ix7su*16) + (ixRed*2) + (ixLow*2) + (ixOdd*2) + (ixCol1*3) + (ixDoz1*3) + (ixLine2*6)+ (ixLine3*6) + (ixCorner3*9) + (ixCorner5*9)+ (ixStreet3*10) + (ixSplit12*11) + (ixSplit16*11) + (ixSplit17*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix7su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix7su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine2 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine3 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
    if (ixStreet3 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner3 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner5 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit12 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit16 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit16)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit17 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit17)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 8:
    nMoney = nMoney + (ix8su*16) + (ixBlack*2) + (ixLow*2) + (ixEven*2) + (ixCol2*3) + (ixDoz1*3) + (ixLine2*6)+ (ixLine3*6) + (ixCorner3*9) + (ixCorner4*9) + (ixCorner5*9) + (ixCorner6*9)+ (ixStreet3*10) + (ixSplit14*11) + (ixSplit16*11) + (ixSplit18*11) + (ixSplit19*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix8su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix8su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine2 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine3 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
    if (ixStreet3 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner3 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner4 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner5 >= 1)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner6 >= 1)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit14 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit14)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit16 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit16)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit18 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit18)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit19 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit19)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 9:
    nMoney = nMoney + (ix9su*16) + (ixRed*2) + (ixLow*2) + (ixOdd*2) + (ixCol3*3) + (ixDoz1*3) + (ixLine2*6)+ (ixLine3*6) + (ixCorner4*9) + (ixCorner6*9)+ (ixStreet3*10) + (ixSplit15*11) + (ixSplit18*11) + (ixSplit20*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix9su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix9su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine2 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine3 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
    if (ixStreet3 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner4 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner6 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit15 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit15)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit18 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit18)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit20 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit20)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 10:
    nMoney = nMoney + (ix10su*16) + (ixBlack*2) + (ixLow*2) + (ixEven*2) + (ixCol1*3) + (ixDoz1*3) + (ixLine3*6)+ (ixLine4*6) + (ixCorner5*9) + (ixCorner7*9)+ (ixStreet4*10) + (ixSplit17*11) + (ixSplit21*11) + (ixSplit22*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
    if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix10su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix10su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine3 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine4 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
    if (ixStreet4 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner5 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner7 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit17 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit17)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit21 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit21)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit22 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit22)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 11:
    nMoney = nMoney + (ix11su*16) + (ixBlack*2) + (ixLow*2) + (ixOdd*2) + (ixCol2*3) + (ixDoz1*3) + (ixLine3*6)+ (ixLine4*6) + (ixCorner5*9) + (ixCorner6*9) + (ixCorner7*9) + (ixCorner8*9)+ (ixStreet4*10) + (ixSplit19*11) + (ixSplit21*11) + (ixSplit23*11) + (ixSplit24*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
    if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
                    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix11su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix11su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine3 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine4 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet4 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner5 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner6 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner7 >= 1)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner8 >= 1)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit19 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit19)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit21 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit21)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit23 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit23)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit24 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit24)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 12:
    nMoney = nMoney + (ix12su*16) + (ixRed*2) + (ixLow*2) + (ixEven*2) + (ixCol3*3) + (ixDoz1*3) + (ixLine3*6)+ (ixLine4*6) + (ixCorner6*9) + (ixCorner8*9) + (ixStreet4*10) + (ixSplit20*11) + (ixSplit23*11) + (ixSplit25*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
                    if (ixDoz1 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix12su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix12su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine3 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine4 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet4 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner6 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner8 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit20 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit20)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit23 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit23)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit25 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit25)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 13:
    nMoney = nMoney + (ix13su*16) + (ixBlack*2) + (ixLow*2) + (ixOdd*2) + (ixCol1*3) + (ixDoz2*3) + (ixLine4*6)+ (ixLine5*6) + (ixCorner7*9) + (ixCorner9*9) + (ixStreet5*10) + (ixSplit22*11) + (ixSplit26*11) + (ixSplit27*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
                    if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix13su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix13su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine4 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine5 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet5 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner7 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner9 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit22 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit22)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit26 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit26)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit27 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit27)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 14:
    nMoney = nMoney + (ix14su*16) + (ixRed*2) + (ixLow*2) + (ixEven*2) + (ixCol2*3) + (ixDoz2*3) + (ixLine4*6)+ (ixLine5*6) + (ixCorner7*9) + (ixCorner8*9) + (ixCorner9*9) + (ixCorner10*9)+ (ixStreet5*10) + (ixSplit24*11) + (ixSplit26*11) + (ixSplit28*11) + (ixSplit29*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
                    if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix14su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix14su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine4 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine5 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet5 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner7 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner8 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner9 >= 1)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner10 >= 1)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit24 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit24)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit26 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit26)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit28 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit28)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit29 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit29)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 15:
    nMoney = nMoney + (ix15su*16) + (ixBlack*2) + (ixLow*2) + (ixOdd*2) + (ixCol3*3) + (ixDoz2*3) + (ixLine4*6)+ (ixLine5*6) + (ixCorner8*9) + (ixCorner10*9) + (ixStreet5*10) + (ixSplit25*11) + (ixSplit28*11) + (ixSplit30*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
                    if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix15su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix15su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine4 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine5 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet5 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner8 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner10 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit25 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit25)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit28 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit28)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit30 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit30)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 16:
    nMoney = nMoney + (ix16su*16) + (ixRed*2) + (ixLow*2) + (ixEven*2) + (ixCol1*3) + (ixDoz2*3) + (ixLine5*6)+ (ixLine6*6) + (ixCorner9*9) + (ixCorner11*9) + (ixStreet6*10) + (ixSplit27*11) + (ixSplit31*11) + (ixSplit32*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
                    if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix16su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix16su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine5 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine6 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet6 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner9 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner11 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit27 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit27)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit31 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit31)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit32 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit32)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 17:
    nMoney = nMoney + (ix17su*16) + (ixBlack*2) + (ixLow*2) + (ixOdd*2) + (ixCol2*3) + (ixDoz2*3) + (ixLine5*6)+ (ixLine6*6) + (ixCorner9*9) + (ixCorner10*9) + (ixCorner11*9) + (ixCorner12*9)+ (ixStreet6*10) + (ixSplit29*11) + (ixSplit31*11) + (ixSplit33*11) + (ixSplit34*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
                   if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix17su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix17su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine5 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine6 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet6 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner9 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner10 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner11 >= 1)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner12 >= 1)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit29 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit29)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit31 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit31)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit33 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit33)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit34 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit34)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 18:
    nMoney = nMoney + (ix18su*16) + (ixRed*2) + (ixLow*2) + (ixEven*2) + (ixCol3*3) + (ixDoz2*3) + (ixLine5*6)+ (ixLine6*6) + (ixCorner10*9) + (ixCorner12*9) + (ixStreet6*10) + (ixSplit30*11) + (ixSplit33*11) + (ixSplit35*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                if (ixLow >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s Low bet of "+IntToString(ixLow)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
               if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix18su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix18su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine5 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine6 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet6 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner10 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner12 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit30 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit30)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit33 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit33)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit35 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit35)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 19:
    nMoney = nMoney + (ix19su*16) + (ixRed*2) + (ixHigh*2) + (ixOdd*2) + (ixCol1*3) + (ixDoz2*3) + (ixLine6*6)+ (ixLine7*6) + (ixCorner11*9) + (ixCorner13*9) + (ixStreet7*10) + (ixSplit32*11) + (ixSplit36*11) + (ixSplit37*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
               if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix19su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix19su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine6 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine7 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet7 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner11 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner13 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner13)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit32 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit32)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit36 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit36)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit37 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit37)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 20:
    nMoney = nMoney + (ix20su*16) + (ixBlack*2) + (ixHigh*2) + (ixEven*2) + (ixCol2*3) + (ixDoz2*3) + (ixLine6*6)+ (ixLine7*6) + (ixCorner11*9) + (ixCorner12*9) + (ixCorner13*9) + (ixCorner14*9)+ (ixStreet7*10) + (ixSplit34*11) + (ixSplit36*11) + (ixSplit38*11) + (ixSplit39*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
               if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix20su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix20su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine6 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine7 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet7 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner1 >= 11)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner1 >= 12)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner1 >= 13)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner13)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner1 >= 14)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner14)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit34 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit34)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit36 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit36)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit38 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit38)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit39 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit39)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 21:
    nMoney = nMoney + (ix21su*16) + (ixRed*2) + (ixHigh*2) + (ixOdd*2) + (ixCol3*3) + (ixDoz2*3) + (ixLine6*6)+ (ixLine7*6) + (ixCorner12*9) + (ixCorner14*9)+ (ixStreet7*10) + (ixSplit35*11) + (ixSplit38*11) + (ixSplit40*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
               if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix21su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix21su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine6 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine6)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine7 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet7 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner12 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner14 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner14)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit35 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit35)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit38 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit38)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit40 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit40)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 22:
    nMoney = nMoney + (ix22su*16) + (ixBlack*2) + (ixHigh*2) + (ixEven*2) + (ixCol1*3) + (ixDoz2*3) + (ixLine7*6)+ (ixLine8*6) + (ixCorner13*9) + (ixCorner15*9) + (ixStreet8*10) + (ixSplit37*11) + (ixSplit41*11) + (ixSplit42*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
               if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix22su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix22su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine7 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine8 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet8 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner1 >= 13)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner13)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner1 >= 15)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner15)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit37 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit37)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit41 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit41)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit42 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit42)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 23:
    nMoney = nMoney + (ix23su*16) + (ixRed*2) + (ixHigh*2) + (ixOdd*2) + (ixCol2*3) + (ixDoz2*3) + (ixLine7*6)+ (ixLine8*6) + (ixCorner13*9) + (ixCorner14*9) + (ixCorner15*9) + (ixCorner16*9)+ (ixStreet8*10) + (ixSplit39*11) + (ixSplit41*11) + (ixSplit43*11) + (ixSplit44*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
               if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix23su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix23su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine7 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine8 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet8 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner1 >= 13)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner13)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner1 >= 14)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner14)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner1 >= 15)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner15)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner1 >= 16)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner16)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit39 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit39)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit41 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit41)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit43 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit43)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit44 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit44)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 24:
    nMoney = nMoney + (ix24su*16) + (ixBlack*2) + (ixHigh*2) + (ixEven*2) + (ixCol3*3) + (ixDoz2*3) + (ixLine7*6)+ (ixLine8*6) + (ixCorner14*9) + (ixCorner16*9) + (ixStreet8*10) + (ixSplit40*11) + (ixSplit43*11) + (ixSplit45*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
               if (ixDoz2 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix24su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix24su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine7 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine8 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet8 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner14 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner14)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner16 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner16)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit40 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit40)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit43 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit43)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit45 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit45)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 25:
    nMoney = nMoney + (ix25su*16) + (ixRed*2) + (ixHigh*2) + (ixOdd*2) + (ixCol1*3) + (ixDoz3*3) + (ixLine8*6)+ (ixLine9*6) + (ixCorner15*9) + (ixCorner17*9) + (ixStreet9*10) + (ixSplit42*11) + (ixSplit46*11) + (ixSplit47*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
               if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix25su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix25su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine8 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine9 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet9 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner15 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner15)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner17 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner17)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit42 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit42)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit46 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit46)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit47 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit47)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 26:
    nMoney = nMoney + (ix26su*16) + (ixBlack*2) + (ixHigh*2) + (ixEven*2) + (ixCol2*3) + (ixDoz3*3) + (ixLine8*6)+ (ixLine9*6) + (ixCorner15*9) + (ixCorner16*9) + (ixCorner17*9) + (ixCorner18*9)+ (ixStreet9*10) + (ixSplit44*11) + (ixSplit46*11) + (ixSplit48*11) + (ixSplit49*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix26su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix26su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine8 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine9 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet9 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner1 >= 15)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner15)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner1 >= 16)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner16)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner1 >= 17)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner17)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner1 >= 18)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner18)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit44 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit44)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit46 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit46)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit48 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit48)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit49 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit49)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 27:
    nMoney = nMoney + (ix27su*16) + (ixRed*2) + (ixHigh*2) + (ixOdd*2) + (ixCol3*3) + (ixDoz3*3) + (ixLine8*6)+ (ixLine9*6) + (ixCorner16*9) + (ixCorner18*9) + (ixStreet9*10) + (ixSplit45*11) + (ixSplit48*11) + (ixSplit50*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix27su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix27su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine8 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine8)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine9 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet9 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner16 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner16)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner18 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner18)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit45 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit45)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit48 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit48)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit50 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit50)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 28:
    nMoney = nMoney + (ix28su*16) + (ixBlack*2) + (ixHigh*2) + (ixEven*2) + (ixCol1*3) + (ixDoz3*3) + (ixLine9*6)+ (ixLine10*6) + (ixCorner17*9) + (ixCorner19*9) + (ixStreet10*10) + (ixSplit47*11) + (ixSplit51*11) + (ixSplit52*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix28su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix28su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine9 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine10 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet10 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner17 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner17)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner19 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner19)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit47 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit47)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit51 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit51)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit52 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit52)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 29:
    nMoney = nMoney + (ix29su*16) + (ixBlack*2) + (ixHigh*2) + (ixOdd*2) + (ixCol2*3) + (ixDoz3*3) + (ixLine9*6)+ (ixLine10*6) + (ixCorner17*9) + (ixCorner18*9) + (ixCorner19*9) + (ixCorner20*9)+ (ixStreet10*10) + (ixSplit49*11) + (ixSplit51*11) + (ixSplit53*11) + (ixSplit54*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix29su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix29su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine9 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine10 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet10 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner17 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner17)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner18 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner18)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner19 >= 1)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner19)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner20 >= 1)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner20)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit49 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit49)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit51 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit51)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit53 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit53)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit54 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit54)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 30:
    nMoney = nMoney + (ix30su*16) + (ixRed*2) + (ixHigh*2) + (ixEven*2) + (ixCol3*3) + (ixDoz3*3) + (ixLine9*6)+ (ixLine10*6) + (ixCorner18*9) + (ixCorner20*9) + (ixStreet10*10) + (ixSplit50*11) + (ixSplit53*11) + (ixSplit55*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix30su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix30su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine9 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine9)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine10 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet10 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner18 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner18)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner20 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner20)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit50 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit50)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit53 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit53)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit55 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit55)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 31:
    nMoney = nMoney + (ix31su*16) + (ixBlack*2) + (ixHigh*2) + (ixOdd*2) + (ixCol1*3) + (ixDoz3*3) + (ixLine10*6)+ (ixLine11*6) + (ixCorner19*9) + (ixCorner21*9) + (ixStreet11*10) + (ixSplit52*11) + (ixSplit56*11) + (ixSplit57*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix31su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix31su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine10 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine11 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet11 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner19 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner19)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner21 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner21)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit52 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit52)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit56 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit56)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit57 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit57)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 32:
    nMoney = nMoney + (ix32su*16) + (ixRed*2) + (ixHigh*2) + (ixEven*2) + (ixCol2*3) + (ixDoz3*3) + (ixLine10*6)+ (ixLine11*6) + (ixCorner19*9) + (ixCorner20*9) + (ixCorner21*9) + (ixCorner22*9)+ (ixStreet11*10) + (ixSplit54*11) + (ixSplit56*11) + (ixSplit58*11) + (ixSplit59*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix32su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix32su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine10 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine11 >= 1)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet11 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner19 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner19)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner20 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner20)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixCorner21 >= 1)
        {
        sxCorner3 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner21)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner3","sxCorner3");
        }
    if (ixCorner22 >= 1)
        {
        sxCorner4 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner22)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner4","sxCorner4");
        }
    if (ixSplit54 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit14)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit56 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit16)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit58 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit18)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit59 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit19)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;

    case 33:
    nMoney = nMoney + (ix33su*16) + (ixBlack*2) + (ixHigh*2) + (ixOdd*2) + (ixCol3*3) + (ixDoz3*3) + (ixLine10*6)+ (ixLine11*6) + (ixCorner20*9) + (ixCorner22*9)+ (ixStreet11*10) + (ixSplit55*11) + (ixSplit58*11) + (ixSplit60*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix33su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix33su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine1 >= 10)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine10)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
    if (ixLine1 >= 11)
        {
        sxLine2 = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine2","sxLine2");
        }
            if (ixStreet11 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner20 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner20)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner22 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner22)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit55 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit55)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit58 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit58)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit60 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit60)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    break;

    case 34:
    nMoney = nMoney + (ix34su*16) + (ixRed*2) + (ixHigh*2) + (ixEven*2) + (ixCol1*3) + (ixDoz3*3) + (ixLine11*6)+ (ixCorner21*9) + (ixStreet12*10) + (ixSplit57*11) + (ixSplit61*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol1 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix34su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix34su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine11 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
            if (ixStreet12 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner20 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner20)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixSplit57 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit7)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit61 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    break;

    case 35:
    nMoney = nMoney + (ix35su*16) + (ixBlack*2) + (ixHigh*2) + (ixOdd*2) + (ixCol2*3) + (ixDoz3*3) + (ixLine11*6)+ (ixCorner21*9) + (ixCorner22*9) + (ixStreet12*10) + (ixSplit59*11) + (ixSplit61*11) + (ixSplit62*11);
    sxSpot1Color = "Black";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
                if (ixBlack >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixBlack)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                    if (ixOdd >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Odd bet of "+IntToString(ixOdd)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
            if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol2 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol2)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix35su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix35su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine11 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
             if (ixStreet12 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner21 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner21)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixCorner22 >= 1)
        {
        sxCorner2 = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner22)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner2","sxCorner2");
        }
    if (ixSplit59 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit59)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    if (ixSplit61 >= 1)
        {
        sxSplit3 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit61)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit3","sxSplit3");
        }
    if (ixSplit62 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit62)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    break;

    case 36:
    nMoney = nMoney + (ix36su*16) + (ixRed*2) + (ixHigh*2) + (ixEven*2) + (ixCol3*3) + (ixDoz3*3) + (ixLine11*6)+ (ixCorner22*9) + (ixStreet12*10) + (ixSplit60*11) + (ixSplit62*11);
    sxSpot1Color = "Red";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
            if (ixRed >= 1)
        {
        sxRB = "" + GetName(oPC) + "'s "+(sxSpot1Color)+" bet of "+IntToString(ixRed)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sRB","sxRB");
        }
                    if (ixHigh >= 1)
        {
        sxHL = "" + GetName(oPC) + "'s High bet of "+IntToString(ixHigh)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sHL","sxHL");
        }
                        if (ixEven >= 1)
        {
        sxEO = "" + GetName(oPC) + "'s Even bet of "+IntToString(ixEven)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sEO","sxEO");
        }
           if (ixDoz3 >= 1)
        {
        sxDoz = "" + GetName(oPC) + "'s Dozen bet of "+IntToString(ixDoz3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sDoz","sxDoz");
        }
                if (ixCol3 >= 1)
        {
        sxCol = "" + GetName(oPC) + "'s Column bet of "+IntToString(ixCol3)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCol","sxCol");
        }
    if (ix36su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix36su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixLine11 >= 1)
        {
        sxLine = "" + GetName(oPC) + "'s Line bet of "+IntToString(ixLine11)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sLine","sxLine");
        }
            if (ixStreet12 >= 1)
        {
        sxStreet = "" + GetName(oPC) + "'s Street bet of "+IntToString(ixStreet12)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sStreet","sxStreet");
        }
    if (ixCorner22 >= 1)
        {
        sxCorner = "" + GetName(oPC) + "'s Corner bet of "+IntToString(ixCorner22)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sCorner","sxCorner");
        }
    if (ixSplit60 >= 1)
        {
        sxSplit1 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit60)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit1","sxSplit1");
        }
    if (ixSplit62 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit62)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    break;

    case 37:
    nMoney = nMoney + (ixFive*7) + (ix00su*16) + (ixSplit1*11) + (ixSplit4*11) + (ixSplit5*11);
    sxSpot1Color = "Green";
    PS_SetLocalString(OBJECT_SELF,"sSpot1Color","sxSpot1Color");
    if (ix00su >= 1)
        {
        sxSUHit = "" + GetName(oPC) + "'s Straight Up bet of "+IntToString(ix00su)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSUHit","sxSUHit");
        }
    if (ixFive >= 1)
        {
        sxFive = "" + GetName(oPC) + "'s Five-Number bet of "+IntToString(ixFive)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sFive","sxFive");
        }
    if (ixSplit1 >= 1)
        {
        sxSplit2 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit1)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit2","sxSplit2");
        }
    if (ixSplit4 >= 1)
        {
        sxSplit5 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit4)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit5","sxSplit5");
        }
    if (ixSplit5 >= 1)
        {
        sxSplit4 = "" + GetName(oPC) + "'s Split bet of "+IntToString(ixSplit5)+" has hit! ";
        PS_SetLocalString(OBJECT_SELF,"sSplit4","sxSplit4");
        }
    break;
    }
//remove old bets
PS_SetLocalInt(oPC,"iBet",0);
PS_SetLocalInt(oPC,"iFive",0);
PS_SetLocalInt(oPC,"iRed",0);
PS_SetLocalInt(oPC,"iBlack",0);
PS_SetLocalInt(oPC,"iHigh",0);
PS_SetLocalInt(oPC,"iLow",0);
PS_SetLocalInt(oPC,"iEven",0);
PS_SetLocalInt(oPC,"iOdd",0);
PS_SetLocalInt(oPC,"iDoz1",0);
PS_SetLocalInt(oPC,"iDoz2",0);
PS_SetLocalInt(oPC,"iDoz3",0);
PS_SetLocalInt(oPC,"iCol1",0);
PS_SetLocalInt(oPC,"iCol2",0);
PS_SetLocalInt(oPC,"iCol3",0);
PS_SetLocalInt(oPC,"i0su",0);
PS_SetLocalInt(oPC,"i00su",0);
PS_SetLocalInt(oPC,"i1su",0);
PS_SetLocalInt(oPC,"i2su",0);
PS_SetLocalInt(oPC,"i3su",0);
PS_SetLocalInt(oPC,"i4su",0);
PS_SetLocalInt(oPC,"i5su",0);
PS_SetLocalInt(oPC,"i6su",0);
PS_SetLocalInt(oPC,"i7su",0);
PS_SetLocalInt(oPC,"i8su",0);
PS_SetLocalInt(oPC,"i9su",0);
PS_SetLocalInt(oPC,"i10su",0);
PS_SetLocalInt(oPC,"i11su",0);
PS_SetLocalInt(oPC,"i12su",0);
PS_SetLocalInt(oPC,"i13su",0);
PS_SetLocalInt(oPC,"i14su",0);
PS_SetLocalInt(oPC,"i15su",0);
PS_SetLocalInt(oPC,"i16su",0);
PS_SetLocalInt(oPC,"i17su",0);
PS_SetLocalInt(oPC,"i18su",0);
PS_SetLocalInt(oPC,"i19su",0);
PS_SetLocalInt(oPC,"i20su",0);
PS_SetLocalInt(oPC,"i21su",0);
PS_SetLocalInt(oPC,"i22su",0);
PS_SetLocalInt(oPC,"i23su",0);
PS_SetLocalInt(oPC,"i24su",0);
PS_SetLocalInt(oPC,"i25su",0);
PS_SetLocalInt(oPC,"i26su",0);
PS_SetLocalInt(oPC,"i27su",0);
PS_SetLocalInt(oPC,"i28su",0);
PS_SetLocalInt(oPC,"i29su",0);
PS_SetLocalInt(oPC,"i30su",0);
PS_SetLocalInt(oPC,"i31su",0);
PS_SetLocalInt(oPC,"i32su",0);
PS_SetLocalInt(oPC,"i33su",0);
PS_SetLocalInt(oPC,"i34su",0);
PS_SetLocalInt(oPC,"i35su",0);
PS_SetLocalInt(oPC,"i36su",0);
PS_SetLocalInt(oPC,"iLine1",0);
PS_SetLocalInt(oPC,"iLine2",0);
PS_SetLocalInt(oPC,"iLine3",0);
PS_SetLocalInt(oPC,"iLine4",0);
PS_SetLocalInt(oPC,"iLine5",0);
PS_SetLocalInt(oPC,"iLine6",0);
PS_SetLocalInt(oPC,"iLine7",0);
PS_SetLocalInt(oPC,"iLine8",0);
PS_SetLocalInt(oPC,"iLine9",0);
PS_SetLocalInt(oPC,"iLine10",0);
PS_SetLocalInt(oPC,"iLine11",0);
PS_SetLocalInt(oPC,"iStreet1",0);
PS_SetLocalInt(oPC,"iStreet2",0);
PS_SetLocalInt(oPC,"iStreet3",0);
PS_SetLocalInt(oPC,"iStreet4",0);
PS_SetLocalInt(oPC,"iStreet5",0);
PS_SetLocalInt(oPC,"iStreet6",0);
PS_SetLocalInt(oPC,"iStreet7",0);
PS_SetLocalInt(oPC,"iStreet8",0);
PS_SetLocalInt(oPC,"iStreet9",0);
PS_SetLocalInt(oPC,"iStreet10",0);
PS_SetLocalInt(oPC,"iStreet11",0);
PS_SetLocalInt(oPC,"iStreet12",0);
PS_SetLocalInt(oPC,"iCorner1",0);
PS_SetLocalInt(oPC,"iCorner2",0);
PS_SetLocalInt(oPC,"iCorner3",0);
PS_SetLocalInt(oPC,"iCorner4",0);
PS_SetLocalInt(oPC,"iCorner5",0);
PS_SetLocalInt(oPC,"iCorner6",0);
PS_SetLocalInt(oPC,"iCorner7",0);
PS_SetLocalInt(oPC,"iCorner8",0);
PS_SetLocalInt(oPC,"iCorner9",0);
PS_SetLocalInt(oPC,"iCorner10",0);
PS_SetLocalInt(oPC,"iCorner11",0);
PS_SetLocalInt(oPC,"iCorner12",0);
PS_SetLocalInt(oPC,"iCorner13",0);
PS_SetLocalInt(oPC,"iCorner14",0);
PS_SetLocalInt(oPC,"iCorner15",0);
PS_SetLocalInt(oPC,"iCorner16",0);
PS_SetLocalInt(oPC,"iCorner17",0);
PS_SetLocalInt(oPC,"iCorner18",0);
PS_SetLocalInt(oPC,"iCorner19",0);
PS_SetLocalInt(oPC,"iCorner20",0);
PS_SetLocalInt(oPC,"iCorner21",0);
PS_SetLocalInt(oPC,"iCorner22",0);
PS_SetLocalInt(oPC,"iSplit1",0);
PS_SetLocalInt(oPC,"iSplit2",0);
PS_SetLocalInt(oPC,"iSplit3",0);
PS_SetLocalInt(oPC,"iSplit4",0);
PS_SetLocalInt(oPC,"iSplit5",0);
PS_SetLocalInt(oPC,"iSplit6",0);
PS_SetLocalInt(oPC,"iSplit7",0);
PS_SetLocalInt(oPC,"iSplit8",0);
PS_SetLocalInt(oPC,"iSplit9",0);
PS_SetLocalInt(oPC,"iSplit10",0);
PS_SetLocalInt(oPC,"iSplit11",0);
PS_SetLocalInt(oPC,"iSplit12",0);
PS_SetLocalInt(oPC,"iSplit13",0);
PS_SetLocalInt(oPC,"iSplit14",0);
PS_SetLocalInt(oPC,"iSplit15",0);
PS_SetLocalInt(oPC,"iSplit16",0);
PS_SetLocalInt(oPC,"iSplit17",0);
PS_SetLocalInt(oPC,"iSplit18",0);
PS_SetLocalInt(oPC,"iSplit19",0);
PS_SetLocalInt(oPC,"iSplit20",0);
PS_SetLocalInt(oPC,"iSplit21",0);
PS_SetLocalInt(oPC,"iSplit22",0);
PS_SetLocalInt(oPC,"iSplit23",0);
PS_SetLocalInt(oPC,"iSplit24",0);
PS_SetLocalInt(oPC,"iSplit25",0);
PS_SetLocalInt(oPC,"iSplit26",0);
PS_SetLocalInt(oPC,"iSplit27",0);
PS_SetLocalInt(oPC,"iSplit28",0);
PS_SetLocalInt(oPC,"iSplit29",0);
PS_SetLocalInt(oPC,"iSplit30",0);
PS_SetLocalInt(oPC,"iSplit31",0);
PS_SetLocalInt(oPC,"iSplit32",0);
PS_SetLocalInt(oPC,"iSplit33",0);
PS_SetLocalInt(oPC,"iSplit34",0);
PS_SetLocalInt(oPC,"iSplit35",0);
PS_SetLocalInt(oPC,"iSplit36",0);
PS_SetLocalInt(oPC,"iSplit37",0);
PS_SetLocalInt(oPC,"iSplit38",0);
PS_SetLocalInt(oPC,"iSplit39",0);
PS_SetLocalInt(oPC,"iSplit40",0);
PS_SetLocalInt(oPC,"iSplit41",0);
PS_SetLocalInt(oPC,"iSplit42",0);
PS_SetLocalInt(oPC,"iSplit43",0);
PS_SetLocalInt(oPC,"iSplit44",0);
PS_SetLocalInt(oPC,"iSplit45",0);
PS_SetLocalInt(oPC,"iSplit46",0);
PS_SetLocalInt(oPC,"iSplit47",0);
PS_SetLocalInt(oPC,"iSplit48",0);
PS_SetLocalInt(oPC,"iSplit49",0);
PS_SetLocalInt(oPC,"iSplit50",0);
PS_SetLocalInt(oPC,"iSplit51",0);
PS_SetLocalInt(oPC,"iSplit52",0);
PS_SetLocalInt(oPC,"iSplit53",0);
PS_SetLocalInt(oPC,"iSplit54",0);
PS_SetLocalInt(oPC,"iSplit55",0);
PS_SetLocalInt(oPC,"iSplit56",0);
PS_SetLocalInt(oPC,"iSplit57",0);
PS_SetLocalInt(oPC,"iSplit58",0);
PS_SetLocalInt(oPC,"iSplit59",0);
PS_SetLocalInt(oPC,"iSplit60",0);
PS_SetLocalInt(oPC,"iSplit61",0);
PS_SetLocalInt(oPC,"iSplit62",0);
if (oPC == GetObjectByTag("roulettedealer"))
    {
    if (ixSpot1==37)
        {
        AssignCommand(GetObjectByTag("roulettedealer"),SpeakString("The winning spot is Green 00."));
        }
    else
        {
        AssignCommand(GetObjectByTag("roulettedealer"),SpeakString("The winning spot is "+sxSpot1Color+" "+IntToString(ixSpot1)+"."));
        }
    }
else
    {
    string sResult = ""+sxRB+""+sxHL+""+sxEO+""+sxDoz+""+sxCol+""+sxLine+""+sxLine2+""+sxFive+""+sxCorner+""+sxCorner2+""+sxCorner3+""+sxCorner4+""+sxStreet+""+sxSUHit+""+sxSplit1+""+sxSplit2+""+sxSplit3+""+sxSplit4+""+sxSplit5+"";
	GiveGoldToCreature(oPC,nMoney);
	PS_SetLocalInt(oPC, "GAMBLE_WON", PS_GetLocalInt(oPC, "GAMBLE_WON")+nMoney);
    string sMoney = ""+IntToString(nMoney)+"";
    if (sResult != "")
        {
        AssignCommand(GetObjectByTag("roulettedealer"),ActionDoCommand(SpeakString(""+sResult+""+GetName(oPC)+" wins "+sMoney+" gold!")));
        }
    }
PS_DeleteLocalInt(OBJECT_SELF,"nMoney");
return TRUE;
}