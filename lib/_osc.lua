_osc = {}

-- Target IP and port are set from Norns params (BEACON / OSC section).
-- Default is loopback; params:bang() in parameters.init() overwrites with
-- saved values before any BEACON cell can fire.
_osc.target = {"127.0.0.1", 57120}

function _osc.init()
  print("_osc: loaded")
end

-- Send /arc/trigger with integer id and retrigger cooldown (beats, 0 = immediate).
-- SC side: msg[1]=id, msg[2]=retrigger
function _osc:trigger(id, retrigger)
  local r = retrigger or 0
  local ok, err = pcall(function()
    osc.send(self.target, "/arc/trigger", {id, r})
  end)
  if not ok then print("_osc: trigger error: " .. tostring(err)) end
end

function _osc:start()
  local ok, err = pcall(function()
    osc.send(self.target, "/arc/start", {})
  end)
  if not ok then print("_osc: start error: " .. tostring(err)) end
end

function _osc:stop()
  local ok, err = pcall(function()
    osc.send(self.target, "/arc/stop", {})
  end)
  if not ok then print("_osc: stop error: " .. tostring(err)) end
end

return _osc
