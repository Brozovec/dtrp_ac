CONST_POPULATION_TYPE_MISSION = 7
CONST_ENTITY_TYPE_OBJECT = 3
CONST_ENTITY_TYPE_VEHICLE = 2
CONST_ENTITY_TYPE_PED = 1

CHEATER_ACTION = {}

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local _source = source
    local playerName = GetPlayerName(_source)
    local steamid, license, playerip, discord = getidentifiers(_source)
    local token = GetPlayerToken(_source, 0)
    local token2 = GetPlayerToken(_source, 1)
    local token3 = GetPlayerToken(_source, 2)
    local token4 = GetPlayerToken(_source, 3)
    local token5 = GetPlayerToken(_source, 4)
    local token6 = GetPlayerToken(_source, 5)
    local token7 = GetPlayerToken(_source, 8)
    deferrals.defer()
    Wait(0)
    MySQL.Async.fetchAll('SELECT * FROM `derpac-bans` WHERE `license` = @license OR `token` = @token OR `token2` = @token2 OR `token3` = @token3 OR `token4` = @token4 OR `token5` = @token5 OR `token6` = @token6 OR `token7` = @token7', {
        ['@license'] = license,
        ['@token'] = token,
        ['@token2'] = token2,
        ['@token3'] = token3,
        ['@token4'] = token4,
        ['@token5'] = token5,
        ['@token6'] = token6,
        ['@token7'] = token7
    }, function(result)
        if result[1] ~= nil then
            deferrals.done('\n😈[DTRP-AC]😈\nByl/a jsi zabanován na tomto serveru!')
            connectLeaveLog('triedconnect', '**PLAYER TRIED CONNECT BUT HE IS BANNED**', string.format('`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', playerName, license, steamid, discord))
        elseif result[1] == nil then
            deferrals.done()
            connectLeaveLog('connect', '**PLAYER CONNECTING**', string.format('`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', playerName, license, steamid, discord))
        end
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source
    local playerName = GetPlayerName(_source)
    local steamid, license, playerip, discord = getidentifiers(_source)
    connectLeaveLog('disconnect', '**PLAYER DISCONNECTED**', string.format('`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s\n `Reason:` %s', playerName, license, steamid, discord, reason))
    CHEATER_ACTION[_source] = nil
end)

AddEventHandler('chatMessage', function(source, name, message)
    local _src = source
    if ChatFilterEnable then
        local blacklistedMessages = ChatFilters

        for k,v in pairs(blacklistedMessages) do
            if string.match(message, v) or blacklistedMessages[message] then
                kickPlayer(_src, 'blacklistedword', message)
                CancelEvent()
            end
        end
    end
    if ChatAntiFakeMsgs then
        local playername = GetPlayerName(_src)

        if name ~= playername then
           banTarget(_src, 'fakemsg', message)
        end
    end
end)

AddEventHandler('entityCreating', function(id)
    local model = GetEntityModel(id)
    local type = GetEntityType(id)
    local owner = NetworkGetEntityOwner(id)

    if type == CONST_ENTITY_TYPE_OBJECT then
        if BlacklistedObjects[model] and BlacklistedObjectsEnable then
            if model ~= 0 then
                banTarget(owner, 'blacklistedobject', model)
            end
            CancelEvent()
        end
    elseif type == CONST_ENTITY_TYPE_VEHICLE and BlacklistedVehiclesEnable then
        if BlacklistedVehicles[model] then
            if not isPlayerAdmin(owner) then
                kickPlayer(owner, 'blacklistedveh', model)
                CancelEvent()
            end
        end
    elseif type == CONST_ENTITY_TYPE_PED and BlacklistedPedsEnable then
        if BlacklistedPeds[model] then
            banTarget(owner, 'blacklistedpeds', model)
            CancelEvent()
        end
    end
end)

function tprint(tbl, indent)
	if type(tbl) ~= 'table' then return end
	if not indent then indent = 0 end
	local toprint = string.rep(" ", 0) .. "{\r\n"
	indent = indent + 2 
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  " = "   
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 1) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end

AddEventHandler('explosionEvent', function(sender, ev)
    if DetectExplosions then
        local type = ev.explosionType
        local _sender = sender

        if ev.damageScale ~= 0 then
            ev.damageScale = 0
        end
        
        if CheaterExplosions[type] then
            banTarget(_sender, 'explosion', type)
            CancelEvent()
        end

        if PlayerExplosions[type] then
            local playerName = GetPlayerName(_sender)
            local steamid, license, playerip, discord = getidentifiers(_sender)
            discordLog('**EXPLOSION DETECTED**', string.format('`Action:` Created explosion (%s)\n`Player:` %s\n`Player ID:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', type, playerName, _sender, license, steamid, discord), true)
            CancelEvent()
        end
    end
end)

AddEventHandler('ptFxEvent', function(sender, event)
    local _sender = sender

    if DetectParticles then
        if BlockedParticles[event.effectHash] then
            banTarget(_sender, 'particle', event.effectHash)
            CancelEvent()
        end
    end

    if DetectParticleAssets then
        if BlockedParticleAssets[ev.assetHash] then
            banTarget(_sender, 'particleassets', ev.assetHash)
            CancelEvent()
        end
    end
end)

