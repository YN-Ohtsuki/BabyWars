
--[[--------------------------------------------------------------------------------
-- AttackTaker是ModelUnit/ModelTile可用的组件。只有绑定了这个组件，才能受到攻击者（即绑定了AttackTaker的model）的攻击。
-- 主要职责：
--   维护宿主的生命值以及防御类型，提供接口给外界访问
-- 使用场景举例：
--   宿主初始化时，根据自身属性来绑定和初始化本组件（比如infantry需要绑定，plain不需要，meteor需要）
--   AttackTaker计算伤害值时，或CaptureDoer计算占领值时，需要通过本组件获取当前生命值
--   若生命值降为0，则本组件需要发送消息以通知ModelUnitMap/ModelTileMap删除对应的unit/tile
-- 其他：
--   - 所有种类的ModelUnit都必须绑定本组件，但ModelUnit里没有写死，而是由GameConstant决定
--   - 关于防御类型：老三代里pipe与mdtank的防御属性是相同的，所以抽象出防御类型来重用其属性表。
--     但dor里每个单位的防御类型都是独立的，所以防御类型实际上可以取消，直接用宿主的类型名字（如infantry，meteor）代替
--   - unit的hp上限实际上为100，但多数情况下（如攻击，占领）按10点来计算（换算关系：实际hp / 10 并向上取整）
--]]--------------------------------------------------------------------------------

local AttackTaker = require("src.global.functions.class")("AttackTaker")

local GameConstantFunctions = require("src.app.utilities.GameConstantFunctions")
local TypeChecker           = require("src.app.utilities.TypeChecker")
local ComponentManager      = require("src.global.components.ComponentManager")

local UNIT_MAX_HP = GameConstantFunctions.getUnitMaxHP()
local TILE_MAX_HP = GameConstantFunctions.getTileMaxHP()

AttackTaker.EXPORTED_METHODS = {
    "getCurrentHP",
    "setCurrentHP",
    "getNormalizedCurrentHP",

    "getDefenseType",
    "getDefenseFatalList",
    "getDefenseWeakList",
    "isAffectedByLuck",
}

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function AttackTaker:ctor(param)
    self:loadTemplate(param.template)
        :loadInstantialData(param.instantialData)

    return self
end

function AttackTaker:loadTemplate(template)
    assert(template.maxHP ~= nil,            "AttackTaker:loadTemplate() the param template.maxHP is invalid.")
    assert(template.defenseType ~= nil,      "AttackTaker:loadTemplate() the param template.defenseType is invalid.")
    assert(template.isAffectedByLuck ~= nil, "AttackTaker:loadTemplate() the param template.isAffectedByLuck is invalid.")

    self.m_Template = template

    return self
end

function AttackTaker:loadInstantialData(data)
    assert(data.currentHP <= self:getMaxHP(), "AttackTaker:loadInstantialData() the param data.currentHP is invalid.")
    self.m_CurrentHP = data.currentHP

    return self
end

function AttackTaker:setRootScriptEventDispatcher(dispatcher)
    assert(self.m_RootScriptEventDispatcher == nil, "AttackTaker:setRootScriptEventDispatcher() the dispatcher has been set.")
    self.m_RootScriptEventDispatcher = dispatcher

    return self
end

function AttackTaker:unsetRootScriptEventDispatcher()
    assert(self.m_RootScriptEventDispatcher, "AttackTaker:unsetRootScriptEventDispatcher() the dispatcher hasn't been set.")
    self.m_RootScriptEventDispatcher = nil

    return self
end

function AttackTaker:setModelPlayerManager(model)
    assert(self.m_ModelPlayerManager == nil, "AttackTaker:setModelPlayerManager() the model has been set.")
    self.m_ModelPlayerManager = model

    return self
end

--------------------------------------------------------------------------------
-- The function for serialization.
--------------------------------------------------------------------------------
function AttackTaker:toSerializableTable()
    local currentHP = self:getCurrentHP()
    if (currentHP == self:getMaxHP()) then
        return nil
    else
        return {
            currentHP = currentHP,
        }
    end
end

--------------------------------------------------------------------------------
-- The functions for doing the actions.
--------------------------------------------------------------------------------
function AttackTaker:doActionAttack(action, attackTarget)
    self        :setCurrentHP(math.max(0, self:getCurrentHP() - (action.counterDamage or 0)))
    attackTarget:setCurrentHP(math.max(0, attackTarget:getCurrentHP() - action.attackDamage))

    return self.m_Owner
end

function AttackTaker:canJoinModelUnit(modelUnit)
    return modelUnit:getNormalizedCurrentHP() < 10
end

function AttackTaker:doActionJoinModelUnit(action, modelPlayerManager, target)
    local joinedNormalizedHP = self:getNormalizedCurrentHP() + target:getNormalizedCurrentHP()
    if (joinedNormalizedHP > 10) then
        local owner       = self.m_Owner
        local playerIndex = owner:getPlayerIndex()
        local modelPlayer = modelPlayerManager:getModelPlayer(playerIndex)
        modelPlayer:setFund(modelPlayer:getFund() + (joinedNormalizedHP - 10) / 10 * owner:getProductionCost())
        joinedNormalizedHP = 10

        self.m_RootScriptEventDispatcher:dispatchEvent({
            name        = "EvtModelPlayerUpdated",
            modelPlayer = modelPlayer,
            playerIndex = playerIndex,
        })
    end

    target:setCurrentHP(math.max(
        (joinedNormalizedHP - 1) * 10 + 1,
        math.min(
            self:getCurrentHP() + target:getCurrentHP(),
            UNIT_MAX_HP
        )
    ))

    return self
end

--------------------------------------------------------------------------------
-- The exported functions.
--------------------------------------------------------------------------------
function AttackTaker:getMaxHP()
    return self.m_Template.maxHP
end

function AttackTaker:getCurrentHP()
    return self.m_CurrentHP
end

function AttackTaker:setCurrentHP(hp)
    assert((hp >= 0) and (hp <= math.max(UNIT_MAX_HP, TILE_MAX_HP)) and (hp == math.floor(hp)), "AttackTaker:setCurrentHP() the param hp is invalid.")
    self.m_CurrentHP = hp

    return self.m_Owner
end

function AttackTaker:getNormalizedCurrentHP()
    return math.ceil(self.m_CurrentHP / 10)
end

function AttackTaker:getDefenseType()
    return self.m_Template.defenseType
end

function AttackTaker:isAffectedByLuck()
    return self.m_Template.isAffectedByLuck
end

function AttackTaker:getDefenseFatalList()
    return self.m_Template.fatal
end

function AttackTaker:getDefenseWeakList()
    return self.m_Template.weak
end

return AttackTaker
