local isNearBenson = false
local benson = nil
local isAttached = false
local attachedVehicle = nil 

function AttachVehicleToBenson(benson, vehicle)
    if DoesEntityExist(benson) and DoesEntityExist(vehicle) then
        local boneIndex = GetEntityBoneIndexByName(benson, "chassis") 
        local offset = vector3(0.0, -1.5, 0.5) 
        AttachEntityToEntity(vehicle, benson, boneIndex, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, true, true, false, true, 20, true)

       
        SetEntityCollision(vehicle, true, true) 
        FreezeEntityPosition(vehicle, true) 

        isAttached = true
        attachedVehicle = vehicle 
        Notify("Véhicle Attached.")
        print("DEBUG: Véhicle Attached.")
    else
        print("DEBUG: Fail. Benson unfinded.")
    end
end


function DetachVehicleFromBenson(vehicle)
    if DoesEntityExist(vehicle) then
        DetachEntity(vehicle, true, true)
        SetEntityCollision(vehicle, true, true) 
        FreezeEntityPosition(vehicle, false) 
        isAttached = false
        attachedVehicle = nil 
        Notify("Véhicule détaché du Benson.")
        print("DEBUG: Véhicule détaché avec succès.")
    else
        print("DEBUG: Echec du détachement. Véhicule introuvable.")
    end
end


function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = GetPlayerPed(-1)
        local playerPos = GetEntityCoords(playerPed)


        if not isAttached then
            benson = GetClosestVehicle(playerPos, 5.0, GetHashKey("benson"), 70)

            
            if DoesEntityExist(benson) then
                isNearBenson = true
                print("DEBUG: Benson détecté.")

                
                if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)

                    DisplayHelpText("Press ~INPUT_CONTEXT~ to attach the véhicle.")
                    print("DEBUG: Can attach to benson.")

                    
                    if IsControlJustPressed(1, 51) then -- 51 = "E"
                        AttachVehicleToBenson(benson, vehicle)
                        print("DEBUG: Tentative d'attachement.")
                    end
                else
                    print("DEBUG: Player isn't in a vehicle.")
                end
            else
                isNearBenson = false
                
            end
        else
            
            DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour détacher le véhicule.")
            print("DEBUG: Option de détachement disponible.")

            
            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                
                if attachedVehicle == vehicle then
                   
                    if IsControlJustPressed(1, 51) then
                        DetachVehicleFromBenson(vehicle)
                        print("DEBUG: Tentative de détachement.")
                    end
                else
                    print("DEBUG: Le joueur n'est pas dans le véhicule attaché.")
                end
            else
                print("DEBUG: Le joueur n'est pas dans un véhicule.")
            end
        end
    end
end)


function Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end
