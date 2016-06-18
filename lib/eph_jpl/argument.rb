module EphJpl
  class Argument
    def initialize(*args)
      @args = *args
    end

    #=========================================================================
    # 引数取得
    #
    # @return: [BIN_PATH, TARGET, CENTER, JD, KM]
    #=========================================================================
    def get_args
      bin_path = get_binpath
      target   = get_target
      center   = get_center
      jd       = get_jd
      km       = get_km
      check_bin_path(bin_path)
      check_target_center(target, center)
      return [bin_path, target, center, jd, km]
    rescue => e
      raise
    end

    def get_binpath
      raise unless bin_path = @args.shift
      return bin_path
    rescue => e
      raise Const::MSG_ERR_1
    end

    def get_target
      raise unless target = @args.shift
      raise unless target.to_s =~ /^\d+$/
      raise if target.to_i < 1 || 15 < target.to_i
      return target.to_i
    rescue => e
      raise Const::MSG_ERR_3
    end

    def get_center
      raise unless center = @args.shift
      raise unless center.to_s =~ /^\d+$/
      raise if center.to_i < 0 || 13 < center.to_i
      return center.to_i
    rescue => e
      raise Const::MSG_ERR_4
    end

    def get_jd
      raise unless jd = @args.shift
      if jd.to_s !~ /^[\d\.]+$/ || \
         jd.to_f < Const::EPOCH_PERIOD[0] || \
         Const::EPOCH_PERIOD[1] < jd.to_f
        raise
      end
      return jd.to_f
    rescue => e
      raise Const::MSG_ERR_7
    end

    def get_km
      km = @args.shift
      km ||= Const::KM
      raise unless km.to_s =~ /^true|false|[01]$/
      km = km.to_s =~ /0|false/ ? false : true
      return km
    rescue => e
      raise Const::MSG_ERR_8
    end

    def check_target_center(target, center)
      case
      when target == center
        raise Const::MSG_ERR_5
      when target < 14 && center == 0,
           target > 13 && center != 0
        raise Const::MSG_ERR_6
      end
    end

    def check_bin_path(bin_path)
      raise Const::MSG_ERR_2 unless File.exist?(bin_path)
    end
  end
end

