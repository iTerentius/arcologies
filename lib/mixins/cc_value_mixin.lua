cc_value_mixin = {}

cc_value_mixin.init = function(self)

  self.setup_cc_value = function(self)
    self.cc_value_key = "CC VALUE"
    self.cc_value = 0
    self.cc_value_min = 0
    self.cc_value_max = 127
    self:register_save_key("cc_value")
    self:register_menu_getter(self.cc_value_key, self.cc_value_menu_getter)
    self:register_menu_setter(self.cc_value_key, self.cc_value_menu_setter)
    self:register_arc_style({
      key = self.cc_value_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.cc_value_min,
      max = self.cc_value_max,
      value_getter = self.get_cc_value,
      value_setter = self.set_cc_value
    })
    self:register_modulation_target({
      key = self.cc_value_key,
      inc = self.cc_value_increment,
      dec = self.cc_value_decrement
    })
  end

  self.cc_value_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_cc_value(self:get_cc_value() + value)
  end

  self.cc_value_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_cc_value(self:get_cc_value() - value)
  end

  self.get_cc_value = function(self)
    return self.cc_value
  end

  self.set_cc_value = function(self, i)
    self.cc_value = util.clamp(i, self.cc_value_min, self.cc_value_max)
    self.callback(self, "set_cc_value")
  end

  self.cc_value_menu_getter = function(self)
    return self:get_cc_value()
  end

  self.cc_value_menu_setter = function(self, i)
    self:set_cc_value(self.cc_value + i)
  end

end
