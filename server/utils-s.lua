-- Function to check if is player a server admin.
function isPlayerAdmin(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if Admin.GroupBypass and Admin.Groups[xPlayer.getGroup()] then
        return true
    end
    return false
end

function sendMsg(src, title, message)
    local _src = src
    if not isConsole(_src) then
        if isString(title) and isString(message) then
            TriggerClientEvent('chat:addMessage', _src,{
                --template = '<div style="padding-top: 0.0vw; padding-bottom: 0.0vw; padding-left: 0.25vw; padding-right: 0.25vw; margin: 0.3vw; background-color: rgba(0, 0, 0, 0.00); font-weight: 100; text-shadow: 0px 0 black, 0 0.3px black, 0.0px 0 black, 0 0px black;">             <FONT FACE="Fire Sans"; font style="background-color:rgb(255, 0, 0); font-size: 14px; margin-left: 0px; padding-bottom: 2.0px; padding-left: 3.5px; padding-top: 1.0px; padding-right: 3.5px;border-radius: 0px;"> <b> ERROR</b></font> <FONT FACE="Fire Sans"; font style="background-color:rgb(45, 43, 46); font-size: 16px; margin-left: 1px; padding-bottom: 2.0px; padding-left: 3.5px; padding-top: 1.0px; padding-right: 3.5px;border-radius: 0px;"><b> Musíš počkat 5 sekund, aby jsi mohl/a poslat další L-OOC zprávu! ❌</b></font>',
                template = '<div style="padding-top: 0.22vw; padding-bottom: 0.37vw; padding-left: 1.35vw; padding-right: 0.35vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.45); font-weight: 100; text-shadow: 0px 0 black, 0 0.3px black, 0.0px 0 black, 0 0px black; box-shadow: -0.5px 0 black, 0 0.5px black, 0.5px 0 black, 0 -0.5px black;">             <font style="background-color:rgba(100, 50, 255, 1.0); font-size: 12px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"> <b> DTRP AC</b></font><font style=" font-weight: 800; font-size: 16px; margin-left: 5px; padding-bottom: 5.2px; border-radius: 0px;"><b> </b> </font><font style=" font-weight: 500; font-size: 16px; border-radius: 0px;"> {0} </font></div>',
                args = {message}
            })
        end
    end
end

function sendMsgToAllPlayers(title, message)
    if isString(title) and isString(message) then
        TriggerClientEvent('chat:addMessage', -1,{
            --template = '<div style="padding-top: 0.0vw; padding-bottom: 0.0vw; padding-left: 0.25vw; padding-right: 0.25vw; margin: 0.3vw; background-color: rgba(0, 0, 0, 0.00); font-weight: 100; text-shadow: 0px 0 black, 0 0.3px black, 0.0px 0 black, 0 0px black;">             <FONT FACE="Fire Sans"; font style="background-color:rgb(255, 0, 0); font-size: 14px; margin-left: 0px; padding-bottom: 2.0px; padding-left: 3.5px; padding-top: 1.0px; padding-right: 3.5px;border-radius: 0px;"> <b> ERROR</b></font> <FONT FACE="Fire Sans"; font style="background-color:rgb(45, 43, 46); font-size: 16px; margin-left: 1px; padding-bottom: 2.0px; padding-left: 3.5px; padding-top: 1.0px; padding-right: 3.5px;border-radius: 0px;"><b> Musíš počkat 5 sekund, aby jsi mohl/a poslat další L-OOC zprávu! ❌</b></font>',
            template = '<div style="padding-top: 0.22vw; padding-bottom: 0.37vw; padding-left: 1.35vw; padding-right: 0.35vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.45); font-weight: 100; text-shadow: 0px 0 black, 0 0.3px black, 0.0px 0 black, 0 0px black; box-shadow: -0.5px 0 black, 0 0.5px black, 0.5px 0 black, 0 -0.5px black;">             <font style="background-color:rgba(100, 50, 255, 1.0); font-size: 12px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"> <b> DTRP AC</b></font><font style=" font-weight: 800; font-size: 16px; margin-left: 5px; padding-bottom: 5.2px; border-radius: 0px;"><b> </b> </font><font style=" font-weight: 500; font-size: 16px; border-radius: 0px;"> {0} </font></div>',
            args = {message}
        })
    end
end

function createGroupCommand(cmdName, cb)
    RegisterCommand(cmdName, function(source, args, rawCmd)
        local _src = source
        if not isConsole(_src) then
            if isPlayerAdmin(_src) then
                cb(_src, args, rawCmd)
            else
                sendMsg(_src, 'SYSTÉM', 'Na tento příkaz nemáš oprávnění!')
            end
        else
            print('You can\'t use this command from console!')
        end
    end)
end

function addGroupCmd(cmdName, cb)
    createGroupCommand(cmdName, cb)
end

function createConsoleCommand(cmdName, cb)
    RegisterCommand(cmdName, function(source, args, rawCmd)
        local _src = source
        if isConsole(_src) then
            cb(_src, args, rawCmd)
        else
            sendMsg(_src, 'SYSTÉM', 'Na tento příkaz nemáš oprávnění!')
        end
    end)
end

function addConsoleCmd(cmdName, cb)
    createConsoleCommand(cmdName, cb)
end

function createJobCommand(cmdName, jobName, cb)
    RegisterCommand(cmdName, function(source, args, rawCmd)
        local _src = source
        if not isConsole(_src) then
            local xPlayer = ESX.GetPlayerFromId(_src)

            if xPlayer.job.name == jobName then
                cb(_src, args, rawCmd)
            else
                sendMsg(_src, 'SYSTÉM', 'Na tento příkaz nemáš oprávnění!')
            end
        else
            print('You can\'t use this command from console!')
        end
    end)
end

function addJobCmd(cmdName, cb)
    createJobCommand(cmdName, cb)
end

function createCommand(cmdName, cb)
    RegisterCommand(cmdName, function(source, args, rawCmd)
        local _src = source
        if not isConsole(_src) then
            cb(_src, args, rawCmd)
        else
            print('You can\'t use this command from console!')
        end
    end)
end

function addCmd(cmdName, cb)
    createCommand(cmdName, cb)
end

function isConsole(id)
    if id == 0 then
        return true
    end
    return false
end

function isString(str)
    if type(str) == 'string' then
        return true
    end
    return false
end

function generateBanId()
    local chars = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'}
    local lenght = 16
    local newBanId = ''

    --math.randomseed(os.time())

    for i=1, lenght do
        newBanId = newBanId .. chars[math.random(1, #chars)]
    end

    local result = MySQL.Sync.fetchScalar('SELECT COUNT(ban_id) FROM `derpac-bans` WHERE ban_id = @ban_id', {
        ['@ban_id'] = newBanId
    })

    if result > 0 then
        return generateBanId()
    else
        return newBanId
    end
end