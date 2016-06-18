require "eph_jpl/version"
require "eph_jpl/argument"
require "eph_jpl/binary"
require "eph_jpl/const"
require "eph_jpl/ephemeris"

module EphJpl
  def self.new(*args)
    bin_path, target, center, jd, km = Argument.new(*args).get_args
    bin = Binary.new(bin_path, target, center, jd).get_binary
    return EphJpl::Ephemeris.new(target, center, jd, bin, km)
  end
end

