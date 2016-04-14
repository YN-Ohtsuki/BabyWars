
local ModelMapCursor = class("ModelMapCursor")

local GridIndexFunctions = require("app.utilities.GridIndexFunctions")
local ComponentManager   = require("global.components.ComponentManager")

local DRAG_FIELD_TRIGGER_DISTANCE_SQUARED = 400

--------------------------------------------------------------------------------
-- The callback functions on EvtPlayerPreviewAttackTarget/EvtPlayerPreviewNoAttackTarget.
--------------------------------------------------------------------------------
local function onEvtPlayerPreviewAttackTarget(self, event)
    if (self.m_View) then
        self.m_View:setNormalCursorVisible(false)
            :setTargetCursorVisible(true)
    end
end

local function onEvtPlayerPreviewNoAttackTarget(self, event)
    if (self.m_View) then
        self.m_View:setNormalCursorVisible(true)
            :setTargetCursorVisible(false)
    end
end

--------------------------------------------------------------------------------
-- The touch/scroll event listeners.
--------------------------------------------------------------------------------
local function createTouchListener(model)
    local isTouchMoved, isTouchingCursor
    local initialTouchPosition, initialTouchGridIndex
    local touchListener = cc.EventListenerTouchOneByOne:create()

    local function onTouchBegan(touch, event)
        isTouchMoved = false
        initialTouchPosition = touch:getLocation()
        initialTouchGridIndex = GridIndexFunctions.worldPosToGridIndexInNode(initialTouchPosition, model.m_View)
        isTouchingCursor = GridIndexFunctions.isEqual(initialTouchGridIndex, model:getGridIndex())

        touchListener:setSwallowTouches(isTouchingCursor)

        return true
    end

    local function onTouchMoved(touch, event)
        isTouchMoved = (isTouchMoved) or (cc.pDistanceSQ(touch:getLocation(), initialTouchPosition) > DRAG_FIELD_TRIGGER_DISTANCE_SQUARED)

        if (isTouchingCursor) then
            local gridIndex = GridIndexFunctions.worldPosToGridIndexInNode(touch:getLocation(), model.m_View)
            if (GridIndexFunctions.isWithinMap(gridIndex, model.m_MapSize)) and
               (not GridIndexFunctions.isEqual(gridIndex, model:getGridIndex())) then
                model:setGridIndex(gridIndex)
                model.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerMovedCursor", gridIndex = gridIndex})
                isTouchMoved = true
            end
        else
            if (isTouchMoved) then
                model.m_RootScriptEventDispatcher:dispatchEvent({
                    name             = "EvtPlayerDragField",
                    previousPosition = touch:getPreviousLocation(),
                    currentPosition  = touch:getLocation()
                })
            end
        end
    end

    local function onTouchCancelled(touch, event)
    end

    local function onTouchEnded(touch, event)
        local gridIndex = GridIndexFunctions.worldPosToGridIndexInNode(touch:getLocation(), model.m_View)
        if (not GridIndexFunctions.isWithinMap(gridIndex, model.m_MapSize)) then
            return
        end

        if ((not isTouchMoved) or (isTouchingCursor)) and
           (not GridIndexFunctions.isEqual(model:getGridIndex(), gridIndex)) then
            model:setGridIndex(gridIndex)
            model.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerMovedCursor", gridIndex = gridIndex})
        end

        if (not isTouchMoved) then
            model.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerSelectedGrid", gridIndex = gridIndex})
        end
    end

    touchListener:registerScriptHandler(onTouchBegan,     cc.Handler.EVENT_TOUCH_BEGAN)
    touchListener:registerScriptHandler(onTouchMoved,     cc.Handler.EVENT_TOUCH_MOVED)
    touchListener:registerScriptHandler(onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
    touchListener:registerScriptHandler(onTouchEnded,     cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

local function createMouseListener(model)
    local function onMouseScroll(event)
        model.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerZoomField", scrollEvent = event})
    end

    local mouseListener = cc.EventListenerMouse:create()
    mouseListener:registerScriptHandler(onMouseScroll, cc.Handler.EVENT_MOUSE_SCROLL)

    return mouseListener
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelMapCursor:ctor(param)
    if (not ComponentManager:getComponent(self, "GridIndexable")) then
        ComponentManager.bindComponent(self, "GridIndexable", {instantialData = {gridIndex = param.gridIndex or {x = 1, y = 1}}})
    end

    assert(param.mapSize, "ModelMapCursor:ctor() param.mapSize expected.")
    self:setMapSize(param.mapSize)

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelMapCursor:initView()
    local view = self.m_View
    assert(view, "ModelMapCursor:initView() no view is attached to the owner actor of the model.")

    self:setViewPositionWithGridIndex()
    view:setTouchListener(createTouchListener(self))
        :setMouseListener(createMouseListener(self))

        :setNormalCursorVisible(true)
        :setTargetCursorVisible(false)

    return self
end

function ModelMapCursor:setMapSize(size)
    self.m_MapSize = self.m_MapSize or {}
    self.m_MapSize.width  = size.width
    self.m_MapSize.height = size.height

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on node/script events.
--------------------------------------------------------------------------------
function ModelMapCursor:onEnter(rootActor)
    self.m_RootScriptEventDispatcher = rootActor:getModel():getScriptEventDispatcher()
    self.m_RootScriptEventDispatcher:dispatchEvent({name = "EvtPlayerMovedCursor", gridIndex = self:getGridIndex()})
        :addEventListener("EvtPlayerPreviewAttackTarget",   self)
        :addEventListener("EvtPlayerPreviewNoAttackTarget", self)
        :addEventListener("EvtActionPlannerIdle",           self)
        :addEventListener("EvtActionPlannerMakingMovePath", self)
        :addEventListener("EvtActionPlannerChoosingAction", self)

    return self
end

function ModelMapCursor:onCleanup(rootActor)
    self.m_RootScriptEventDispatcher:removeEventListener("EvtActionPlannerChoosingAction", self)
        :removeEventListener("EvtActionPlannerMakingMovePath", self)
        :removeEventListener("EvtActionPlannerIdle",           self)
        :removeEventListener("EvtPlayerPreviewNoAttackTarget", self)
        :removeEventListener("EvtPlayerPreviewAttackTarget",   self)
    self.m_RootScriptEventDispatcher = nil

    return self
end

function ModelMapCursor:onEvent(event)
    local eventName = event.name
    if ((eventName == "EvtActionPlannerIdle") or
        (eventName == "EvtActionPlannerMakingMovePath") or
        (eventName == "EvtActionPlannerChoosingAction") or
        (eventName == "EvtPlayerPreviewNoAttackTarget")) then
        onEvtPlayerPreviewNoAttackTarget(self, event)
    elseif (eventName == "EvtPlayerPreviewAttackTarget") then
        onEvtPlayerPreviewAttackTarget(self, event)
    end

    return self
end

return ModelMapCursor
