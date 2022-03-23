CreateThread(function()
    createGroupCommand('acunban', function(source, args, rawCmd)
        local _src = source
        local banId = rawCmd:sub(9)

        MySQL.Async.fetchAll('SELECT playername, license FROM `derpac-bans` WHERE ban_id = @ban_id', {
            ['@ban_id'] = banId
        }, function(result)
            if result[1] ~= nil then
                MySQL.Async.execute('DELETE FROM `derpac-bans` WHERE ban_id = @ban_id AND license = @license', {
                    ['@ban_id'] = banId,
                    ['@license'] = result[1].license
                }, function(rowsChanged)
                    sendMsg(_src, 'DTRP-AC', string.format('Hráč ^1%s^0 (BAN-ID: %s) byl odbanován.', result[1].playername, banId))
                    discordLog('**PLAYER UNBANNED**', string.format('`Action:` Player unban\n`Player:` %s\n`Player Ban ID:` %s\n\n`Admin:` %s', result[1].playername, banId, GetPlayerName(_src)), false)
                end)
            else
                sendMsg(_src, 'DTRP-AC:', 'Toto BAN-ID není v databázi!')
            end
        end)
    end)

    createGroupCommand('acscreen', function(source, args, rawCmd)
        local _src = source
        local targetId = rawCmd:sub(9)
        local steamid, license, _, discord = getidentifiers(targetId)
        exports['discord-screenshot']:requestCustomClientScreenshotUploadToDiscord(
            targetId,
            Webhooks.REQUIRED_SCREENS_LOG,
            {
                encoding = 'jpg',
                quality = 0.92
            },
            {
                username = '😈 DTRP ANTICHEAT 😈',
                avatar_url = Webhooks.IMAGE,
                content = '**PLAYER SCREEN**' .. '\n' .. string.format('`Player:` %s\n`Player ID:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s\n\n`Admin:` %s', GetPlayerName(targetId), targetId, license, steamid, discord, GetPlayerName(_src)),
            },
            5000,
            function(error)
                if error then
                    sendMsg(_src, 'DTRP-AC', 'Při screenování hráče nastala chyba...')
                    return print('^1ERROR: ' .. error .. '^0')
                else
                    sendMsg(_src, 'DTRP-AC', 'Screen hráče se poslal na discord')
                end
            end
        )
    end)

    createConsoleCommand('accunban', function(source, args, rawCmd)
        local banId = rawCmd:sub(10)

        MySQL.Async.fetchAll('SELECT playername, license FROM `derpac-bans` WHERE ban_id = @ban_id', {
            ['@ban_id'] = banId
        }, function(result)
            if result[1] ~= nil then
                MySQL.Async.execute('DELETE FROM `derpac-bans` WHERE ban_id = @ban_id AND license = @license', {
                    ['@ban_id'] = banId,
                    ['@license'] = result[1].license
                }, function(rowsChanged)
                    print('player unbanned')
                    discordLog('**PLAYER UNBANNED**', string.format('`Action:` Player unban\n`Player:` %s\n`Player Ban ID:` %s\n\n`Admin:` Console', result[1].playername, banId), false)
                end)
            else
                print('this ban id is not in database!')
            end
        end)
    end)

    createConsoleCommand('accscreen', function(source, args, rawCmd)
        local targetId = rawCmd:sub(11)
        local steamid, license, _, discord = getidentifiers(targetId)
        exports['discord-screenshot']:requestCustomClientScreenshotUploadToDiscord(
            targetId,
            Webhooks.REQUIRED_SCREENS_LOG,
            {
                encoding = 'jpg',
                quality = 0.92
            },
            {
                username = '😈 DTRP ANTICHEAT 😈',
                avatar_url = Webhooks.IMAGE,
                content = '**PLAYER SCREEN**' .. '\n' .. string.format('`Player:` %s\n`Player ID:` %s\n`License:` %s\n`Steam ID:` %s\n`Discord:` %s\n\n`Admin:` Console', GetPlayerName(targetId), targetId, license, steamid, discord),
            },
            5000,
            function(error)
                if error then
                    return print('^1ERROR: ' .. error .. '^0')
                else
                    print('Screen has been sent to discord')
                end
            end
        )
    end)
end)