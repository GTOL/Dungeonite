--[[
  简单AI
  A simple Lua AI to demonstrate implementation of a simple AI for dota 2.
  By: Perry
  Date: August, 2015
]]--AI parameter constants
  --Modified by GTOL
AI_THINK_INTERVAL = 0.5 --//AI思考间隔时间

--AI 状态 constants
AI_STATE_AGGRESSIVE = 0--攻击阶段
AI_STATE_RETURNING = 1--返回阶段

--定义 SimpleAI 类
SimpleAI = {}
SimpleAI.__index = SimpleAI

function Spawn( keys )
	local unit = thisEntity
	SimpleAI:MakeInstance( unit, { spawnPos = unit:GetAbsOrigin(), aggroRange = 500, leashRange = 900 } )
end

--[[通过一些参数和单位创建一个SimpleAI类的实例  ]]
function SimpleAI:MakeInstance( unit, params )
  --构造一个实例  of the SimpleAI class
  local ai = {}
  setmetatable( ai, SimpleAI )

  --Set the core fields for this AI
  ai.unit = unit --这个AI控制的单位
  ai.state = AI_STATE_AGGRESSIVE --初始状态
  ai.stateThinks = { --加入每个思考阶段的函数
    [AI_STATE_AGGRESSIVE] = 'AggressiveThink',
    [AI_STATE_RETURNING] = 'ReturningThink'
  }

  --设置后面阶段可能要用到的参数
  ai.spawnPos = params.spawnPos
  ai.aggroRange = params.aggroRange
  ai.leashRange = params.leashRange

  --开始思考
  Timers:CreateTimer( ai.GlobalThink, ai )

  --Return the constructed instance
  return ai
end

--[[ 高优先级的计时器判断这个AI单位每跳要做的时, 选择正确的方法状态并执行. ]]
function SimpleAI:GlobalThink()
  --单位死了就停止AI
  if not self.unit:IsAlive() then
    return nil
  end

  --执行正确阶段的思考方法
  Dynamic_Wrap(SimpleAI, self.stateThinks[ self.state ])( self )

  --等待时间后继续调用这个方法
  return AI_THINK_INTERVAL
end

--[[ 积极状态的方法 ]]
function SimpleAI:AggressiveThink()
  --找到范围内可攻击的对象
  local units = FindUnitsInRadius( self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil,
    self.aggroRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
    FIND_CLOSEST, false )

  --如果找到很多units 那么攻击最近的一个
  if #units > 0 then
    self.unit:MoveToTargetToAttack( units[1] ) --开始攻击
	self.target = units[1]
  end
  
  if self.unit:CanEntityBeSeenByMyTeam( self.target ) == 0 then
    self.unit:MoveToPosition( self.spawnPos )
  end

  --检查自己是否超出了追击的最远距离
  if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() > self.leashRange then
    self.unit:MoveToPosition( self.spawnPos ) --回到出身点
    self.state = AI_STATE_RETURNING --转换到“返回”状态
    return true --通过返回来确保不再执行这个阶段的其他代码
  end

  --状态行为
  --这里我们可以做任何你想要在这个阶段重复做的行为
--  print('Attacking!')
end

--[[ 返回阶段的]]
function SimpleAI:ReturningThink()
  --检查UI单位时候已经回到了出身点
  if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() < 50 then
    self.unit:MoveToPosition( self.spawnPos )
    --跳转到待机状态
    self.state = AI_STATE_AGGRESSIVE
    return true
  else
    self.unit:MoveToPosition( self.spawnPos )
  end
  
end