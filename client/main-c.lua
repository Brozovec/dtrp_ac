isLoaded = false
isInVehicle = false

CreateThread(function()
    if ESX.IsPlayerLoaded() then
        isLoaded = true
    end
end)

RegisterNetEvent('esx:playerLoaded', function()
    isLoaded = true
end)

RegisterNetEvent('baseevents:leftVehicle', function() 
    isInVehicle = false
end)

RegisterNetEvent('baseevents:enteredVehicle', function()
    isInVehicle = true
end)

CreateThread(function()
    while isLoaded do
        Wait(500)

        local ped = PlayerPedId()
        local playerId = PlayerId()
        local playerSpeed = GetEntitySpeed(ped)
        local playerAlpha = GetEntityAlpha(ped)
        local playerHealth = GetEntityHealth(ped)
        local isVisible = IsEntityVisible(ped)
        local isVisibleToScript = IsEntityVisibleToScript(ped)

        if DETECTIONS.Spectate then
            if NetworkIsInSpectatorMode() then
                TriggerServerEvent('fgs-anticheat:banPlayer', 'spectate')
            end
        end

        if DETECTIONS.Invisible then
            if not isVisible and not isVisibleToScript or playerAlpha <= 150 then
                TriggerServerEvent('fgs-anticheat:banPlayer', 'invisible')
            end
        end

        if DETECTIONS.Godmode then
            if GetPlayerInvincible(playerId) then
                TriggerServerEvent('fgs-anticheat:banPlayer', 'godmode')
            end

            if playerHealth > 200 then
                TriggerServerEvent('fgs-anticheat:banPlayer', 'godmode')
            end

            local retval, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof = GetEntityProofs(ped)
            if bulletProof == 1 or collisionProof == 1 or meleeProof == 1 or steamProof == 1 or drownProof == 1 then
                TriggerServerEvent('fgs-anticheat:banPlayer', 'godmode')
            end
        end

        if DETECTIONS.Speedhack then
            if not isInVehicle then
                if playerSpeed > 10 then
                    if not IsPedFalling(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedJumpingOutOfVehicle(ped) and not IsPedRagdoll(ped) then
                        TriggerServerEvent('fgs-anticheat:banPlayer', 'speedhack')
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while isLoaded and DETECTIONS.Superjump do
        Wait(1000)

        local ped = PlayerPedId()
        local playerSpeed = GetEntitySpeed(ped)

        if IsPedJumping(ped) and not isInVehicle and playerSpeed > 7.5 then
            TriggerServerEvent('fgs-anticheat:banPlayer', 'superjump')
        end
    end
end)