
//
// Define tint mask values used to avoid accumulating conversion error for
// fields that aren't being modified.  Used because the game internally stores
// the tint colors as floats (range 0.0f - 1.0f) but these are actually 8-bit
// integral values.
//

const int PS_CCA_TINT_COLOR0_R = 0x00000001;
const int PS_CCA_TINT_COLOR0_G = 0x00000002;
const int PS_CCA_TINT_COLOR0_B = 0x00000004;
const int PS_CCA_TINT_COLOR0_A = 0x00000008;
const int PS_CCA_TINT_COLOR0   = 0x0000000F;
const int PS_CCA_TINT_COLOR1_R = 0x00000010;
const int PS_CCA_TINT_COLOR1_G = 0x00000020;
const int PS_CCA_TINT_COLOR1_B = 0x00000040;
const int PS_CCA_TINT_COLOR1_A = 0x00000080;
const int PS_CCA_TINT_COLOR1   = 0x000000F0;
const int PS_CCA_TINT_COLOR2_R = 0x00000100;
const int PS_CCA_TINT_COLOR2_G = 0x00000200;
const int PS_CCA_TINT_COLOR2_B = 0x00000400;
const int PS_CCA_TINT_COLOR2_A = 0x00000800;
const int PS_CCA_TINT_COLOR2   = 0x00000F00;
const int PS_CCA_TINT_ALL      = 0x00000FFF;


//
// Define structure to encapsulate a tint set.  Each integer is a packed RGBA
// value in the form 0xRRGGBBAA.  The low 8 bits contain the alpha channel,
// the next 8 bits the blue channel, the next 8 bits the green channel, and
// the high 8 bits the red channel.  Each tint set contains three different
// tint color (RGBA) values.
//

struct TintSet
{
	int Color0;              // 32-bit value
	int Color1;              // 32-bit value
	int Color2;              // 32-bit value
	int Mask;                // Mask of values to set (out only)
};

//
// Define structure to encapsulate core appearance values for a creature, less
// those that are derived from equipped items.
//

struct CreatureCoreAppearance
{
	int AppearanceType;      // 16-bit value
	int Gender;              // 8-bit value
	int SkinColor;           // 8-bit value
	int TattooColor1;        // 8-bit value
	int TattooColor2;        // 8-bit value
	int HeadVariation;       // 8-bit value
	int TailVariation;       // 8-bit value
	int WingVariation;       // 8-bit value
	int HairVariation;       // 8-bit value
	int FacialHairVariation; // 8-bit value

	//
	// A struct TintSet but NWScript support for nested structures is broken.
	//

	int Tint_Color0;         // 32-bit value
	int Tint_Color1;         // 32-bit value
	int Tint_Color2;         // 32-bit value
	int Tint_Mask;           // Mask of color values to set only.

	int HeadTint_Color0;     // 32-bit value
	int HeadTint_Color1;     // 32-bit value
	int HeadTint_Color2;     // 32-bit value
	int HeadTint_Mask;       // Mask of color values to set only.

	int HairTint_Color0;     // 32-bit value
	int HairTint_Color1;     // 32-bit value
	int HairTint_Color2;     // 32-bit value
	int HairTint_Mask;       // Mask of color values to set only.

	int NeverDrawHelmet;     // 32-bit value (boolean)
};

//
// Merge stacks in a given container.
//
// Container:  The container to merge identical stacks in.
//

void PS_MergeContainerStacks(object Container);

//
// Call the weather system to send weather data to a player joining an area.
//

void PS_SendAreaWeatherToPlayer(object Area, object Player);

//
// Turn off weather for an area until it is manually enabled again.
//

void PS_DisableAreaWeather(object Area);

//
// Turn on weather for an area that was disabled with PS_DisableAreaWeather.
//

void PS_EnableAreaWeather(object Area);

//
// Dissipate the current weather in the area (but allow weather to be enabled
// randomly in the future).
//

void PS_ClearAreaWeather(object Area);

//
// Force new weather to be generated for the area.  Weather must be enabled.
//

void PS_GenerateAreaWeather(object Area);

//
// Get the weather system ID of an area.  Returns PS_INVALID_WEATHER_ID if the
// area has no weather system.  All areas with the same weather system ID share
// linked weather patterns.  A weather system ID is assigned once during area
// setup and persists throughout the lifetime of the module.
//

int PS_GetAreaWeatherSystemId(object Area);

