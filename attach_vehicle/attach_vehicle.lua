local isNearBenson = false
local benson = nil
local isAttached = false
local attachedVehicle = nil 

function AttachVehicleToBenson(benson, vehicle)
    if DoesEntityExist(benson) and DoesEntityExist(vehicle) then
        local boneIndex = GetEntityBoneIndexByName(benson, "chassis") -- Récupère l'index du bone du Benson
        local offset = vector3(0.0, -1.5, 0.5) -- Ajustez ces valeurs pour positionner correctement le véhicule
        AttachEntityToEntity(vehicle, benson, boneIndex, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, true, true, false, true, 20, true)

       
        SetEntityCollision(vehicle, true, true) 
        FreezeEntityPosition(vehicle, true) 

        isAttached = true
        attachedVehicle = vehicle 
        Notify("Véhicule attaché au Benson.")
        print("DEBUG: Véhicule attaché avec succès.")
    else
        print("DEBUG: Echec de l'attachement. Véhicule ou Benson introuvable.")
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

                    DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour attacher le véhicule.")
                    print("DEBUG: Option d'attachement disponible.")

                    
                    if IsControlJustPressed(1, 51) then -- 51 = "E"
                        AttachVehicleToBenson(benson, vehicle)
                        print("DEBUG: Tentative d'attachement.")
                    end
                else
                    print("DEBUG: Le joueur n'est pas dans un véhicule.")
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
