-- License: see LICENSE.md (DooDesch custom license)
-- Copyright (c) 2026 DooDesch
-- Local cosmetics only: reads the possessed pawn's assigned chair; no RPCs.
local styles = {"blood", "cross", "circle"}
local materials = {
    blood = "/Game/BloodFx/Material/Decal/MI_Decal_GroundBlood_02",
    cross = "/Game/OutsideAssets/BloodyXClue/BloodyClue_X1_MI",
    circle = "/Game/OutsideAssets/BloodyXClue/BloodyClue_O1_MI",
}
local settings, markedMesh
local decals = {}
local scriptDirectory = debug.getinfo(1,"S").source:match("^@(.+[/\\])")
assert(scriptDirectory, "mod script directory unavailable")
local status, lastError, errorCount = nil, nil, 0
local function log(level, message)
    print("[CabinChairMarker] " .. level .. ": " .. message .. "\n")
end
local function valid(object) return object and object:IsValid() end
local function announce(message)
    if status ~= message then status = message; log("info", message) end
end
local function clear()
    for _,decal in ipairs(decals) do
        if valid(decal) and valid(decal:GetAttachParent()) then
            decal:K2_DestroyComponent(decal:GetOwner())
            assert(not valid(decal:GetAttachParent()), "decal removal did not detach component")
        end
    end
    decals = {}
    markedMesh = nil
end
local function readSettings()
    local loader, cause = loadfile(scriptDirectory .. "settings.lua")
    assert(loader, "settings load failed: " .. tostring(cause))
    local candidate = loader()
    assert(type(candidate) == "table", "settings must return a table")
    assert(type(candidate.enabled) == "boolean", "enabled must be boolean")
    assert(materials[candidate.style], "style must be blood, cross or circle")
    assert(type(candidate.size) == "number" and candidate.size >= 5 and candidate.size <= 30,
        "size must be 5..30")
    assert(type(candidate.seat) == "boolean" and type(candidate.back) == "boolean",
        "seat and back must be boolean")
    return candidate
end
local function localChair()
    for _,pc in ipairs(FindAllOf("Cabin_PC_C") or {}) do
        -- Old travel controllers can remain valid until GC; require the active LocalPlayer link.
        if valid(pc) and not pc:IsActorBeingDestroyed() and pc:IsLocalController()
            and valid(pc.Player) and valid(pc.Player.PlayerController)
            and pc.Player.PlayerController:GetAddress() == pc:GetAddress() then
            local pawn = pc.Pawn
            if valid(pawn) and not pawn:IsActorBeingDestroyed()
                and pawn:IsA("/Game/CabinGameContent/PlayerContent/Cabin_Player.Cabin_Player_C") then
                local chair = pawn.Chair
                if valid(chair) and not chair:IsActorBeingDestroyed()
                    and chair:GetWorld():GetAddress() == pawn:GetWorld():GetAddress() then
                    return chair.Chair
                end
            end
        end
    end