//
// Get core appearance information for a creature.
//

struct CreatureCoreAppearance PS_GetCreatureCoreAppearance(object Creature);

//
// Set core appearance information for a creature.  Note that the appearance
// must be forced to be refreshed on clients in the area (i.e., by sending the
// creature to limbo for a game object update interval and recalling it, or
// by swapping an equipped item for a game object update interval and swapping
// back) for the update to be made visible.
//

void PS_SetCreatureCoreAppearance(object Creature, struct CreatureCoreAppearance CoreAppearance);

//
// Get object appearance SEF.  The returned SEF filename has no .sef extension.
// Only creatures and items are supported.
//

string PS_GetObjectAppearanceSEF(object ObjectId);

//
// Set object appearance SEF.  Items must be have an appearance refresh forced
// forced (e.g. via un-acquire, acquire, or area transition, etc.).  Each
// object may have only one primary appearance SEF.  The value set is saved
// when the object is serialized to GFF (i.e. for character saves, etc.).
//

void PS_SetObjectAppearanceSEF(object ObjectId, string AppearanceSEF);

//
// Compute the walkmesh height at a given location.  0.0f is returned if there
// was no valid walkmesh height for the given point.
//

float PS_ComputeHeight(object AreaObjectId, float x, float y);

//
// Calculate a path between a From and To point and return the array of path
// segment waypoints that represent straight-line edges along the ideal path.
//
// Future dynamic obstructions may modify the actual path that an object might
// take.
//
// If a nonzero value is returned, a path exists between the two points, and
// the count of waypoints in the path segment array is returned.  In this case,
// PS_GetPathWaypoint() can be called successively to retrieve each individual
// path waypoint.  PS_CalcPath calls aren't allowed to nest on the same area
// object and path segments are only made available on the area object until
// they are retrieved once.
//
// If the From position is occupied by an object with collision enabled, then
// the pathing request will always fail.  Use PS_CalcPathFromCreature to
// compute a path from where a creature stands to a target point if a creature
// relative path is desired.
//

int PS_CalcPath(object AreaObjectId, vector From, vector To);

//
// Calculate a path from a creature object to a given point.  Operates the same
// as PS_CalcPath in other respects.  The creature is not actually ordered to
// move, only the calculated path is generated and returned.
//

int PS_CalcPathFromCreature(object AreaObjectId, object FromCreature, vector To);

//
// Get a pathing waypoint along a previously computed path returned by
// PS_CalcPath or PS_CalcPathFromCreature.  Each waypoint is removed from the
// internal enumeration list as it is returned.
//
// If ComputeHeight is false (faster), the .z component of the returned vector
// is set to zero and not the actual walkmesh height at a given path waypoint.
//

vector PS_GetPathWaypoint(object AreaObjectId, int WaypointIndex, int ComputeHeight = FALSE);

//
// Determine whether a straight-line path exists between two points in a given
// area.
//

int PS_StraightPathExists(object AreaObjectId, vector From, vector To);

//
// Set the racial type of a creature.  No recalculation of legality of subrace
// or other values is performed; the new racial type is taken "as-is".
//

void PS_SetRacialType(object CreatureObjectId, int RacialType);

//
// Event handler to managed code for player entering world.
//

void PS_OnPCLoaded(object PCObjectId);

//
// Set the racial subtype (integer) value of a creature.  No recalculation of
// subrace or other values is performed; the new racial subtype is taken
// "as-is".
//

void PS_SetSubRacialType(object CreatureObject, int SubRacialType);

//
// Event handler to managed code for player leaving world.
//

void PS_OnPCLeave(object PCObjectId);

//
// Get count of seconds since 1970.
//

int PS_GetTime();

//
// Get count of milliseconds since operating system boot (wraps every 49.7 days).
//

int PS_GetTick();


//
// Unmarshal a float from script variables.

float PS_UnmarshalFloat(object ObjectId, string Name);

//
// Unmarshal an int from script variables.

int PS_UnmarshalInt(object ObjectId, string Name);

//
// Unmarshal a string from script variables.
//

string PS_UnmarshalString(object ObjectId, string Name);

//
// Unpack an AppearanceColor from script variables.

int PS_ScriptVariablesToAppearanceColor(object ObjectId, string Prefix);

//
// Pack an AppearanceColor into script variables.
//

void PS_AppearanceColorToScriptVariables(object ObjectId, string Prefix, int Color);

//
// Unpack a TintSet from script variables.
//

