
local AttackDoer = class("AttackDoer")

local TypeChecker        = require("app.utilities.TypeChecker")
local ComponentManager   = require("global.components.ComponentManager")

local EXPORTED_METHODS = {
    "hasPrimaryWeapon",
    "getPrimaryWeaponName",
    "getPrimaryWeaponCurrentAmmo",
}

local function initPrimaryWeapon(doer, param)
    if (doer.m_PrimaryWeapon) then
        doer.m_PrimaryWeapon.m_CurrentAmmo = param.currentAmmo
    else
        doer.m_PrimaryWeapon = {}

        local weapon = doer.m_PrimaryWeapon
        weapon.m_Template    = param
        weapon.m_CurrentAmmo = param.maxAmmo
    end
end

local function initSecondaryWeapon(doer, param)
    if (not doer.m_SecondaryWeapon) then
        doer.m_SecondaryWeapon = {}

        local weapon = doer.m_SecondaryWeapon
        weapon.m_Template = param
    end
end

function AttackDoer:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function AttackDoer:load(param)
    if (param.primaryWeapon) then
        initPrimaryWeapon(self, param.primaryWeapon)
    end
    if (param.secondaryWeapon) then
        initSecondaryWeapon(self, param.secondaryWeapon)
    end

    return self
end

function AttackDoer:bind(target)
	ComponentManager.setMethods(target, self, EXPORTED_METHODS)

	self.m_Target = target
end

function AttackDoer:unbind(target)
    assert(self.m_Target == target , "AttackDoer:unbind() the component is not bind to the param target.")
    assert(self.m_Target, "AttackDoer:unbind() the component is not bind to any target.")

    ComponentManager.unsetMethods(self.m_Target, EXPORTED_METHODS)
    self.m_Target = nil
end

function AttackDoer:hasPrimaryWeapon()
    return self.m_PrimaryWeapon ~= nil
end

function AttackDoer:getPrimaryWeaponCurrentAmmo()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponCurrentAmmo() the attack doer has no primary weapon.")
    return self.m_PrimaryWeapon.m_CurrentAmmo
end

function AttackDoer:getPrimaryWeaponName()
    assert(self:hasPrimaryWeapon(), "AttackDoer:getPrimaryWeaponCurrentAmmo() the attack doer has no primary weapon.")
    return self.m_PrimaryWeapon.m_Template.name
end

return AttackDoer
