
--[[--------------------------------------------------------------------------------
-- ModelTileInfo是战局场景里的tile的简要属性框（即场景下方的小框）。
--
-- 主要职责和使用场景举例：
--   - 构造和显示tile的简要属性框。
--   - 自身被点击时，呼出tile的详细属性页面。
--
-- 其他：
--  - 本类所显示的是光标所指向的tile的信息（通过event获知光标指向的是哪个tile）
--]]--------------------------------------------------------------------------------

local ModelTileInfo = class("ModelTileInfo")

local GridIndexFunctions = require("src.app.utilities.GridIndexFunctions")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function updateWithModelTile(self, modelTile)
    self.m_ModelTile = modelTile

    if (self.m_View) then
        self.m_View:updateWithModelTile(modelTile)
            :setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtModelTileMapUpdated(self, event)
    updateWithModelTile(self, self.m_ModelTileMap:getModelTile(self.m_CursorGridIndex))
end

local function onEvtMapCursorMoved(self, event)
    local gridIndex = event.gridIndex
    if (not GridIndexFunctions.isEqual(gridIndex, self.m_CursorGridIndex)) then
        self.m_CursorGridIndex = GridIndexFunctions.clone(gridIndex)
        updateWithModelTile(self, self.m_ModelTileMap:getModelTile(gridIndex))
    end
end

local function onEvtGridSelected(self, event)
    onEvtMapCursorMoved(self, event)
end

local function onEvtTurnPhaseMain(self, event)
    self.m_ModelPlayer = event.modelPlayer
    updateWithModelTile(self, self.m_ModelTileMap:getModelTile(self.m_CursorGridIndex))
end

--------------------------------------------------------------------------------
-- The contructor and initializers.
--------------------------------------------------------------------------------
function ModelTileInfo:ctor(param)
    self.m_CursorGridIndex = {x = 1, y = 1}

    return self
end

function ModelTileInfo:setModelTileDetail(model)
    assert(self.m_ModelTileDetail == nil, "ModelTileInfo:setModelTileDetail() the model has been set.")
    self.m_ModelTileDetail = model

    return self
end

function ModelTileInfo:setModelTileMap(model)
    assert(self.m_ModelTileMap == nil, "ModelTileInfo:setModelTileMap() the model has been set.")
    self.m_ModelTileMap = model

    updateWithModelTile(self, model:getModelTile(self.m_CursorGridIndex))

    return self
end

function ModelTileInfo:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "ModelTileInfo:setRootScriptEventDispatcher() the dispatcher has been set.")

    self.m_RootScriptEventDispatcher = dispatcher
    dispatcher:addEventListener("EvtModelTileMapUpdated", self)
        :addEventListener("EvtMapCursorMoved", self)
        :addEventListener("EvtGridSelected",   self)
        :addEventListener("EvtTurnPhaseMain",  self)

    return self
end

function ModelTileInfo:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "ModelTileInfo:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")

    self.m_RootScriptEventDispatcher:removeEventListener("EvtTurnPhaseMain", self)
        :removeEventListener("EvtGridSelected",        self)
        :removeEventListener("EvtMapCursorMoved",      self)
        :removeEventListener("EvtModelTileMapUpdated", self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
function ModelTileInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtModelTileMapUpdated") then onEvtModelTileMapUpdated(self, event)
    elseif (eventName == "EvtMapCursorMoved")      then onEvtMapCursorMoved(     self, event)
    elseif (eventName == "EvtGridSelected")        then onEvtGridSelected(       self, event)
    elseif (eventName == "EvtTurnPhaseMain")       then onEvtTurnPhaseMain(      self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelTileInfo:onPlayerTouch()
    if (self.m_ModelTileDetail) then
        self.m_ModelTileDetail:updateWithModelTile(self.m_ModelTile, self.m_ModelPlayer)
            :setEnabled(true)
    end

    return self
end

return ModelTileInfo