struct TintSet PS_ScriptVariablesToTintSet(object ObjectId, string Prefix);

//
// Pack a TintSet into script variables.
//

void PS_TintSetToScriptVariables (object ObjectId, string Prefix, struct TintSet Tint);

//
// Unpack a CreatureCoreAppearance from script variables.
//

struct CreatureCoreAppearance PS_ScriptVariablesToCreatureCoreAppearance(object ObjectId, string Prefix);

//
// Pack a CreatureCoreAppearance into script variables.
//

void PS_CreatureCoreAppearanceToScriptVariables(object ObjectId, string Prefix, struct CreatureCoreAppearance CoreAppearance);


//
// Low level wrapper to call the extensions script.
//
// Cmd: The entry reason for the script (PS_Ext_*).
//
// Remaining arguments are specific to Cmd.
//

int PS_CallExtensionsScript(int Cmd, object Self, object P0 = OBJECT_INVALID, int P1 = 0, int P2 = 0, string P3 = "", string P4 = "");


//
// These correspond to Sigil.Extensions.Entrypoint.EntryReason.
//
// The values must match.
//

const int PS_Ext_Initialize = 0;
const int PS_Ext_MergeContainerStacks = 1;
const int PS_Ext_SendAreaWeatherToPlayer = 2;
const int PS_Ext_DisableAreaWeather = 3;
const int PS_Ext_EnableAreaWeather = 4;
const int PS_Ext_ClearAreaWeather = 5;
const int PS_Ext_GenerateAreaWeather = 6;
const int PS_Ext_ActivateCounterSpell = 7;
const int PS_Ext_GetCreatureCoreAppearance = 8;
const int PS_Ext_SetCreatureCoreAppearance = 9;
const int PS_Ext_GetObjectAppearanceSEF = 10;
const int PS_Ext_SetObjectAppearanceSEF = 11;
const int PS_Ext_ComputeHeight = 12;
const int PS_Ext_CalcPath = 13;
const int PS_Ext_StraightPathExists = 14;
const int PS_Ext_SetRacialType = 15;
const int PS_Ext_OnPCLoaded = 16;
const int PS_Ext_SetSubRacialType = 17;
const int PS_Ext_OnPCLeave = 18;
const int PS_Ext_GetTime = 19;
const int PS_Ext_GetTick = 20;


const int PS_INVALID_WEATHER_ID = 0;


void PS_MergeContainerStacks(object Container)
{
	PS_CallExtensionsScript(PS_Ext_MergeContainerStacks, Container);
}

void PS_SendAreaWeatherToPlayer(object Area, object Player)
{
	PS_CallExtensionsScript(PS_Ext_SendAreaWeatherToPlayer, Area, Player);
}

void PS_DisableAreaWeather(object Area)
{
	PS_CallExtensionsScript(PS_Ext_DisableAreaWeather, Area);
}

void PS_EnableAreaWeather(object Area)
{
	PS_CallExtensionsScript(PS_Ext_EnableAreaWeather, Area);
}

void PS_ClearAreaWeather(object Area)
{
	PS_CallExtensionsScript(PS_Ext_ClearAreaWeather, Area);
}

void PS_GenerateAreaWeather(object Area)
{
	PS_CallExtensionsScript(PS_Ext_GenerateAreaWeather, Area);
}

void PS_ActivateCounterSpell(object TargetObject)
{
	PS_CallExtensionsScript(PS_Ext_ActivateCounterSpell, OBJECT_SELF, TargetObject);
}

int PS_GetAreaWeatherSystemId(object Area)
{
	return GetLocalInt(Area, "PS_WEATHER_ID");
}

struct CreatureCoreAppearance PS_GetCreatureCoreAppearance(object Creature)
{
	PS_CallExtensionsScript(PS_Ext_GetCreatureCoreAppearance, Creature);
	return PS_ScriptVariablesToCreatureCoreAppearance(Creature, "MarshalCoreAppearance");
}

void PS_SetCreatureCoreAppearance(object Creature, struct CreatureCoreAppearance CoreAppearance)
{
	PS_CreatureCoreAppearanceToScriptVariables(Creature, "MarshalCoreAppearance", CoreAppearance);
	PS_CallExtensionsScript(PS_Ext_SetCreatureCoreAppearance, Creature);
}

