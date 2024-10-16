function AttachVehicleToBenson(benson, vehicle)
    if DoesEntityExist(benson) and DoesEntityExist(vehicle) then
        local boneIndex = GetEntityBoneIndexByName(benson, "chassis") 
        local vehiclePos = GetEntityCoords(vehicle) 
        local bensonPos = GetEntityCoords(benson) 


        local offset = vector3(0.0, -1.5, 0.5) 
        local attachPos = bensonPos + offset


        AttachEntityToEntity(vehicle, benson, boneIndex, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, true, true, false, true, 20, true)


        SetEntityCollision(vehicle, false, true)
    end
end


RegisterCommand('attach', function(source, args, rawCommand)
    local playerPed = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)


        local benson = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, GetHashKey("benson"), 70)

        if DoesEntityExist(benson) then
            AttachVehicleToBenson(benson, vehicle)
            Notify("Véhicule attaché au Benson.")
        else
            Notify("Aucun Benson à proximité.")
        end
    else
        Notify("Vous devez être dans un véhicule.")
    end
end, false)


function Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end


RegisterCommand('detach', function(source, args, rawCommand)
    local playerPed = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)


        local benson = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, GetHashKey("benson"), 70)

        if DoesEntityExist(benson) then
            DetachEntity(vehicle, true, true)
            SetEntityCollision(vehicle, true, true)
            Notify("Véhicule détaché du Benson.")
        else
            Notify("Aucun Benson à proximité.")
        end
    else
        Notify("Vous devez être dans un véhicule.")
    end
end, false)
