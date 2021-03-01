package.path = package.path .. ";/lua/?.lua"
local gotify

local function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. tostring(v))
    end
  end
end

function otr_init()
    local status, _gotify = pcall(require, "gotify")
    if(status) then
        gotify = _gotify
    else
        print("Gotify Module loading failed")
    end
end

function otr_transition(topic, _type, data)
    t1 = ("no topic" or nil)
    t2 = ("no type" or nil)
    if (gotify) then
        tprint(data)
        m = "User " .. data['username'] .. " " .. data['event'] .. " " .. data['desc'] .. "."
        gotify.push_message("geofence", m)
    else
        tprint(data)
    end
end

function otr_exit()
    print("LUA: good bye\n")
end