string PS_GetObjectAppearanceSEF(object ObjectId)
{
	PS_CallExtensionsScript(PS_Ext_GetObjectAppearanceSEF, ObjectId);
	return PS_UnmarshalString(ObjectId, "MarshalAppearanceSEF");
}

void PS_SetObjectAppearanceSEF(object ObjectId, string AppearanceSEF)
{
	SetLocalString(ObjectId, "MarshalAppearanceSEF", AppearanceSEF);
	PS_CallExtensionsScript(PS_Ext_SetObjectAppearanceSEF, ObjectId);
}

float PS_ComputeHeight(object AreaObjectId, float x, float y)
{
	SetLocalFloat(AreaObjectId, "MarshalX", x);
	SetLocalFloat(AreaObjectId, "MarshalY", y);
	PS_CallExtensionsScript(PS_Ext_ComputeHeight, AreaObjectId);
	return PS_UnmarshalFloat(AreaObjectId, "MarshalHeight");
}

int PS_CalcPath(object AreaObjectId, vector From, vector To)
{
	SetLocalFloat(AreaObjectId, "MarshalFrom.x", From.x);
	SetLocalFloat(AreaObjectId, "MarshalFrom.y", From.y);
	SetLocalFloat(AreaObjectId, "MarshalTo.x", To.x);
	SetLocalFloat(AreaObjectId, "MarshalTo.y", To.y);
	PS_CallExtensionsScript(PS_Ext_CalcPath, AreaObjectId);
	return PS_UnmarshalInt(AreaObjectId, "MarshalPathSegments.Count");
}

int PS_CalcPathFromCreature(object AreaObjectId, object FromCreature, vector To)
{
	int Collision;
	int PathLength;

	//
	// GetCollision and SetCollision don't handle objects that aren't creatures
	// safely, so check for this up front.
	//

	if (GetObjectType(FromCreature) != OBJECT_TYPE_CREATURE)
	{
		return 0;
	}

	//
	// Bracket the PS_CalcPath call in a collision disable for the creature.
	//
	// This is required because the pathing request is made without excluding
	// any particular creature, so the space that the creature occupies would
	// cause the server to conclude that the path is blocked otherwise.
	//

	Collision = GetCollision(FromCreature);
	if (Collision != FALSE)
	{
		SetCollision(FromCreature, FALSE);
	}

	PathLength = PS_CalcPath(AreaObjectId, GetPosition(FromCreature), To);

	if (Collision != FALSE)
	{
		SetCollision(FromCreature, TRUE);
	}

	return PathLength;
}

vector PS_GetPathWaypoint(object AreaObjectId, int WaypointIndex, int ComputeHeight)
{
	vector v;
	string Prefix;

	Prefix = "MarshalPathSegments.PathSegments[" + IntToString(WaypointIndex) + "]";

	v.x = PS_UnmarshalFloat(AreaObjectId, Prefix + ".x");
	v.y = PS_UnmarshalFloat(AreaObjectId, Prefix + ".y");

	if (ComputeHeight == FALSE)
	{
		v.z = 0.0f;
	}
	else
	{
		v.z = PS_ComputeHeight(AreaObjectId, v.x, v.y);
	}

	return v;
}

int PS_StraightPathExists(object AreaObjectId, vector From, vector To)
{
	SetLocalFloat(AreaObjectId, "MarshalFrom.x", From.x);
	SetLocalFloat(AreaObjectId, "MarshalFrom.y", From.y);
	SetLocalFloat(AreaObjectId, "MarshalTo.x", To.x);
	SetLocalFloat(AreaObjectId, "MarshalTo.y", To.y);
	PS_CallExtensionsScript(PS_Ext_StraightPathExists, AreaObjectId);
	return PS_UnmarshalInt(AreaObjectId, "MarshalStraightPathExists");
}

void PS_SetRacialType(object CreatureObjectId, int RacialType)
{
	PS_CallExtensionsScript(PS_Ext_SetRacialType, CreatureObjectId, OBJECT_INVALID, RacialType);
}

void PS_OnPCLoaded(object PCObjectId)
{
	PS_CallExtensionsScript(PS_Ext_OnPCLoaded, PCObjectId);
}

void PS_SetSubRacialType(object CreatureObjectId, int SubRacialType)
{
	PS_CallExtensionsScript(PS_Ext_SetSubRacialType, CreatureObjectId, OBJECT_INVALID, SubRacialType);
}

void PS_OnPCLeave(object PCObjectId)
{
	PS_CallExtensionsScript(PS_Ext_OnPCLeave, PCObjectId);
}

