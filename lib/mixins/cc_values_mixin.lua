cc_values_mixin = {}

cc_values_mixin.init = function(self)

  self.setup_cc_values = function(self, count)
    self.cc_value_count_key = "CC COUNT"
    self.cc_value_count = (count == nil) and 1 or count
    self.cc_value_count_min = 1
    self.cc_value_count_max = 8
    for i = 1, 8 do
      self["cc_val_" .. i .. "_key"] = "CC VALUE #" .. i
    end
    self.cc_values = {}
    self:register_save_key("cc_values")
    self:register_save_key("cc_value_count")
    for i = 1, 8 do self.cc_values[i] = 64 end

    self:register_menu_getter(self.cc_value_count_key, self.cc_value_count_menu_getter)
    self:register_menu_setter(self.cc_value_count_key, self.cc_value_count_menu_setter)
    self:register_arc_style({
      key = self.cc_value_count_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = true,
      min = self.cc_value_count_min,
      max = self.cc_value_count_max,
      value_getter = self.get_cc_value_count,
      value_setter = self.set_cc_value_count
    })
    self:register_modulation_target({
      key = self.cc_value_count_key,
      inc = self.cc_value_count_increment,
      dec = self.cc_value_count_decrement
    })

    for i = 1, 8 do
      local idx = i
      self:register_menu_getter(self["cc_val_" .. i .. "_key"], self["cc_val_" .. i .. "_menu_getter"])
      self:register_menu_setter(self["cc_val_" .. i .. "_key"], self["cc_val_" .. i .. "_menu_setter"])
      self:register_arc_style({
        key = "CC VALUE #" .. idx,
        style_getter = function() return "glowing_segment" end,
        style_max_getter = function() return 240 end,
        sensitivity = .5,
        offset = 240,
        wrap = false,
        snap = false,
        min = 0,
        max = 127,
        value_getter = self["get_cc_val_" .. idx],
        value_setter = self["set_cc_val_" .. idx]
      })
      self:register_modulation_target({
        key = "CC VALUE #" .. idx,
        inc = self["cc_val_" .. idx .. "_increment"],
        dec = self["cc_val_" .. idx .. "_decrement"]
      })
    end
  end

  self.cc_value_count_increment = function(self, i)
    self:set_cc_value_count(self:get_cc_value_count() + (i ~= nil and i or 1))
  end

  self.cc_value_count_decrement = function(self, i)
    self:set_cc_value_count(self:get_cc_value_count() - (i ~= nil and i or 1))
  end

  self.get_cc_value_count = function(self) return self.cc_value_count end

  self.set_cc_value_count = function(self, i)
    self.cc_value_count = util.clamp(i, self.cc_value_count_min, self.cc_value_count_max)
    self.callback(self, "set_cc_value_count")
  end

  self.cc_value_count_menu_getter = function(self) return self:get_cc_value_count() end
  self.cc_value_count_menu_setter = function(self, i) self:set_cc_value_count(self.cc_value_count + i) end

  for i = 1, 8 do
    local idx = i
    self["get_cc_val_" .. i]  = function(self) return self.cc_values[idx] end
    self["set_cc_val_" .. i]  = function(self, v) self.cc_values[idx] = util.clamp(v, 0, 127) end
    self["cc_val_" .. i .. "_increment"] = function(self, d) self.cc_values[idx] = util.clamp(self.cc_values[idx] + (d ~= nil and d or 1), 0, 127) end
    self["cc_val_" .. i .. "_decrement"] = function(self, d) self.cc_values[idx] = util.clamp(self.cc_values[idx] - (d ~= nil and d or 1), 0, 127) end
    self["cc_val_" .. i .. "_menu_getter"] = function(self)
      local prefix = (self.state_index == idx and self.cc_value_count > 1) and "> " or ""
      return prefix .. (self.cc_values[idx] or 0)
    end
    self["cc_val_" .. i .. "_menu_setter"] = function(self, delta)
      self.cc_values[idx] = util.clamp((self.cc_values[idx] or 64) + delta, 0, 127)
    end
  end

  self.inject_cc_values_into_menu = function(self, items)
    if self:has("CC VALUES") then
      local pos = fn.table_find(items, "CC VALUES")
      if type(pos) == "number" then
        table.remove(items, pos)
        for i = 1, self.cc_value_count do
          table.insert(items, pos + (i - 1), "CC VALUE #" .. i)
        end
      end
    end
    return items
  end

end
