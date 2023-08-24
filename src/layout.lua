local sizes = {
  ['Layer'] = {130, 16},
  ['Transition'] = {64, 16},
  ['Show'] = {36, 16}
}
local y = 0

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Configuration",
  ['HTextAlign'] = "Center",
  ['Fill'] = {244, 159, 156},
  ['Font'] = "Roboto Mono",
  ['FontStyle'] = "Bold",
  ['CornerRadius'] = 4,
  ['Position'] = {0, y},
  ['Size'] = {300, 16}
})

y = y + 18

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "UCI Name",
  ['HTextAlign'] = "Left",
  ['Position'] = {0, y},
  ['Size'] = {168, 16}
})

layout["uci.name"] = {
  ['PrettyName'] = "Configuration~UCI Name",
  ['Style'] = "ComboBox",
  ['Position'] = {170, y},
  ['Size'] = sizes.Layer,
}

y = y + 18

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Page Name",
  ['HTextAlign'] = "Left",
  ['Position'] = {0, y},
  ['Size'] = {168, 16}
})

layout["page.name"] = {
  ['PrettyName'] = "Configuration~Page Name",
  ['Style'] = "ComboBox",
  ['Position'] = {170, y},
  ['Size'] = sizes.Layer,
}

y = y + 18 + 18
 -- 38
local x = {0, 42, 174, 306, 372, 438,504, 570, 608}

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Parent Layer",
  ['HTextAlign'] = "Center",
  ['Position'] = {x[2], y},
  ['Size'] = {130, 16}
})

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Layer Name",
  ['HTextAlign'] = "Center",
  ['Position'] = {x[3], y},
  ['Size'] = {130, 16}
})

--[[table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Radio Group",
  ['HTextAlign'] = "Center",
  ['Position'] = {x[3], y},
  ['Size'] = {130, 16}
})]]

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "In",
  ['HTextAlign'] = "Center",
  ['Position'] = {x[4], y},
  ['Size'] = {64, 16}
})
table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Delay In",
  ['HTextAlign'] = "Center",
  ['Position'] = {x[5], y},
  ['Size'] = {64, 16}
})

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Out",
  ['HTextAlign'] = "Center",
  ['Position'] = {x[6], y},
  ['Size'] = {64, 16}
})

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Delay Out",
  ['HTextAlign'] = "Center",
  ['Position'] = {x[7], y},
  ['Size'] = {64, 16}
})

table.insert(graphics, {
  ['Type'] = "Label",
  ['Text'] = "Show",
  ['HTextAlign'] = "Center",
  ['Position'] = {x[8], y},
  ['Size'] = {36, 16}
})

y = y + 18

for layer = 1, props['# Layers'].Value do

  table.insert(graphics, {
      ['Type'] = "Label",
      ['Text'] = tostring(layer),
      ['HTextAlign'] = "Center",
      ['Position'] = {x[1], y},
      ['Size'] = {40, 16}
  })
  
  layout[('layer.parent %d'):format(layer)] = {
      ['PrettyName'] = ('Layer %d~Parent Layer'):format(layer),
      ['Style'] = "ComboBox",
      ['Position'] = {x[2], y},
      ['Size'] = sizes.Layer,
  }

  layout[('layer.name %d'):format(layer)] = {
      ['PrettyName'] = ('Layer %d~Name'):format(layer),
      ['Style'] = "ComboBox",
      ['Position'] = {x[3], y},
      ['Size'] = sizes.Layer,
  }

  --[[layout[('layer.radio.group %d'):format(layer)] = {
      ['PrettyName'] = ('Layer %d~Radio Group'):format(layer),
      ['Style'] = "Text",
      ['Position'] = {x[3], y},
      ['Size'] = sizes.Layer,
  }]]

  layout[('layer.transition.in %d'):format(layer)] = {
      ['PrettyName'] = ('Layer %d~Transition In'):format(layer),
      ['Style'] = "ComboBox",
      ['Position'] = {x[4], y},
      ['Size'] = sizes.Transition,
  }

  layout[('layer.delay.in %d'):format(layer)] = {
    ['PrettyName'] = ('Layer %d~Delay In'):format(layer),
    ['Style'] = "Text",
    ['Position'] = {x[5], y},
    ['Size'] = sizes.Transition,
}

  layout[('layer.transition.out %d'):format(layer)] = {
      ['PrettyName'] = ('Layer %d~Transition Out'):format(layer),
      ['Style'] = "ComboBox",
      ['Position'] = {x[6], y},
      ['Size'] = sizes.Transition,
  }

  layout[('layer.delay.out %d'):format(layer)] = {
    ['PrettyName'] = ('Layer %d~Delay Out'):format(layer),
    ['Style'] = "Text",
    ['Position'] = {x[7], y},
    ['Size'] = sizes.Transition,
}

  layout[('layer.show %d'):format(layer)] = {
      ['PrettyName'] = ('Layer %d~Show'):format(layer),
      ['Style'] = "Button",
      ['Position'] = {x[8], y}
  }

  layout[('layer.visible %d'):format(layer)] = {
      ['PrettyName'] = ('Layer %d~Visible'):format(layer),
      ['Style'] = "Led",
      ['Position'] = {x[9], y}
  }

  y = y + 18

end