CreateThread(function()
    if FakeTriggersEnable then
        for _, trigger in pairs(FakeTriggers) do
            RegisterNetEvent(trigger, function()
                local _src = source
                banTarget(_src, 'fakeevent', trigger)
                CancelEvent()
            end)
        end
    end
end)

RegisterNetEvent('fgs-anticheat:banPlayer', function(detection)
    local _src = source

    if not isPlayerAdmin(_src) then
        banTarget(_src, detection, '')
    end
end)

function banTarget(target, type, reason)
    local _target = target
    if _target ~= 0 or _target ~= nil then
        if not CHEATER_ACTION[_target] then
            CHEATER_ACTION[_target] = true
            local playerName = GetPlayerName(_target)
            local steamid, license, playerip, discord = getidentifiers(_target)
            if type == 'fakeevent' then
                banPlayer(_target, 'Called a forbidden event!', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Called a forbidden event (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'explosion' then
                banPlayer(_target, 'Created a explosion!', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Created a explosion (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'particle' then
                banPlayer(_target, 'Created a particle!', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Created a particle (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'particleassets' then
                banPlayer(_target, 'Created a particle assets!', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Created a particle assets (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'blacklistedobject' then
                banPlayer(_target, 'Spawned a blacklisted object!', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Spawned a blacklisted object (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'blacklistedpeds' then
                banPlayer(_target, 'Spawned a blacklisted peds', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Spawned a blacklisted peds (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'blacklistedweapon' then
                banPlayer(_target, 'Pulled out a blacklisted weapon', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Pulled out a blacklisted weapon (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'fakemsg' then
                banPlayer(_target, 'Sent fake message', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Attempt to sent fake message (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'weapongive' then
                banPlayer(_target, 'Tried to give weapons to player', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Tried to give weapons to player (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'billing' then
                banPlayer(_target, 'Sent bill', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Tried to send bill (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord))
            elseif type == 'spectate' then
                banPlayer(_target, 'Spectate detected', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Spectate detected \n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', playerName, license, steamid, discord))
            elseif type == 'invisible' then
                banPlayer(_target, 'Invisible detected', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Invisible detected \n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', playerName, license, steamid, discord))
            elseif type == 'speedhack' then
                banPlayer(_target, 'Speedhack detected', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Speedhack detected \n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', playerName, license, steamid, discord))
            elseif type == 'freecam' then
                banPlayer(_target, 'Freecam detected', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Freecam detected \n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', playerName, license, steamid, discord))
            elseif type == 'noclip' then
                banPlayer(_target, 'Noclip detected', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Noclip detected \n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', playerName, license, steamid, discord))
            elseif type == 'superjump' then
                if IsPlayerUsingSuperJump(_target) then
                    banPlayer(_target, 'Superjump detected', '**PLAYER HAS BEEN BANNED!**', string.format('`Action:` Superjump detected \n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', playerName, license, steamid, discord))
                end
            end
        end
    end
end

function kickPlayer(target, type, reason)
    local _target = target
    if _target ~= 0 or _target ~= nil then
        if not CHEATER_ACTION[_target] then
            CHEATER_ACTION[_target] = true
            local playerName = GetPlayerName(_target)
            local steamid, license, playerip, discord = getidentifiers(_target)
            local msg 
            if reason == 'blacklistedveh' then
                msg = string.format('`Action:` Spawned blacklisted vehicle (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord)
            elseif reason == 'blacklistedword' then
                msg = string.format('`Action:` Sent blaclisted word (%s)\n`Player:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s', reason, playerName, license, steamid, discord)
            end

            exports['discord-screenshot']:requestCustomClientScreenshotUploadToDiscord(
                _target,
                Webhooks.PLAYER_ACTIONS_LOG,
                {
                    encoding = 'jpg',
                    quality = 0.92
                },
                {
                    username = '😈 DTRP ANTICHEAT 😈',
                    avatar_url = Webhooks.IMAGE,
                    content = title .. '\n' .. msg,
                },
                5000,
                function(error)
                    if error then
                        return print('^1ERROR: ' .. error .. '^0')
                    end
    
                    sendMsgToAllPlayers('DTRP-AC:', string.format('Hráč ^1%s^0 (ID: %s) byl vyhozen!', playerName, _target))
                    
                    if reason == 'blacklistedveh' then
                        DropPlayer(_target, '\n😈[DTRP-AC]😈\nSpawned a blacklisted vehicle!')
                    elseif reason == 'blacklistedword' then
                        DropPlayer(_target, '\n😈[DTRP-AC]😈\nSent a blacklisted word!')
                    end
                end
            )
        end
    end
end

function getidentifiers(player)
    local steamid = 'Not Linked'
    local license = 'Not Linked'
    local discord = 'Not Linked'
    local ip = 'Not Linked'

    for _, v in pairs(GetPlayerIdentifiers(player)) do
        if string.sub(v, 1, string.len('steam:')) == 'steam:' then
            steamid = v
        elseif string.sub(v, 1, string.len('license:')) == 'license:' then
            license = v
        elseif string.sub(v, 1, string.len('ip:')) == 'ip:' then
            ip = string.sub(v, 4)
        elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
            discordid = string.sub(v, 9)
            discord = '<@' .. discordid .. '>'
        end
    end

    return steamid, license, ip, discord
end

function banPlayer(target, reason, title, msg)
    local _target = target
    local playerName = GetPlayerName(_target)
    local steamid, license, playerip, discord = getidentifiers(_target)
    local token = GetPlayerToken(_target, 0)
    local token2 = GetPlayerToken(_target, 1)
    local token3 = GetPlayerToken(_target, 2)
    local token4 = GetPlayerToken(_target, 3)
    local token5 = GetPlayerToken(_target, 4)
    local token6 = GetPlayerToken(_target, 5)
    local token7 = GetPlayerToken(_target, 8)
    local banId = generateBanId()

    MySQL.Async.fetchAll('SELECT * FROM `derpac-bans` WHERE ban_id = @ban_id OR license = @license OR token = @token OR token2 = @token2 OR token3 = @token3 OR token4 = @token4 OR token5 = @token5 OR token6 = @token6 OR token7 = @token7', {
        ['@ban_id'] = banId,
        ['@license'] = license,
        ['@token'] = token,
        ['@token2'] = token2,
        ['@token3'] = token3,
        ['@token4'] = token4,
        ['@token5'] = token5,
        ['@token6'] = token6,
        ['@token7'] = token7
    }, function(result)
        if not result[1] then
            MySQL.Async.execute('INSERT INTO `derpac-bans` (ban_id, playername, license, hex, discord, playerip, token, token2, token3, token4, token5, token6, token7, reason) VALUES (@ban_id, @playername, @license, @hex, @discord, @playerip, @token, @token2, @token3, @token4, @token5, @token6, @token7, @reason)', {
                ['@ban_id'] = banId,
                ['@playername'] = playerName,
                ['@license'] = license,
                ['@hex'] = steamid,
                ['@discord'] = discord,
                ['@playerip'] = playerip,
                ['@token'] = token,
                ['@token2'] = token2,
                ['@token3'] = token3,
                ['@token4'] = token4,
                ['@token5'] = token5,
                ['@token6'] = token6,
                ['@token7'] = token7,
                ['@reason'] = reason
            })
        end
        
        exports['discord-screenshot']:requestCustomClientScreenshotUploadToDiscord(
            _target,
            Webhooks.PLAYER_ACTIONS_LOG,
            {
                encoding = 'jpg',
                quality = 0.92
            },
            {
                username = '😈 DTRP ANTICHEAT 😈',
                avatar_url = Webhooks.IMAGE,
                content = title .. '\n' .. msg .. string.format('\n`Ban-ID:` %s', banId),
            },
            5000,
            function(error)
                if error then
                    return print('^1ERROR: ' .. error .. '^0')
                end

                DropPlayer(_target, '\n😈[DTRP-AC]😈\n' .. reason .. '\n\nYour BAN-ID: ' .. banId)
                sendMsgToAllPlayers('DTRP-AC:', string.format('Hráč ^1%s^0 (ID: %s) byl zabanován!', playerName, _target))
            end
        )
        
    end)
end

function discordLog(title, msg, isExplosion)
    isExplosion = isExplosion or false

    local connect = {
        {
            ['color'] = 8421504,
            ['title'] = title,
            ['description'] = msg,
            ['footer'] = {
                ['text'] = '😈[DTRP-AC]😈 | ' .. os.date('%H:%M - %d. %m. %Y', os.time()) .. ' | Created by Fugas and Derp',
                ['icon_url'] = Webhooks.IMAGE,
            },
        }
    }

    if not isExplosion then
        PerformHttpRequest(Webhooks.PLAYER_ACTIONS_LOG, function(err, text, headers) end, 'POST', json.encode({username = Webhooks.BOTNAME, embeds = connect}), { ['Content-Type'] = 'application/json' })
    else
        PerformHttpRequest(Webhooks.PLAYER_EXPLOSION_LOG, function(err, text, headers) end, 'POST', json.encode({username = Webhooks.BOTNAME, embeds = connect}), { ['Content-Type'] = 'application/json' })
    end
end

function connectLeaveLog(type, title, msg)
    local color

    if type == 'connect' then
        color = 3863105
    elseif type == 'disconnect' then
        color = 15874618
    elseif type == 'triedconnect' then
        color = 16711680
    end

    local connect = {
        {
            ['color'] = color,
            ['title'] = title,
            ['description'] = msg,
            ['footer'] = {
                ['text'] = '😈[DTRP-AC]😈 | ' .. os.date('%H:%M - %d. %m. %Y', os.time()) .. ' | Created by Fugas and Derp',
                ['icon_url'] = Webhooks.IMAGE,
            },
        }
    }
    PerformHttpRequest(Webhooks.PLAYER_CONNECT_LEAVE_LOG, function(err, text, headers) end, 'POST', json.encode({username = Webhooks.BOTNAME, embeds = connect}), { ['Content-Type'] = 'application/json' })
end