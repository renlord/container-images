-- Gotify LUA plugin for pushing gotify messages
--
-- LUA_GOTIFY_URL

local cURL = require "cURL"
local gotify = {}

local GOTIFY_URL=os.getenv("LUA_GOTIFY_URL")
local GOTIFY_TOKEN=os.getenv("LUA_GOTIFY_TOKEN")

local function isempty(s)
  return s == nil or s == ''
end

if isempty(GOTIFY_URL) then
    error("GOTIFY_URL not populated")
end
if isempty(GOTIFY_TOKEN) then
    error("GOTIFY_TOKEN not populated")
end

function gotify.push_message(title, message)
    c = cURL.easy{
      url        = GOTIFY_URL .. "/message?token=" .. GOTIFY_TOKEN,
      post       = true,
      httpheader = {
        "Content-Type: application/json";
      };
      postfields = '{\
        "title": "'..title..'",\
        "message": "' .. message .. '",\
        "priority": 5\
      }';
    }
    c:perform()
end

return gotify
