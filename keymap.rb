# Initialize a Keyboard
kbd = Keyboard.new

# Initialize GPIO assign
kbd.init_pins(
  [ 29, 28, 27, 26, 22, 20, 23 ],
  [ 3, 4, 5, 6, 7, 8, 9]

)

# default layer should be added at first
kbd.add_layer :default, %i[
  KC_ESCAPE KC_Q    KC_W    KC_E        KC_R    KC_T                          KC_Y    KC_U      KC_I     KC_O     KC_P      KC_MINUS
  KC_TAB    KC_A    KC_S    KC_D        KC_F    KC_G                          KC_H    KC_J      KC_K     KC_L     KC_SCOLON KC_BSPACE
  KC_LSFT   KC_Z    KC_X    KC_C        KC_V    KC_B      KC_NO     KC_NO     KC_N    KC_M      KC_COMMA KC_DOT   KC_SLASH  KC_RSFT
                            KC_NO       KC_LALT KC_LCTL   LOWER_SPC RAISE_ENT SPC_CTL KC_RGUI   KC_NO
]
kbd.add_layer :raise, %i[
  KC_GRAVE  KC_EXLM KC_AT   KC_HASH     KC_DLR  KC_PERC                       KC_CIRC KC_AMPR   KC_ASTER KC_LPRN  KC_RPRN   KC_EQUAL
  KC_TAB    KC_LABK KC_LCBR KC_LBRACKET KC_LPRN KC_QUOTE                      KC_LEFT KC_DOWN   KC_UP    KC_RIGHT KC_UNDS   KC_PIPE
  KC_LSFT   KC_RABK KC_RCBR KC_RBRACKET KC_RPRN KC_DQUO   KC_NO     KC_NO     KC_TILD KC_BSLASH KC_COMMA KC_DOT   KC_SLASH  KC_RSFT
                            KC_NO       KC_LALT KC_LCTL   ADJUST    RAISE_ENT SPC_CTL KC_RGUI   KC_NO
]
kbd.add_layer :lower, %i[
  KC_ESCAPE KC_1    KC_2    KC_3        KC_4    KC_5                          KC_6    KC_7      KC_8     KC_9     KC_0      KC_EQUAL
  KC_TAB    KC_LABK KC_LCBR KC_LBRACKET KC_LPRN KC_QUOTE                      KC_DOT  KC_4      KC_5     KC_6     KC_PLUS   KC_BSPACE
  KC_LSFT   KC_RABK KC_RCBR KC_RBRACKET KC_RPRN KC_DQUO   KC_NO     KC_NO     KC_0    KC_1      KC_2     KC_3     KC_SLASH  KC_COMMA
                            KC_NO       KC_LALT KC_LCTL   LOWER_SPC ADJUST    SPC_CTL KC_RGUI   KC_NO
]
kbd.add_layer :adjust, %i[
  KC_F1     KC_F2   KC_F3   KC_F4       KC_F5   KC_F6                         KC_F7   KC_F8     KC_F9    KC_F10   KC_F11    KC_F12
  RGB_TOG   RGB_SPI RGB_HUI RGB_SAI     RGB_VAI RGB_MOD                       KC_NO   KC_NO     KC_NO    KC_NO    KC_NO     BOOTSEL
  RGB_TOG   RGB_SPD RGB_HUD RGB_SAD     RGB_VAD RGB_RMOD  KC_NO     KC_NO     KC_NO   KC_NO     KC_NO    KC_NO    KC_NO     STATS
                            KC_NO       KC_LALT KC_LCTL   ADJUST    ADJUST    SPC_CTL KC_RGUI   KC_NO
]

kbd.define_composite_key :SPC_CTL, %i(KC_SPACE KC_RCTL)

kbd.define_mode_key :RAISE_ENT, [ :KC_ENTER,                 :raise,   150, 150 ]
kbd.define_mode_key :LOWER_SPC, [ :KC_SPACE,                 :lower,   150, 150 ]
kbd.define_mode_key :STATS,     [ Proc.new { PicoRubyVM.print_alloc_stats }, nil, 300, nil ]
kbd.define_mode_key :ADJUST,    [ nil,                       :adjust,  nil, nil ]
kbd.define_mode_key :BOOTSEL,   [ Proc.new { kbd.bootsel! }, nil,      300, nil ]

# Initialize RGBLED with pin, underglow_size, backlight_size and is_rgbw.
rgb = RGB.new(
  0,    # pin number
  9,    # size of underglow pixel
  0,   # size of backlight pixel
  false # 32bit data will be sent to a pixel if true while 24bit if false
)
rgb.effect = :breath
rgb.hue = 0
rgb.speed = 25
kbd.append rgb

kbd.output_report_changed do |output|
  if output & Keyboard::LED_CAPSLOCK > 0
    rgb.hue = 100
  else
    rgb.hue = 0
  end
end

kbd.start!
