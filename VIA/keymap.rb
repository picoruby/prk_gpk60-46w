require "via"

kbd = Keyboard.new

kbd.via = true # This should happen before `kbd.init_pins`
kbd.via_layer_count = 3

kbd.init_pins(
  [ 29, 28, 27, 26, 22, 20, 23 ],
  [ 3, 4, 5, 6, 7, 8, 9]
)

rgb = RGB.new(
  0,
  9,
  0,
  false
)
rgb.effect = :breath
rgb.hue = 0
rgb.speed = 25
kbd.append rgb

kbd.output_report_changed do |output|
  if output & Keyboard::LED_CAPSLOCK > 0
    rgb.hue = 80
  elsif output & Keyboard::LED_NUMLOCK > 0
    rgb.hue = 160
  elsif output & Keyboard::LED_SCROLLLOCK > 0
    rgb.hue = 240
  else
    rgb.hue = 0
  end
end

kbd.define_mode_key :VIA_FUNC0, [ Proc.new { kbd.bootsel! }, nil, 300, nil ]
kbd.define_mode_key :VIA_FUNC1, [ :KC_ENTER, :VIA_LAYER1, 150, 150 ]
kbd.define_mode_key :VIA_FUNC2, [ :KC_SPACE, :VIA_LAYER2, 150, 150 ]
kbd.define_mode_key :VIA_FUNC3, [ :KC_NO,    :VIA_LAYER3, 150, 150 ]
kbd.define_mode_key :VIA_FUNC4, [ Proc.new { PicoRubyVM.print_alloc_stats }, nil, 300, nil ]

kbd.start!

