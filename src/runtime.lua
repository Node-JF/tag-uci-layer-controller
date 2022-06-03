rapidjson = require("rapidjson")

Transitions = {"none", "fade", "left", "right", "bottom", "top"}

function Initialize()
    GetUCIs()
end

function ResetPageList()
    Controls["page.name"].String = rapidjson.encode({["Text"] = "Select a Page", ["Color"] = "Blue", ["Layers"] = {}})
end

function UpdateAll()
  UpdateLayers()
  if (not config) or (rapidjson.encode(config) == '{}') then; return print('[UCI not Configured Yet]') end
  for layer, ctl in ipairs(Controls['layer.show']) do
    ShowLayers(layer, ctl.Boolean)
  end
end

function GetLayers()
    local all_layers = {""}
    local page = rapidjson.decode(Controls["page.name"].String)
    if (not page) then return print('[Page not Set]') end
    for i, tbl in pairs(page.Layers) do
        table.insert(all_layers, tbl.Text)
    end
    return all_layers
end

function Validate(layers, layer_to_validate)
    for _, existing_layer in ipairs(layers) do
        if (layer_to_validate == existing_layer) then
            return true
        end
    end
end

function ValidateLayerName(i, all_layers)
    --validate configured layers against all layers
    Controls["layer.name"][i].Color =
    (Controls["layer.name"][i].String == "") and "" or
    (Validate(all_layers, Controls["layer.name"][i].String) and "" or "Red")
end

function ValidateParent(i, all_layers)
    --validate configured layers against all layers
    Controls["layer.parent"][i].Color =
    (Controls["layer.parent"][i].String == "") and "" or
    (Validate(all_layers, Controls["layer.parent"][i].String) and "" or "Red")
end

function LayerIsUnavailable(layer_to_check, row)
    for i = 1, Properties["# Layers"].Value do
        if (Controls["layer.name"][i].String == layer_to_check) then
            print(("\tLayer [%s] is Configured - Removing from Available Layers List"):format(layer_to_check))
            return true
        end
    end
end

function ConfigureParentChoices(i, all_layers)
    -- populate the parents table with all layers except the configured layer for this row
    local parents = {}
    for _, layer in ipairs(all_layers) do
      if (layer ~= Controls["layer.name"][i].String) or (layer == "") then
        table.insert(parents, layer)
      end
    end
    
    -- clear the parent if it matches the configured layer
    if (Controls["layer.parent"][i].String ~= "") and (Controls["layer.parent"][i].String == Controls["layer.name"][i].String) then
      Controls["layer.parent"][i].String = ""
      print(("\tParent Cleared; Row [%d] - Layer Cannot be Own Parent"):format(i))
    end
    
    Controls["layer.parent"][i].Choices = parents
end

function PopulateChildList(i)
    
    local parent = Controls["layer.parent"][i].String
    local child = Controls["layer.name"][i].String
    
    if (parent == "") or (child == "") then return end
    
    if (not config[parent]) then return print(('Parent [%s] is Not Configured as Layer - Cannot add Child [%s] to this Parent'):format(parent, child)) end
    
    -- add child entry
    table.insert(config[parent].Children, {['Name'] = child, ['Index'] = i})

end

function GetUCIs()
    local uci_list = {}

    -- extract uci name and page/layer information - store page/layer in choices
    for key, tbl in pairs(rapidjson.decode(io.open("design/ucis.json", "r"):read("*a")).Ucis) do
        table.insert(
            uci_list,
            {
                ["Text"] = tbl.Name,
                ["Pages"] = tbl.Pages
            }
        )
    end

    -- default selection prompt on first launch
    if (Controls["uci.name"].String == "") then
        Controls["uci.name"].String = rapidjson.encode({["Text"] = "Select a UCI", ["Color"] = "Blue"})
    else
    
        for key, tbl in ipairs(uci_list) do
            if (tbl.Text == rapidjson.decode(Controls["uci.name"].String).Text) then

                print('[Updating Selected UCI]')
                Controls["uci.name"].String = rapidjson.encode(tbl)

            break end
        end
    end

    Controls["uci.name"].Choices = uci_list
    SetPages()
end

function SetPages()
    print("[Setting Page List]")

    local choice = rapidjson.decode(Controls["uci.name"].String)
    
    if (not choice.Pages) then
        return print("[No Pages Found on Choice]")
    end

    local pages = {}

    for key, page in pairs(rapidjson.decode(Controls["uci.name"].String).Pages) do
        table.insert(pages, rapidjson.decode(rapidjson.encode(page):gsub('"Name":"', '"Text":"')))
    end

    if (Controls["page.name"].String == "") then
        ResetPageList()
    else
      for key, tbl in ipairs(pages) do
          if (tbl.Text == rapidjson.decode(Controls["page.name"].String).Text) then

              print('[Updating Selected Page]')
              Controls["page.name"].String = rapidjson.encode(tbl)

          break end
      end
    end
    
    Controls["page.name"].Choices = pages
    UpdateAll()
end

function UpdateLayers()
    print("[Setting Layer List]")
    
    config = {}
    
    child_list = {}

    local all_layers = GetLayers()

    for i = 1, Properties["# Layers"].Value do
        
        if config[Controls["layer.name"][i].String] then
            print(('Layer [%s] Already Exists - Clearing Row [%d]'):format(Controls["layer.name"][i].String, i))
            Controls["layer.name"][i].String = ""
        elseif (Controls["layer.name"][i].String ~= "") then
            print(('Creating Config Entry for Layer [%s]'):format(Controls["layer.name"][i].String))
            config[Controls["layer.name"][i].String] = {
                ['Children'] = {},
                ['Index'] = i
            }
        end
        
        Controls["layer.name"][i].Choices = all_layers
        
        ConfigureParentChoices(i, all_layers)
        
        ValidateLayerName(i, all_layers)
        
        ValidateParent(i, all_layers)
        
    end

    for i = 1, Properties["# Layers"].Value do
        PopulateChildList(i)
    end
    
    print(('Config:\n\n%s\n'):format(rapidjson.encode(config, {pretty = true})))
