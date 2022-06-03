-- Information block for the plugin
--[[ #include "src/info.lua" ]]

-- Define the color of the plugin object in the design
function GetColor(props)
  return {51, 51, 51}
end

-- The name that will initially display when dragged into a design
function GetPrettyName(props)
  return ('TAG\nUCI Layer Controller\n[%s]'):format(PluginInfo.Version)
end

-- Define User configurable Properties of the plugin
function GetProperties()
  local props = {}
  --[[ #include "src/properties.lua" ]]
  return props
end

-- Defines the Controls used within the plugin
function GetControls(props)
  local ctrls = {}
  --[[ #include "src/controls.lua" ]]
  return ctrls
end

--Layout of controls and graphics for the plugin UI to display
function GetControlLayout(props)
  local layout = {}
  local graphics = {}
  --[[ #include "src/layout.lua" ]]
  return layout, graphics
end

--Start event based logic
if Controls then
  --[[ #include "src/runtime.lua" ]]
end
