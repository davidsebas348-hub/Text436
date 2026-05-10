--// SCRIPT 1
--// DETECTAR RUNNER Y TAGGER
--// Workspace.Characters

local carpeta = workspace:WaitForChild("Characters")

local function esColorRunner(color)
    return math.floor(color.R * 255) == 0
    and math.floor(color.G * 255) == 255
    and math.floor(color.B * 255) == 255
end

local function actualizarRoles()

    local hayRunner = false

    -- PRIMERO detectar si existe runner
    for _, modelo in ipairs(carpeta:GetChildren()) do
        if modelo:IsA("Model") then

            local hl = modelo:FindFirstChild("Highlight")

            if hl and hl:IsA("Highlight") then
                if esColorRunner(hl.FillColor) then
                    hayRunner = true
                    break
                end
            end
        end
    end

    -- DESPUÉS asignar roles
    for _, modelo in ipairs(carpeta:GetChildren()) do
        if modelo:IsA("Model") then

            local hl = modelo:FindFirstChild("Highlight")
            local tieneVFX = modelo:FindFirstChild("VFX")

            local esRunner = false

            if hl and hl:IsA("Highlight") then
                if esColorRunner(hl.FillColor) then
                    esRunner = true
                end
            end

            -- RUNNER
            if esRunner then

                modelo:SetAttribute("Rol", "Runner")

            -- TAGGER
            elseif hayRunner and tieneVFX then

                modelo:SetAttribute("Rol", "Tagger")

            -- TAMBIÉN TAGGER si hay runners aunque no tenga VFX
            elseif hayRunner then

                modelo:SetAttribute("Rol", "Tagger")

            -- NEUTRAL
            else
                modelo:SetAttribute("Rol", "Neutral")
            end
        end
    end
end

carpeta.ChildAdded:Connect(function()
    task.wait(0.2)
    actualizarRoles()
end)

carpeta.ChildRemoved:Connect(function()
    task.wait(0.2)
    actualizarRoles()
end)

task.spawn(function()
    while true do
        actualizarRoles()
        task.wait(0.5)
    end
end)
