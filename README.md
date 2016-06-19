# EphJpl

## Introduction

This is the gem library which calculates ephemeris datas by JPL(NASA Jet Propulsion Laboratory) method.

This library calculates rectangular coordinates and velocities of a target astronomical body which made an astronomical body the center on a Julian Day.(Coordinate system is ICRS)

### What's JPL?

Please refer the following link.

* [NASA Jet Propulsion Laboratory (JPL) - Space Mission and Science News, Videos and Images](http://www.jpl.nasa.gov/)

Please refer the following links about DE datas.

* [HORIZONS System](http://ssd.jpl.nasa.gov/?horizons)
* [ftp://ssd.jpl.nasa.gov/pub/eph/planets/](ftp://ssd.jpl.nasa.gov/pub/eph/planets/)

To understand this library's in-depth specification, you need to comprehend contents of the following link well.

* [testeph.f - JPL](ftp://ssd.jpl.nasa.gov/pub/eph/planets/fortran/testeph.f)

### Supported DE Ver.

This library supports only DE430, now.

### Settable astronomical bodies as target and center numbers.

1. Mercury
2. Venus
3. Earth
4. Mars
5. Jupiter
6. Saturn
7. Uranus
8. Neptune
9. Pluto
10. Moon
11. Sun
12. Solar system Barycenter
13. Earth-Moon barycenter
14. Earth Nutations
15. Lunar mantle Librations

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eph_jpl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eph_jpl

## Usage

``` ruby
obj = EphJpl.new("/path/to/JPLEPH", 11, 3, 2457465.5)

p obj.target       #=> Target atronomical body No. (Integer)
p obj.target_name  #=> Target atronomical body name (String)
p obj.center       #=> Center atronomical body No. (Integer)
p obj.center_name  #=> Center atronomical body name (String)
p obj.jd           #=> Julian Day (Float)
p obj.km           #=> KM flag (true: km unit, false: AU unit) (Boolean)
p obj.unit         #=> UNIT of positions and velocities (String)
p obj.bin          #=> Acquired data from binary file (Hash)
p obj.calc         #=> [x, y, z-position, x, y, z-velocity]
```

About binary file.

1. Please get the binary file for DE430 from [ftp://ssd.jpl.nasa.gov/pub/eph/planets/Linux/de430/linux_p1550p2650.430].
2. Please put "testpo.430" into a proper directory.
3. Please rename as needed.

About arguments for target and center astronomical bodies.

* You can set a integer betweetn 1 and 15 as a target astronomical body.
* You can set a integer betweetn 0 and 13 as a center astronomical body.

About units.

* If a target astronomical body number < 14 and KM flag = false, units of position and velocity are au, au/day.
* If a target astronomical body number < 14 and KM flag = true, units of position and velocity are km, km/sec.
* If a target astronomical body number = 14 or 15, units of position and velocity are rad, rad/day.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec eph_jpl` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/komasaru/eph_jpl.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

