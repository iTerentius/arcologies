slew_mixin = {}

slew_mixin.init = function(self)

  self.setup_slew = function(self)
    self.slew_key = "SLEW"
    self.slew = 0
    self.slew_min = 0
    self.slew_max = 32
    self:register_save_key("slew")
    self:register_menu_getter(self.slew_key, self.slew_menu_getter)
    self:register_menu_setter(self.slew_key, self.slew_menu_setter)
    self:register_arc_style({
      key = self.slew_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .2,
      offset = 240,
      wrap = false,
      snap = true,
      min = self.slew_min,
      max = self.slew_max,
      value_getter = self.get_slew,
      value_setter = self.set_slew
    })
    self:register_modulation_target({
      key = self.slew_key,
      inc = self.slew_increment,
      dec = self.slew_decrement
    })
  end

  self.slew_increment = function(self, i)
    self:set_slew(self:get_slew() + (i ~= nil and i or 1))
  end

  self.slew_decrement = function(self, i)
    self:set_slew(self:get_slew() - (i ~= nil and i or 1))
  end

  self.get_slew = function(self) return self.slew end

  self.set_slew = function(self, i)
    self.slew = util.clamp(i, self.slew_min, self.slew_max)
    self.callback(self, "set_slew")
  end

  self.slew_menu_getter = function(self) return self:get_slew() end
  self.slew_menu_setter = function(self, i) self:set_slew(self.slew + i) end

end
