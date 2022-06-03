table.insert(ctrls, {
  ['Name'] = 'uci.name',
  ['ControlType'] = "Text",
  ['UserPin'] = true,
  ['PinStyle'] = "Both",
  ['Count'] = 1
})

table.insert(ctrls, {
  ['Name'] = 'page.name',
  ['ControlType'] = "Text",
  ['UserPin'] = true,
  ['PinStyle'] = "Both",
  ['Count'] = 1
})

table.insert(ctrls, {
  ['Name'] = 'layer.name',
  ['ControlType'] = "Text",
  ['UserPin'] = true,
  ['PinStyle'] = "Both",
  ['Count'] = props['# Layers'].Value
})

table.insert(ctrls, {
  ['Name'] = 'layer.parent',
  ['ControlType'] = "Text",
  ['UserPin'] = true,
  ['PinStyle'] = "Both",
  ['Count'] = props['# Layers'].Value
})

--[[table.insert(ctrls, {
  ['Name'] = 'layer.radio.group',
  ['ControlType'] = "Text",
  ['UserPin'] = true,
  ['PinStyle'] = "Both",
  ['Count'] = props['# Layers'].Value
})]]

table.insert(ctrls, {
  ['Name'] = 'layer.transition.in',
  ['ControlType'] = "Text",
  ['UserPin'] = true,
  ['PinStyle'] = "Both",
  ['Count'] = props['# Layers'].Value
})

table.insert(ctrls, {
  ['Name'] = 'layer.transition.out',
  ['ControlType'] = "Text",
  ['UserPin'] = true,
  ['PinStyle'] = "Both",
  ['Count'] = props['# Layers'].Value
})

table.insert(ctrls, {
  ['Name'] = 'layer.show',
  ['ControlType'] = "Button",
  ['ButtonType'] = "Toggle",
  ['UserPin'] = true,
  ['PinStyle'] = "Both",
  ['Count'] = props['# Layers'].Value
})

table.insert(ctrls, {
  ['Name'] = 'layer.visible',
  ['ControlType'] = "Indicator",
  ['IndicatorType'] = "Led",
  ['UserPin'] = true,
  ['PinStyle'] = "Output",
  ['Count'] = props['# Layers'].Value
})