end
local function spawn(mesh, location, rotation, material, size, height)
    local decal = StaticFindObject("/Script/Engine.Default__GameplayStatics"):SpawnDecalAttached(
        material, {X=5,Y=size,Z=height or size}, mesh, FName("None"),
        location, rotation, 0, 0)
    assert(valid(decal), "SpawnDecalAttached returned invalid component")
    decals[#decals+1] = decal -- Retain partial creation for cleanup if a later check fails.
    assert(not decal:IsBeingDestroyed(), "created decal is being destroyed")
    assert(decal:GetAttachParent():GetAddress() == mesh:GetAddress(), "decal attached to wrong mesh")
    assert(not decal.bReplicates, "decal unexpectedly replicates")
    decal:SetFadeScreenSize(0)
    if settings.style == "blood" then
        local instance = decal:CreateDynamicMaterialInstance()
        assert(valid(instance), "blood material instance creation failed")
        instance:SetVectorParameterValue(FName("Color"), {R=0.45,G=0.008,B=0.003,A=1})
    end
end
local function update()
    local mesh = settings.enabled and localChair() or nil
    if not valid(mesh) or (not settings.seat and not settings.back) then
        clear()
        announce(settings.enabled and "waiting for assigned chair / enabled placement" or "disabled; decals removed")
        return
    end
    if valid(markedMesh) and mesh:GetAddress() == markedMesh:GetAddress() then return end
    clear()
    assert(mesh.bReceivesDecals, "assigned chair mesh does not receive decals")
    local path = materials[settings.style]
    LoadAsset(path) -- All updates execute on the game thread.
    local material = StaticFindObject(path .. "." .. path:match("([^/]+)$"))
    assert(valid(material), "decal material unavailable: " .. path)
    local size = settings.size
    if settings.style == "blood" then
        if settings.seat then
            local coverage = math.min(size*1.65,30)
            spawn(mesh, {X=-size*0.45,Y=-size*0.28,Z=48}, {Pitch=-90,Yaw=0,Roll=0}, material, coverage)
            spawn(mesh, {X=size*0.45,Y=size*0.28,Z=48}, {Pitch=-90,Yaw=0,Roll=90}, material, coverage)
            spawn(mesh, {X=0,Y=0,Z=48}, {Pitch=-90,Yaw=0,Roll=180}, material, coverage)
        end
        if settings.back then
            for _,x in ipairs({-size*0.67,0,size*0.67}) do
                spawn(mesh, {X=x,Y=-24,Z=96}, {Pitch=0,Yaw=90,Roll=0}, material, size, size*1.1)
            end
            spawn(mesh, {X=0,Y=-24,Z=70}, {Pitch=0,Yaw=90,Roll=0}, material, size*1.45, size*1.55)
        end
    else
        if settings.seat then spawn(mesh, {X=0,Y=0,Z=48}, {Pitch=-90,Yaw=0,Roll=0}, material, size) end
        if settings.back then spawn(mesh, {X=0,Y=-24,Z=96}, {Pitch=0,Yaw=90,Roll=0}, material, math.min(size,7)) end
    end
    markedMesh = mesh
    announce("confirmed " .. settings.style .. " on " .. mesh:GetFullName() .. "; decals=" .. #decals)
end
local function guarded(operation, callable)
    local ok, cause = pcall(callable)
    if not ok then
        local message = operation .. ": " .. tostring(cause)
        errorCount = errorCount + 1
        if message ~= lastError or errorCount % 60 == 0 then
            log("error", message .. "; failed attempts=" .. errorCount)
        end
        lastError = message
    elseif lastError then
        log("info", "recovered after " .. errorCount .. " failures")
        lastError, errorCount = nil, 0
    end
end
local function toggle()
    settings.enabled = not settings.enabled
    update()
end
local function cycle()
    for i,style in ipairs(styles) do
        if style == settings.style then settings.style = styles[i % #styles+1]; break end
    end
    clear()
    update()
end
local function reload()
    local candidate = readSettings() -- Preserve current settings on invalid edits.
    clear()
    settings = candidate
    update()
    log("info", "settings reloaded")
end
settings = readSettings()
RegisterKeyBind(Key.F6, function() ExecuteInGameThread(function() guarded("F6 toggle", toggle) end) end)
RegisterKeyBind(Key.F7, function() ExecuteInGameThread(function() guarded("F7 style", cycle) end) end)
RegisterKeyBind(Key.F8, function() ExecuteInGameThread(function() guarded("F8 settings", reload) end) end)
local pending = false
LoopAsync(1000, function()
    if pending then return end
    pending = true
    ExecuteInGameThread(function()
        guarded("chair update", update)
        pending = false
    end)
end)
log("info", "loaded; F6 toggle, F7 style, F8 reload settings")
return {toggle=toggle, cycle=cycle, reload=reload, update=update}
