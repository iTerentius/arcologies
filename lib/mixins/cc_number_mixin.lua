cc_number_mixin = {}

cc_number_mixin.init = function(self)

  self.setup_cc_number = function(self)
    self.cc_number_key = "CC NUMBER"
    self.cc_number = 0
    self.cc_number_min = 0
    self.cc_number_max = 127
    self:register_save_key("cc_number")
    self:register_menu_getter(self.cc_number_key, self.cc_number_menu_getter)
    self:register_menu_setter(self.cc_number_key, self.cc_number_menu_setter)
    self:register_arc_style({
      key = self.cc_number_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = true,
      min = self.cc_number_min,
      max = self.cc_number_max,
      value_getter = self.get_cc_number,
      value_setter = self.set_cc_number
    })
    self:register_modulation_target({
      key = self.cc_number_key,
      inc = self.cc_number_increment,
      dec = self.cc_number_decrement
    })
  end

  self.cc_number_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_cc_number(self:get_cc_number() + value)
  end

  self.cc_number_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_cc_number(self:get_cc_number() - value)
  end

  self.get_cc_number = function(self)
    return self.cc_number
  end

  self.set_cc_number = function(self, i)
    self.cc_number = util.clamp(i, self.cc_number_min, self.cc_number_max)
    self.callback(self, "set_cc_number")
  end

  self.cc_number_menu_getter = function(self)
    return self:get_cc_number()
  end

  self.cc_number_menu_setter = function(self, i)
    self:set_cc_number(self.cc_number + i)
  end

end
