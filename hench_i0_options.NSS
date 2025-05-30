

/*

     Companion and Monster AI

    This file is used for global options for AI.

*/


// void main() {    }


// sets one of the  HENCH_OPTION_* settings on or off
void SetHenchOption(int nCondition, int bValid);

// gets one of the  HENCH_OPTION_* settings
int GetHenchOption(int nSel);



// how frequently shouts are done by monsters to call in allies to help
// DM clients can get flooded with these messages in which case the
// number can be increased to reduce the frequency.
const int HENCH_MONSTER_SHOUT_FREQUENCY = 5;


// This flag turns off when set to true monsters hearing other monsters and
// attacking them
const int HENCH_MONSTER_DONT_CHECK_HEARD_MONSTER = TRUE;

// general options
const int HENCH_GENAI_ENABLERAISE   = 0x0004;       // will use raise dead and resurrection


// monster options
const int HENCH_OPTION_STEALTH = 0x0001;      // monsters use stealth
const int HENCH_OPTION_WANDER  = 0x0002;      // monsters can wander
const int HENCH_OPTION_UNLOCK  = 0x0004;      // monsters can unlock or bash locked doors
const int HENCH_OPTION_OPEN    = 0x0008;      // monsters can open doors
const int HENCH_OPTION_KNOCKDOWN_DISABLED	= 0x0010; // everyone - disable use of knockdown
const int HENCH_OPTION_KNOCKDOWN_SOMETIMES	= 0x0020; // everyone - tone down use of knockdown
const int HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET    = 0x00040;      // disable auto set of companion behaviors
const int HENCH_OPTION_ENABLE_AUTO_BUFF        		= 0x00080;      // non members of PC party automatically use long duration buffs at start of combat
const int HENCH_OPTION_ENABLE_ITEM_CREATION         = 0x00100;      // non members of PC party get healing potions, etc. at start of combat
const int HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE     = 0x00200;      // non members of PC party are able to use equipped items (run at start of combat)
const int HENCH_OPTION_ENABLE_INVENTORY_DISTRURBED  = 0x00400;      // monsters react to disturb events (pickpocket)
const int HENCH_OPTION_HIDEOUS_BLOW_INSTANT			= 0x00800;      // warlock hideous blow is cast instant (one round to attack instead of two)
const int HENCH_OPTION_MONSTER_ALLY_DAMAGE			= 0x01000;      // monsters damage allies based on alignment
const int HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF      = 0x02000;      // non members of PC party automatically use medium duration buffs at start of combat, long duration must already be set up
const int HENCH_OPTION_DISABLE_HB_HEARING     		= 0x04000;      // turn off heartbeat hearing for monsters and associates
const int HENCH_OPTION_DISABLE_HB_DETECTION    		= 0x08000;      // turn off heartbeat detection of enemies for monsters and associates
const int HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH 		= 0x10000;      // in puppet mode, pause and switch to companions

//const int HENCH_MONAI_DISTRIB = 0x0010;      // monsters distribute themselves when attacking
//const int HENCH_MONAI_COMP    = 0x0080;      // monsters summon familiars and animal companions

const int HENCH_OPTION_SET_ONCE      = 0x40000000;      // global options set once, 0x80000000 can't be used with campaign integers

const string HenchGlobalOptionsStr = "HENCH_GLOBAL_OPTIONS";

const string HENCH_CAMPAIGN_DB = "compaisettings";


void SetHenchOption(int nCondition, int bValid)
{
    int nPlot = GetGlobalInt(HenchGlobalOptionsStr);
    if(bValid)
    {
        nPlot = nPlot | nCondition;
    }
    else
    {
        nPlot = nPlot & ~nCondition;
    }
    SetGlobalInt(HenchGlobalOptionsStr, nPlot);
}


int GetHenchOption(int nSel)
{
	int nResult = GetGlobalInt(HenchGlobalOptionsStr);
	if (!nResult)
	{
		nResult = GetCampaignInt(HENCH_CAMPAIGN_DB, HenchGlobalOptionsStr);
		nResult |= HENCH_OPTION_SET_ONCE;
    	SetGlobalInt(HenchGlobalOptionsStr, nResult);
	}
	return nResult & nSel;
}


const float fHenchHearingDistance = 5.0;
const float fHenchMasterHearingDistance = 100.0;


// prevent heartbeat detection of enemies
int GetUseHeartbeatDetect()
{
	return !(GetPlotFlag(OBJECT_SELF) || IsInMultiplayerConversation(GetFirstPC()));
}