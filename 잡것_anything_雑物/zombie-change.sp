#include <sourcemod>

#define PLAYER_NOT_EXIST 0

static Handle:zombieChangeTimer = INVALID_HANDLE;

static int playerCount = PLAYER_NOT_EXIST;

public Plugin:myinfo =
{
	name = "zombie change",
	author = "사마나",
	description = "빅스타 올러너 서버 플러그인 / 좀비를 러너로 바꿈",
	version = "1.0",
	url = "X"	
};

public OnPluginStart()
{
	HookEvent("nmrih_round_begin", RoundBeginEvent);
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
	zombieChangeTimer = CreateTimer(2.0, ChangeZombies, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action:ChangeZombies(Handle:timer, any:client) 
{
	new entity;
	new Float:spawnPosition[3];
	
	while((entity = FindEntityByClassname(entity, "npc_nmrih_shamblerzombie")) != -1) {
		new spawnZombie = CreateEntityByName("npc_nmrih_runnerzombie");
		new pointHurt = CreateEntityByName("point_hurt");
		
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", spawnPosition);
		DispatchKeyValueVector(pointHurt, "Origin", spawnPosition);
		DispatchKeyValue(pointHurt, "Damage", "900000");
		DispatchKeyValueFloat(pointHurt, "DamageRadius", 1.0);
		DispatchKeyValue(pointHurt,"DamageType", "1");
		DispatchSpawn(pointHurt);
		AcceptEntityInput(pointHurt, "Hurt", -1);
		AcceptEntityInput(pointHurt, "Kill");
		AcceptEntityInput(entity, "Kill");
		DispatchSpawn(spawnZombie);
		TeleportEntity(spawnZombie, spawnPosition, NULL_VECTOR, NULL_VECTOR);
	}
	
}

public TimerRefund()
{
	if(zombieChangeTimer != INVALID_HANDLE)
		KillTimer(zombieChangeTimer);
	
	zombieChangeTimer = INVALID_HANDLE;
}