int PS_GetTime()
{
	return PS_CallExtensionsScript(PS_Ext_GetTime, GetModule());
}

int PS_GetTick()
{
	return PS_CallExtensionsScript(PS_Ext_GetTick, GetModule());
}


float PS_UnmarshalFloat(object ObjectId, string Name)
{
	float Value = GetLocalFloat(ObjectId, Name);
	DeleteLocalFloat(ObjectId, Name);
	return Value;
}

int PS_UnmarshalInt(object ObjectId, string Name)
{
	int Value = GetLocalInt(ObjectId, Name);
	DeleteLocalInt(ObjectId, Name);
	return Value;
}

string PS_UnmarshalString(object ObjectId, string Name)
{
	string Value = GetLocalString(ObjectId, Name);
	DeleteLocalString(ObjectId, Name);
	return Value;
}

int PS_ScriptVariablesToAppearanceColor(object ObjectId, string Prefix)
{
	int Value = 0;

	Value |= FloatToInt(255.0f * PS_UnmarshalFloat(ObjectId, Prefix + ".r"));
	Value <<= 8;

	Value |= FloatToInt(255.0f * PS_UnmarshalFloat(ObjectId, Prefix + ".g"));
	Value <<= 8;

	Value |= FloatToInt(255.0f * PS_UnmarshalFloat(ObjectId, Prefix + ".b"));
	Value <<= 8;

	Value |= FloatToInt(255.0f * PS_UnmarshalFloat(ObjectId, Prefix + ".a"));

	return Value;
}

void PS_AppearanceColorToScriptVariables(object ObjectId, string Prefix, int Color)
{
	SetLocalFloat(ObjectId, Prefix + ".r", IntToFloat((Color >>> 24) & 0xFF) / 255.0f);
	SetLocalFloat(ObjectId, Prefix + ".g", IntToFloat((Color >>> 16) & 0xFF) / 255.0f);
	SetLocalFloat(ObjectId, Prefix + ".b", IntToFloat((Color >>> 8) & 0xFF) / 255.0f);
	SetLocalFloat(ObjectId, Prefix + ".a", IntToFloat(Color & 0xFF) / 255.0f);
}

struct TintSet PS_ScriptVariablesToTintSet(object ObjectId, string Prefix)
{
	struct TintSet Value;

	Value.Color0 = PS_ScriptVariablesToAppearanceColor(ObjectId, Prefix + ".Color0");
	Value.Color1 = PS_ScriptVariablesToAppearanceColor(ObjectId, Prefix + ".Color1");
	Value.Color2 = PS_ScriptVariablesToAppearanceColor(ObjectId, Prefix + ".Color2");
	Value.Mask = PS_UnmarshalInt(ObjectId, Prefix + ".Mask");

	return Value;
}

void PS_TintSetToScriptVariables(object ObjectId, string Prefix, struct TintSet Tint)
{
	PS_AppearanceColorToScriptVariables(ObjectId, Prefix + ".Color0", Tint.Color0);
	PS_AppearanceColorToScriptVariables(ObjectId, Prefix + ".Color1", Tint.Color1);
	PS_AppearanceColorToScriptVariables(ObjectId, Prefix + ".Color2", Tint.Color2);
	SetLocalInt(ObjectId, Prefix + ".Mask", Tint.Mask);
}

struct CreatureCoreAppearance PS_ScriptVariablesToCreatureCoreAppearance(object ObjectId, string Prefix)
{
	struct CreatureCoreAppearance Value;
	struct TintSet Tint;

	Value.AppearanceType = PS_UnmarshalInt(ObjectId, Prefix + ".AppearanceType");
	Value.Gender = PS_UnmarshalInt(ObjectId, Prefix + ".Gender");
	Value.SkinColor = PS_UnmarshalInt(ObjectId, Prefix + ".SkinColor");
	Value.TattooColor1 = PS_UnmarshalInt(ObjectId, Prefix + ".TattooColor1");
	Value.TattooColor2 = PS_UnmarshalInt(ObjectId, Prefix + ".TattooColor2");
	Value.HeadVariation = PS_UnmarshalInt(ObjectId, Prefix + ".HeadVariation");
	Value.TailVariation = PS_UnmarshalInt(ObjectId, Prefix + ".TailVariation");
	Value.WingVariation = PS_UnmarshalInt(ObjectId, Prefix + ".WingVariation");
	Value.HairVariation = PS_UnmarshalInt(ObjectId, Prefix + ".HairVariation");
	Value.FacialHairVariation = PS_UnmarshalInt(ObjectId, Prefix + ".FacialHairVariation");

