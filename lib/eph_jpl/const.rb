module EphJpl
  module Const
    USAGE        = <<-EOS
[USAGE] EphJpl.new(BIN_PATH, TARGET, CENTER, JD)
  [ASTRO NO] (TARGET: 1 - 15, CENTER: 0 - 13)
  1: Mercury, 2: Venus, 3: Earth, 4: Mars, 5: Jupiter,
  6: Saturn, 7: Uranus, 8: Neptune, 9: Pluto, 10: Moon,
  11: Sun, 12: Solar system Barycenter, 13: Earth-Moon barycenter,
  14: Earth Nutations, 15: Lunar mantle Librations
  * If TARGET = 14 or 15, CENTER = 0
  * TARGET != CENTER
  * 2287184.5 <= JD <= 2688976.5
EOS
    MSG_ERR_1    = "Binary file path is invalid!"
    MSG_ERR_2    = "Binary file is not found!"
    MSG_ERR_3    = "TARGET is invalid!"
    MSG_ERR_4    = "CENTER is invalid!"
    MSG_ERR_5    = "TARGET == CENTER ?"
    MSG_ERR_6    = "TARGET or CENTER is invalid!"
    MSG_ERR_7    = "JD is invalid!"
    MSG_ERR_8    = "KM flag is invalid!"
    MSG_ERR_9    = "This library is supporting only DE430!"
    EPOCH_PERIOD = [2287184.5, 2688976.5]
    KSIZE        = 2036
    RECL         = 4
    ASTRS        = [
      "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus",
      "Neptune", "Pluto", "Moon", "Sun", "Solar system Barycenter",
      "Earth-Moon barycenter", "Earth Nutations", "Lunar mantle Librations"
    ]
    KIND         = 2
    BARY         = true
    KM           = false
  end
end