end

function ShowLayers(layer, state)

    local function ShowLayer(layer, state, transitions)
  
    local result, err = pcall(function()
    
      local UCI_Name = rapidjson.decode(Controls["uci.name"].String).Text
      local Page_Name = rapidjson.decode(Controls["page.name"].String).Text
      local Layer_Name = Controls["layer.name"][layer].String
      local Visibility = state
      local Transition_Type = state and transitions['in'] or transitions['out']
        
      Uci.SetLayerVisibility(
        UCI_Name,
        Page_Name,
        Layer_Name,
        Visibility,
        Transition_Type
    )
      
    end)
    
    if (err) then; print(('\tError [%s] Showing Layer [%s]'):format(err, Controls["layer.name"][layer].String)); end
  end
  
  -- do this layer
  local parent_state = ""
  local parent = Controls["layer.parent"][layer].String
  local name = Controls["layer.name"][layer].String
  
  if (rapidjson.encode(config) == '{}') or (name == "") then; return print(('Row [%d]; [Cannot Process Blank Layer]'):format(layer)) end
  
  if (config[parent]) then
    parent_state = (Controls["layer.visible"][ config[parent].Index ].Boolean and state)
    print(('Layer [%s] has Parent [%s] with Visibility [%s]'):format(name, parent, parent_state))
  else
    parent_state = state
    print(('Layer [%s] has No Parent'):format(name))
  end
  
  print(('Updating Layer [%s] to State [%s]'):format(name, (parent_state and state) ))
  
  Controls['layer.visible'][layer].Boolean = (parent_state and state)
  
  ShowLayer(layer, (parent_state and state), {
    ['in'] = Controls["layer.transition.in"][layer].String,
    ['out'] = Controls["layer.transition.out"][layer].String
  })
  
  -- do this layer's children (if any), with parents' transitions and state
  
  local children = {}
  
  -- duplicate the table, don't modify
  for i, tbl in ipairs(config[name].Children) do
    table.insert(children, tbl)
  end
  
  -- if there are more children to process;
  while (children ~= nil) do
    
    children_to_check = {}
    
    -- update the visibility of the children
    for i, child in ipairs(children) do
      
      -- if they have a nested parent state, use that to determine visibility
      if (child["Parent State"] ~= nil) then; parent_state = child["Parent State"]; end
      
      child_state = Controls['layer.show'][child.Index].Boolean and parent_state
      state = (parent_state and child_state)
      
      --print(('\tParent State [%s]; Child State [%s]; State [%s]'):format(parent_state, child_state, state))
      
      print(('\tUpdating Child Layer [%s] to State [%s]'):format(child.Name, state))
      
      Controls['layer.visible'][child.Index].Boolean = state
    
      ShowLayer(child.Index, state, {
        ['in'] = Controls["layer.transition.in"][layer].String,
        ['out'] = Controls["layer.transition.out"][layer].String
      })
      
      -- if the processed child has it's own children, append them to the local children_to_check table
      --print(('\t\tChild Layer [%s] Has Children [%s]'):format(Controls['layer.name'][child.Index].String, rapidjson.encode(config[Controls["layer.name"][child.Index].String].Children), {pretty = true}))
      
      for _, tbl in ipairs(config[Controls["layer.name"][child.Index].String].Children) do
      
        local copy = {}
        for key, value in pairs(tbl) do
          copy[key] = value
        end
        table.insert(children_to_check, copy)
        children_to_check[#children_to_check]["Parent State"] = state
        
      end
      
    end
    
    -- convert the children_to_check table to be the children table so the while loop repeats with these children
    children = {}
    
    for _, tbl in ipairs(children_to_check) do
      table.insert(children, tbl)
    end
    
    if (rapidjson.encode(children) == '{}') then
        children = nil; print('[No More Nested Parents]')
    else
        print(('Children to Check:\n\n%s'):format(rapidjson.encode(children, {pretty = true})))
    end
    
  end

end

Controls["uci.name"].EventHandler = function()

    -- check if page is valid and update layer list
    local page = rapidjson.decode(Controls["page.name"].String)
    --if (not page) then return print('[Page not Set]') end
    for i, page in pairs(rapidjson.decode(Controls["uci.name"].String).Pages) do
        if (page) and (page.Name == page.Text) then
            print("[Updating Pages]")
            Controls["page.name"].String = rapidjson.encode(page):gsub('"Name":"', '"Text":"')
            return SetPages()
        end
    end
    
    ResetPageList()
    SetPages()
    
end

Controls["page.name"].EventHandler = UpdateAll

for layer = 1, Properties["# Layers"].Value do
    Controls[("layer.transition.in"):format(group)][layer].Choices = Transitions
    if (Controls[("layer.transition.in"):format(group)][layer].String == "") then
        Controls[("layer.transition.in"):format(group)][layer].String = Transitions[1]
    end

    Controls[("layer.transition.out"):format(group)][layer].Choices = Transitions
    if (Controls[("layer.transition.out"):format(group)][layer].String == "") then
        Controls[("layer.transition.out"):format(group)][layer].String = Transitions[1]
    end

    Controls["layer.name"][layer].EventHandler = UpdateAll
    
    Controls["layer.parent"][layer].EventHandler = UpdateAll
    
    Controls["layer.show"][layer].EventHandler = function(c) ShowLayers(layer, c.Boolean); end
end

Initialize()