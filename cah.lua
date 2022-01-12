function TeamAILogicIdle.is_valid_intimidation_target(unit, unit_tweak, unit_anim, unit_damage, data, distance)
  if UsefulBots.settings.dominate_enemies > 2 then
    return false
  end
  if unit:unit_data().disable_shout then
    return false
  end
  if not unit_tweak.surrender or unit_tweak.surrender == tweak_data.character.presets.surrender.special or unit_anim.hands_tied then
    return false
  end
  if distance > tweak_data.player.long_dis_interaction.intimidate_range_enemies then
    return false
  end
  if unit_anim.hands_back or unit_anim.surrender then
    return true
  end
  if UsefulBots.settings.dominate_enemies > 1 then
    return false
  end
  if not managers.groupai:state():has_room_for_police_hostage() then
    return false
  end
  local health_max = 0
  for k, _ in pairs(unit_tweak.surrender.reasons and unit_tweak.surrender.reasons.health or {}) do
    health_max = k > health_max and k or health_max
  end
  if unit_damage:health_ratio() > health_max / 5 then
    return false
  end
  local resist = TeamAILogicIdle._intimidate_resist[unit:key()]
  if resist and resist > 1 then
    return false
  end
  local num = 0
  local max = 1 + table.count(managers.groupai:state():all_char_criminals(), function (u_data) return u_data == "dead" end) * 2
  local m_pos = data.unit:movement():m_pos()
  local dist_sq = tweak_data.player.long_dis_interaction.intimidate_range_enemies * tweak_data.player.long_dis_interaction.intimidate_range_enemies * 4
  local u_damage, u_movement
  for _, v in pairs(data.detected_attention_objects) do
    u_damage = v.unit and v.unit.character_damage and v.unit:character_damage()
    u_movement = v.unit and v.unit.movement and v.unit:movement()
    if v.verified and v.unit ~= unit and u_damage and not u_damage:dead() and u_movement and mvector3.distance_sq(u_movement:m_pos(), m_pos) < dist_sq then
      num = num + 1
      if num > max then
        return false
      end
    end
  end
  return true
end