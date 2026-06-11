osc_id_mixin = {}

osc_id_mixin.init = function(self)

  self.setup_osc_id = function(self)
    self.osc_id_key = "ID"
    self.osc_id = 1
    self.osc_id_min = 1
    self.osc_id_max = 99
    self:register_save_key("osc_id")
    self:register_menu_getter(self.osc_id_key, self.osc_id_menu_getter)
    self:register_menu_setter(self.osc_id_key, self.osc_id_menu_setter)
    self:register_arc_style({
      key = self.osc_id_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = true,
      min = self.osc_id_min,
      max = self.osc_id_max,
      value_getter = self.get_osc_id,
      value_setter = self.set_osc_id
    })
    self:register_modulation_target({
      key = self.osc_id_key,
      inc = self.osc_id_increment,
      dec = self.osc_id_decrement
    })
    self:setup_osc_retrigger()
    self:setup_osc_mode()
  end

  self.setup_osc_retrigger = function(self)
    self.osc_retrigger_key = "RETRIG"
    self.osc_retrigger = 0
    self.osc_retrigger_min = 0
    self.osc_retrigger_max = 16
    self:register_save_key("osc_retrigger")
    self:register_menu_getter(self.osc_retrigger_key, self.osc_retrigger_menu_getter)
    self:register_menu_setter(self.osc_retrigger_key, self.osc_retrigger_menu_setter)
    self:register_arc_style({
      key = self.osc_retrigger_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 0,
      wrap = false,
      snap = true,
      min = self.osc_retrigger_min,
      max = self.osc_retrigger_max,
      value_getter = self.get_osc_retrigger,
      value_setter = self.set_osc_retrigger
    })
    self:register_modulation_target({
      key = self.osc_retrigger_key,
      inc = self.osc_retrigger_increment,
      dec = self.osc_retrigger_decrement
    })
  end

  self.osc_id_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_osc_id(self:get_osc_id() + value)
  end

  self.osc_id_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_osc_id(self:get_osc_id() - value)
  end

  self.get_osc_id = function(self)
    return self.osc_id
  end

  self.set_osc_id = function(self, i)
    self.osc_id = util.clamp(i, self.osc_id_min, self.osc_id_max)
    self.callback(self, "set_osc_id")
  end

  self.osc_id_menu_getter = function(self)
    return self:get_osc_id()
  end

  self.osc_id_menu_setter = function(self, i)
    self:set_osc_id(self.osc_id + i)
  end

  self.osc_retrigger_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_osc_retrigger(self:get_osc_retrigger() + value)
  end

  self.osc_retrigger_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_osc_retrigger(self:get_osc_retrigger() - value)
  end

  self.get_osc_retrigger = function(self)
    return self.osc_retrigger
  end

  self.set_osc_retrigger = function(self, i)
    self.osc_retrigger = util.clamp(i, self.osc_retrigger_min, self.osc_retrigger_max)
    self.callback(self, "set_osc_retrigger")
  end

  self.osc_retrigger_menu_getter = function(self)
    return self:get_osc_retrigger()
  end

  self.osc_retrigger_menu_setter = function(self, i)
    self:set_osc_retrigger(self.osc_retrigger + i)
  end

  self.setup_osc_mode = function(self)
    self.osc_mode_key = "MODE"
    self.osc_mode = 0
    self.osc_mode_min = 0
    self.osc_mode_max = 2
    self.osc_mode_names = {"SHOT", "TOGL", "PLAY"}
    self:register_save_key("osc_mode")
    self:register_menu_getter(self.osc_mode_key, self.osc_mode_menu_getter)
    self:register_menu_setter(self.osc_mode_key, self.osc_mode_menu_setter)
    self:register_arc_style({
      key = self.osc_mode_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = 1.0,
      offset = 0,
      wrap = false,
      snap = true,
      min = self.osc_mode_min,
      max = self.osc_mode_max,
      value_getter = self.get_osc_mode,
      value_setter = self.set_osc_mode
    })
    self:register_modulation_target({
      key = self.osc_mode_key,
      inc = self.osc_mode_increment,
      dec = self.osc_mode_decrement
    })
  end

  self.osc_mode_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_osc_mode(self:get_osc_mode() + value)
  end

  self.osc_mode_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_osc_mode(self:get_osc_mode() - value)
  end

  self.get_osc_mode = function(self)
    return self.osc_mode
  end

  self.set_osc_mode = function(self, i)
    self.osc_mode = util.clamp(i, self.osc_mode_min, self.osc_mode_max)
    self.callback(self, "set_osc_mode")
  end

  self.osc_mode_menu_getter = function(self)
    return self.osc_mode_names[self.osc_mode + 1]
  end

  self.osc_mode_menu_setter = function(self, i)
    self:set_osc_mode(self.osc_mode + i)
  end

end
