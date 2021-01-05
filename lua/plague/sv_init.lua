
AddCSLuaFile("cl_init.lua")

util.AddNetworkString("NotifyPlagueStart")
util.AddNetworkString("NotifyInfection")
util.AddNetworkString("InfectionGone")
util.AddNetworkString("PlagueEnded")

function thePlague.StartPlague(count)

	thePlague.RemoveAllInfection()
	thePlague.SetInfected(count)
	thePlague.isOngoing = true

	local tick = thePlague.Settings.spreadTick
	timer.Create("thePlagueInfectionTimer", tick, 0, thePlague.SpreadInfection)

	net.Start("NotifyPlagueStart")
	net.Broadcast()
end


function thePlague.Infect(ply)

	if ply.isImmune == true then return end

		table.insert(thePlague.sickPeople, ply)
		ply.Infected = true
		thePlague.ChangeSpeed(ply, 1)
		print(ply:Nick().." is infected!")

	timer.Create("thePlague_"..ply:SteamID64(), thePlague.Settings.killTimer, 1, function()

	if ply:Alive() and ply.Infected then
		ply:Kill() 
	end end)

		net.Start("NotifyInfection")
		net.Send(ply)
end


function thePlague.SpreadInfection()

	local sickTable = table.Copy(thePlague.sickPeople)
	local dist = thePlague.Settings.spreadRange

	for index,sickPerson in ipairs(sickTable) do
		for indexPlayer,ply in ipairs( player.GetAll() ) do
			if ply:GetPos():DistToSqr(sickPerson:GetPos()) < dist*dist and not ply.Infected and ply:Alive() then
				thePlague.Infect(ply)
			end
		end
	end
end


function thePlague.RemoveInfection(ply)

	if ply.Infected then
		local playerIndex = table.KeyFromValue(thePlague.sickPeople, ply)
		table.remove(thePlague.sickPeople, playerIndex)
		thePlague.ChangeSpeed(ply, -1)
		ply.Infected = false
		print(ply:Nick().." is cured.")
	end

		net.Start("InfectionGone")
		net.Send(ply)
end

function thePlague.Think()

	if #thePlague.sickPeople == 0 and thePlague.isOngoing then

		net.Start("PlagueEnded")
		net.Broadcast()

		timer.Remove("thePlagueTimer")
		thePlague.isOngoing = false
	end
end


function thePlague.SetInfected(sickCount)

local canBeSickPlayers = {}

	for i,v in ipairs(player.GetAll()) do
		if v:Alive() and not v.isImmune then
			table.insert(canBeSickPlayers,v)
		end
	end

	if #canBeSickPlayers < tonumber(sickCount) then
		print("Not enough players to infect!")
		return
	end
	

	for i=1, tonumber(sickCount) do
		local plyIndex = math.random(#canBeSickPlayers)
		thePlague.Infect(canBeSickPlayers[plyIndex])
		table.remove(canBeSickPlayers,plyIndex)
	end

end

function thePlague.ChangeSpeed(ply, operator)

	local slowdown = thePlague.Settings.infectionSlow
	local slowdownRun = thePlague.Settings.infectionSlowRun

	local normalSpeed = ply:GetWalkSpeed()
	local normalRunSpeed = ply:GetRunSpeed()

	ply:SetWalkSpeed(normalSpeed - (slowdown * operator) )
	ply:SetRunSpeed(normalRunSpeed - (slowdownRun * operator) )

end

function thePlague.SpawnHook(ply)

	ply.isImmune = false
	ply.Infected = false

end

function thePlague.RemoveAllInfection()

thePlague.sickPeople = {}

local players = player.GetAll()

	for i,v in ipairs(players) do

		if v.Infected == true then
			if v:Alive() then
				thePlague.RemoveInfection(v)
			else
				thePlague.ChangeSpeed(v, -1)
			end
		end
	end
end


function thePlague.isArgCorrect(sender,args)

	local allPlayers = player.GetAll()

	if args == nil then sender:ChatPrint("You must specify how many victims you want to infect.") return false end
	if not isnumber(args) then sender:ChatPrint("Please specify a number.") return false end 
	if(#allPlayers < args ) then sender:ChatPrint("Not enough players!") return false end
	if not sender:IsAdmin() or not sender:IsSuperAdmin() then ply:ChatPrint("You have to be an admin to be able to use this command!") return false end

	return true
end



hook.Add("PostPlayerDeath","thePlague_PlayerDied", function(ply) thePlague.RemoveInfection(ply) end)
hook.Add("PlayerDisconnected", "thePlague_PlayerDisconnected", function(ply) thePlague.RemoveInfection(ply) end)
hook.Add("Think","thePlague_think", thePlague.Think)
hook.Add("PlayerInitialSpawn", "thePlague_SpawnHook",function(ply) thePlague.SpawnHook(ply) end )
hook.Add("PlayerSay", "thePlague_chatCommands", 

function(ply,text)

local commandString = string.Explode(" ", text)

---------- Start Plague Command --------------------
	if commandString[1] == "/startplague" then
		if ply:IsAdmin() or ply:IsSuperAdmin() then
			local countInt = tonumber(commandString[2])
			if thePlague.isArgCorrect(ply,countInt) then
				thePlague.StartPlague(countInt)
			end
		end
		return false
	end
----------------------------------------------------
-------- Stop Plague Command -----------------------

	if commandString[1] == "/stopplague" then
		if ply:IsAdmin() or ply:IsSuperAdmin() then
			ply:ChatPrint("The plague has ended.")
			thePlague.RemoveAllInfection()
		end
		return false
	end
----------------------------------------------------
-------- Set Immune Command ------------------------	
	if commandString[1] == "/setimmune" then
		if ply:IsAdmin() or ply:IsSuperAdmin() then

			local target = thePlague.FindPlayer(commandString[2])

			if not target then ply:ChatPrint("Player not found!") return false end
				target.isImmune = true
				ply:ChatPrint("Target " .. target:Nick() .. " is now immune!")
		else
			ply:ChatPrint("You are not an admin!")
		end
			return false
	end
----------------------------------------------------
end)

function thePlague.FindPlayer( name )

local pls = player.GetAll()

	for k = 1, #pls do
		local v = pls[k]

		if string.find(string.lower(v:Nick()), string.lower(name)) ~= nil then
           return v
        end
	end

	return 
end
