#include <sourcemod>

#define PLAYER_NOT_EXIST 0
#define MMRIH_MAX_PLAYERS 8

static Handle:playerStateTimer = INVALID_HANDLE;
static Handle:hudMessage = INVALID_HANDLE;

static int playerCount = PLAYER_NOT_EXIST;

public Plugin:myinfo =
{
	name 		= "hphud-run_holding_the_object",
	author 		= "사마나",
	description 	= "빅스타 서버 플러그인 / hp 허드랑 오브젝트 들고 달리는 플러그인 통합",
	version 		= "1.0",
	url 			= "X"
}

public OnPluginStart()
{
	HookEvent("nmrih_round_begin", RoundBeginEvent);
	hudMessage = CreateHudSynchronizer();
}

public OnClientPutInServer(client)
{
	playerCount++;
}

public OnClientDisconnect(clinet)
{
	playerCount--;
	
	if(playerCount == PLAYER_NOT_EXIST)
		TimerRefund();
}

public OnMapEnd() {
	TimerRefund();
}


public Action:RoundBeginEvent(Handle:event, const String:name[], bool:dontBroadcast) 
{	
	TimerRefund();
	playerStateTimer = CreateTimer(1.0, PlayerState, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action:PlayerState(Handle:timer, any:data) 
{
	for(int client = 1; client <= MMRIH_MAX_PLAYERS; client++)
	{
		if (IsClientInGame(client) && IsPlayerAlive(client)) 
		{	
			SetEntProp(client, Prop_Send, "m_bSprintEnabled", 1);
			SetHudTextParams(-1.0, 1.0, 1.0, 255, 50, 50, 255);
			ShowSyncHudText(client, hudMessage, "Health: %d", GetClientHealth(client));			
		}
	}
}

public TimerRefund()
{
	if(playerStateTimer != INVALID_HANDLE)
		KillTimer(playerStateTimer);
		
	playerStateTimer = INVALID_HANDLE;
}