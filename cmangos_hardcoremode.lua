--Script that terminates the player session and banhammers their current character on death
--Also checks if the player logged in dead
--Untested - should be fine

local PLAYER_EVENT_ON_FIRST_LOGIN = 30
local PLAYER_EVENT_ON_KILL_PLAYER = 6
local PLAYER_EVENT_ON_KILLED_BY_CREATURE = 8
local PLAYER_EVENT_ON_LOGIN = 3

--Advise player that permadeath is on on first login
local function Advertise(event, player)
    player:SendBroadcastMessage("Welcome, Death is Permanent, Have Fun")
    player:SendBroadcastMessage("Welcome, Death is Permanent, Have Fun")
    player:SendBroadcastMessage("Welcome, Death is Permanent, Have Fun")
end

local function RIPCharacter(event, killer, killed)
--Log the player out
--    killed:LogoutPlayer(false)

--Remove them from a guild and disband it if they're the leader, yes really.
    if(killed:IsInGuild()) then
        if(killed:IsGuildMaster()) then
            killed:GetGuild():Disband()
        else
            killed:GetGuild():DeleteMember(killed, false)
        end
    end

--Server Announce that someone has died
    SendWorldMessage("", killed:GetName(), " has been slain by ", killer:GetName(), "!")
    SendWorldMessage("Blood for the Blood God!")
    SendWorldMessage("Skulls for the Skull Throne!")

--Ban their character - could logout & delete via sql but this is easier / funnier having them delete it themselves
    RunCommand("ban character ", killed:GetName(), "Died -1")
end

--Ban a character if they login dead eg alt+f4'd to try and avoid dying
local function DeadLogin(event, player)
    if(player:IsDead()) then
        RunCommand("ban character ", player:GetName(), "LoggedInWhileDead -1")
    end
end

--Register our player events
RegisterPlayerEvent(PLAYER_EVENT_ON_FIRST_LOGIN, Advertise)
RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, DeadLogin)
RegisterPlayerEvent(PLAYER_EVENT_ON_KILL_PLAYER, RIPCharacter)
RegisterPlayerEvent(PLAYER_EVENT_ON_KILLED_BY_CREATURE, RIPCharacter)

--Todo: Something with PLAYER_EVENT_ON_CHARACTER_CREATE or first login to kit them out with stuff, probably best to handle in a seperate plguin tho
