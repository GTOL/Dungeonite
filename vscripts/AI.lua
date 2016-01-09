--[[
  ��AI
  A simple Lua AI to demonstrate implementation of a simple AI for dota 2.
  By: Perry
  Date: August, 2015
]]--AI parameter constants
AI_THINK_INTERVAL = 0.5 --//AI˼�����ʱ��

--AI ״̬ constants
AI_STATE_IDLE = 0--�����׶�
AI_STATE_AGGRESSIVE = 1--�����׶�
AI_STATE_RETURNING = 2--���ؽ׶�

--���� SimpleAI ��
SimpleAI = {}
SimpleAI.__index = SimpleAI

--[[ͨ��һЩ�����͵�λ����һ��SimpleAI���ʵ��  ]]
function SimpleAI:MakeInstance( unit, params )
  --����һ��ʵ��  of the SimpleAI class
  local ai = {}
  setmetatable( ai, SimpleAI )

  --Set the core fields for this AI
  ai.unit = unit --���AI���Ƶĵ�λ
  ai.state = AI_STATE_IDLE --��ʼ״̬
  ai.stateThinks = { --����ÿ��˼���׶εĺ���
    [AI_STATE_IDLE] = 'IdleThink',
    [AI_STATE_AGGRESSIVE] = 'AggressiveThink',
    [AI_STATE_RETURNING] = 'ReturningThink'
  }

  --���ú���׶ο���Ҫ�õ��Ĳ���
  ai.spawnPos = params.spawnPos
  ai.aggroRange = params.aggroRange
  ai.leashRange = params.leashRange

  --��ʼ˼��
  Timers:CreateTimer( ai.GlobalThink, ai )

  --Return the constructed instance
  return ai
end

--[[ �����ȼ��ļ�ʱ���ж����AI��λÿ��Ҫ����ʱ, ѡ����ȷ�ķ���״̬��ִ��. ]]
function SimpleAI:GlobalThink()
  --��λ���˾�ֹͣAI
  if not self.unit:IsAlive() then
    return nil
  end

  --ִ����ȷ�׶ε�˼������
  Dynamic_Wrap(SimpleAI, self.stateThinks[ self.state ])( self )

  --�ȴ�ʱ�����������������
  return AI_THINK_INTERVAL
end

--[[ Idle״̬�ķ���]]
function SimpleAI:IdleThink()
  if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() > self.leashRange then
    self.unit:MoveToPosition( self.spawnPos )
    --��ת������״̬
  end
  --�ҵ���Χ�ڿɹ����Ķ���
  local units = FindUnitsInRadius( self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil,
    self.aggroRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
    FIND_ANY_ORDER, false )

  --����ҵ��ܶ�units ��ô������һ��
  if #units > 0 then
    self.unit:MoveToTargetToAttack( units[1] ) --��ʼ����
    self.aggroTarget = units[1]
    self.state = AI_STATE_AGGRESSIVE --��������׶�
    return true
  end

  --State behavior
  --Whistle a tune
end

--[[ ����״̬�ķ��� ]]
function SimpleAI:AggressiveThink()
  --����Լ��Ƿ񳬳���׷������Զ����
  if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() > self.leashRange then
    self.unit:MoveToPosition( self.spawnPos ) --�ص������
    self.state = AI_STATE_RETURNING --ת���������ء�״̬
    return true --ͨ��������ȷ������ִ������׶ε���������
  end

  --��鹥���ĵ�λ�Ƿ񻹻��� (self.������λ �ᱻ�趨��ת�������׶ε�ʱ��)
  if not self.aggroTarget:IsAlive() then
    self.unit:MoveToPosition( self.spawnPos ) --���س�����
    self.state = AI_STATE_RETURNING --ת�������ؽ׶�
    return true --ͨ��������ȷ������ִ������׶ε���������
  end

  --״̬��Ϊ
  --�������ǿ������κ�����Ҫ������׶��ظ�������Ϊ
--  print('Attacking!')
end

--[[ ���ؽ׶ε�]]
function SimpleAI:ReturningThink()
  --���UI��λʱ���Ѿ��ص��˳����
  if ( self.spawnPos - self.unit:GetAbsOrigin() ):Length() < 50 then
    self.unit:MoveToPosition( self.spawnPos )
    --��ת������״̬
    self.state = AI_STATE_IDLE
    return true
  end
end