	Tint = PS_ScriptVariablesToTintSet(ObjectId, Prefix + ".Tint");
	Value.Tint_Color0 = Tint.Color0;
	Value.Tint_Color1 = Tint.Color1;
	Value.Tint_Color2 = Tint.Color2;
	Value.Tint_Mask = Tint.Mask;

	Tint = PS_ScriptVariablesToTintSet(ObjectId, Prefix + ".HeadTint");
	Value.HeadTint_Color0 = Tint.Color0;
	Value.HeadTint_Color1 = Tint.Color1;
	Value.HeadTint_Color2 = Tint.Color2;
	Value.HeadTint_Mask = Tint.Mask;

	Tint = PS_ScriptVariablesToTintSet(ObjectId, Prefix + ".HairTint");
	Value.HairTint_Color0 = Tint.Color0;
	Value.HairTint_Color1 = Tint.Color1;
	Value.HairTint_Color2 = Tint.Color2;
	Value.HairTint_Mask = Tint.Mask;

	Value.NeverDrawHelmet = PS_UnmarshalInt(ObjectId, Prefix + ".NeverDrawHelmet");

	return Value;
}

void PS_CreatureCoreAppearanceToScriptVariables(object ObjectId, string Prefix, struct CreatureCoreAppearance CoreAppearance)
{
	struct TintSet Tint;

	SetLocalInt(ObjectId, Prefix + ".AppearanceType", CoreAppearance.AppearanceType);
	SetLocalInt(ObjectId, Prefix + ".Gender", CoreAppearance.Gender);
	SetLocalInt(ObjectId, Prefix + ".SkinColor", CoreAppearance.SkinColor);
	SetLocalInt(ObjectId, Prefix + ".TattooColor1", CoreAppearance.TattooColor1);
	SetLocalInt(ObjectId, Prefix + ".TattooColor2", CoreAppearance.TattooColor2);
	SetLocalInt(ObjectId, Prefix + ".HeadVariation", CoreAppearance.HeadVariation);
	SetLocalInt(ObjectId, Prefix + ".TailVariation", CoreAppearance.TailVariation);
	SetLocalInt(ObjectId, Prefix + ".WingVariation", CoreAppearance.WingVariation);
	SetLocalInt(ObjectId, Prefix + ".HairVariation", CoreAppearance.HairVariation);
	SetLocalInt(ObjectId, Prefix + ".FacialHairVariation", CoreAppearance.FacialHairVariation);

	Tint.Color0 = CoreAppearance.Tint_Color0;
	Tint.Color1 = CoreAppearance.Tint_Color1;
	Tint.Color2 = CoreAppearance.Tint_Color2;
	Tint.Mask = CoreAppearance.Tint_Mask;
	PS_TintSetToScriptVariables(ObjectId, Prefix + ".Tint", Tint);

	Tint.Color0 = CoreAppearance.HeadTint_Color0;
	Tint.Color1 = CoreAppearance.HeadTint_Color1;
	Tint.Color2 = CoreAppearance.HeadTint_Color2;
	Tint.Mask = CoreAppearance.HeadTint_Mask;
	PS_TintSetToScriptVariables(ObjectId, Prefix + ".HeadTint", Tint);

	Tint.Color0 = CoreAppearance.HairTint_Color0;
	Tint.Color1 = CoreAppearance.HairTint_Color1;
	Tint.Color2 = CoreAppearance.HairTint_Color2;
	Tint.Mask = CoreAppearance.HairTint_Mask;
	PS_TintSetToScriptVariables(ObjectId, Prefix + ".HairTint", Tint);

	SetLocalInt(ObjectId, Prefix + ".NeverDrawHelmet", CoreAppearance.NeverDrawHelmet);
}

int PS_CallExtensionsScript(int Cmd, object Self, object P0, int P1, int P2, string P3, string P4)
{
	ClearScriptParams();
	AddScriptParameterInt(Cmd);
	AddScriptParameterObject(P0);
	AddScriptParameterInt(P1);
	AddScriptParameterInt(P2);
	AddScriptParameterString(P3);
	AddScriptParameterString(P4);
	return ExecuteScriptEnhanced("Sigil.Extensions", Self, TRUE);
}

