_osc = {}

-- Target IP and port are set from Norns params (BEACON / OSC section).
-- Default is loopback; params:bang() in parameters.init() overwrites with
-- saved values before any BEACON cell can fire.
_osc.target = {"127.0.0.1", 57120}

function _osc.init()
  print("_osc: loaded")
end

-- Send /arc/trigger with integer id.
-- SC side: OSCdef(\name, { |msg| var id = msg[3]; ... }, "/arc/trigger")
function _osc:trigger(id)
  osc.send(self.target, "/arc/trigger", {id})
end

return _osc
