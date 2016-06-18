module EphJpl
  class Ephemeris
    attr_reader :target, :center, :jd, :bin, :km,
                :target_name, :center_name, :unit

    def initialize(target, center, jd, bin, km = false)
      @target, @center, @jd, @km = target, center, jd, km
      @target_name = Const::ASTRS[@target - 1]
      @center_name = Const::ASTRS[@center - 1]
      @unit = @target > 13 ? "rad, rad/day" : @km ? "km, km/sec" : "AU, AU/day"
      @bin = bin
      @list = get_list
    end

    def calc
      pvs     = Array.new(11).map { |a| Array.new(6, 0.0) }  # for position, velocity
      pvs_tmp = Array.new(13)      # Temporary array for position, velocity of target and center
      rrds    = Array.new(6, 0.0)  # for calculated data (difference between target and center)

      begin
        # Interpolate (11:Sun)
        pv_sun = interpolate(11)
        # Interpolate (1:Mercury - 10:Moon)
        0.upto(9) do |i|
          next if @list[i] == 0
          pvs[i] = interpolate(i + 1)
          next if i > 8
          next if Const::BARY
          pvs[i] = pvs[i].map.with_index do |pv, j|
            pv - pv_sun[j]
          end
        end
        # Interpolate (14:Nutation)
        if @list[10] > 0 && @bin[:ipts][11][1] > 0
          p_nut = interpolate(14)
        end
        # Interpolate (15:Libration）
        if @list[11] > 0 && @bin[:ipts][12][1] > 0
          pvs[10] = interpolate(15)
        end

        # Difference between target and center
        case
        when @target == 14
          rrds = p_nut if @bin[:ipts][11][1] > 0
        when @target == 15
          rrds = pvs[10] if @bin[:ipts][12][1] > 0
        else
          0.upto(9) { |i| pvs_tmp[i] = pvs[i] }
          pvs_tmp[10] = pv_sun            if [@target, @center].include?(11)
          pvs_tmp[11] = Array.new(6, 0.0) if [@target, @center].include?(12)
          pvs_tmp[12] = pvs[2]            if [@target, @center].include?(13)
          if @target * @center == 30 || @target + @center == 13
            pvs_tmp[2] = Array.new(6, 0.0)
          else
            pvs_tmp[2] = pvs[2].map.with_index do |pv, i|
              pv - pvs[9][i] / (1.0 + @bin[:emrat])
            end unless @list[2] == 0
            pvs_tmp[9] = pvs_tmp[2].map.with_index do |pv, i|
              pv + pvs[9][i]
            end unless @list[9] == 0
          end
          0.upto(5) do |i|
            rrds[i] = pvs_tmp[@target - 1][i] - pvs_tmp[@center - 1][i]
          end
        end
        return rrds
      rescue => e
        raise
      end
    end

    private

    #=========================================================================
    # Computation target list
    #
    # @param:  <none>
    # @return: Array
    #=========================================================================
    def get_list
      list = Array.new(12, 0)

      begin
        if @target == 14
          list[10] = Const::KIND if @bin[:ipts][11][1] > 0
          return list
        end
        if @target == 15
          list[11] = Const::KIND if @bin[:ipts][12][1] > 0
          return list
        end
        [@target, @center].each do |k|
          list[k - 1] = Const::KIND if k <= 10
          list[2]     = Const::KIND if k == 10
          list[9]     = Const::KIND if k ==  3
          list[2]     = Const::KIND if k == 13
        end
        return list
      rescue => e
        raise
      end
    end

    #=========================================================================
    # Interpolate by Chebyshev's Polynomial
    #
    # * Case astro-no
    #     1 ... 13: Position and velocity of x, y, z (6 items)
    #           14: Angular position and volocity of delta Psi, delta Epsilon (4 items)
    #           15: Angular position and volocity of Phi, Theta, Psi (6 items)
    # * If astro-no = 12, then location and volocity of x, y, z are all 0.0.
    #
    # @param:  astr (= astronomical no)
    # @return: pvs = [
    #   x-position, y-position, z-position,
    #   x-velocity, y-velocity, z-velocity
    # ]
    #   Case: 14:Nutation
    #     pvs = [
    #       delta-psi-angular-position, delta-epsilon-angular-position,
    #       delta-psi-angular-velocity, delta-epsilon-angular-velocity
    #     ]
    #   Case: 15:Libration
    #     pvs = [
    #       phi-angular-position,  theta-angular-position, psi-angular-position,
    #       phi-angular-velocity,  theta-angular-velocity, psi-angular-velocity
    #     ]
    #=========================================================================
    def interpolate(astr)
      pvs = Array.new

      begin
        tc, idx_sub = norm_time(astr)
        n_item = astr == 14 ? 2 : 3  # 要素数
        i_ipt  = astr > 13 ? astr - 3 : astr - 1
        i_coef = astr > 13 ? astr - 3 : astr - 1

        # 位置
        ary_p = [1, tc]
        2.upto(@bin[:ipts][i_ipt][1] - 1) do |i|
          ary_p << 2 * tc * ary_p[-1] - ary_p[-2]
        end  # 各項
        0.upto(n_item - 1) do |i|
          val = 0
          0.upto(@bin[:ipts][i_ipt][1] - 1) do |j|
            val += @bin[:coeffs][i_coef][idx_sub][i][j] * ary_p[j]
          end
          val /= @bin[:au] if !@km && astr < 14
          pvs << val
        end  # 値

        # 速度
        ary_v = [0, 1, 2 * 2 * tc]
        3.upto(@bin[:ipts][i_ipt][1] - 1) do |i|
          ary_v << 2 * tc * ary_v[-1] + 2 * ary_p[i - 1] - ary_v[-2]
        end  # 各項
        0.upto(n_item - 1) do |i|
          val = 0
          0.upto(@bin[:ipts][i_ipt][1] - 1) do |j|
            val += @bin[:coeffs][i_coef][idx_sub][i][j] * ary_v[j] * 2 * @bin[:ipts][i_ipt][2] / @bin[:sss][2].to_f
          end
          if astr < 14
            val /= @bin[:au] unless @km
            val /= 86400.0 if @km
          end
          pvs << val
        end  # 値

        return pvs
      rescue => e
        raise
      end
    end

    #=========================================================================
    # Time normalization, sub-period's index calculation for Chebyshev's Polynomial
    #
    # @param:  astr (= atronomical no)
    # @return: [chebyshev-time, sub-index]
    #=========================================================================
    def norm_time(astr)
      idx = astr > 13 ? astr - 2 : astr
      jd_start = @bin[:jds_cheb][0]
      tc = (@jd - jd_start) / @bin[:sss][2].to_f
      temp = tc * @bin[:ipts][idx - 1][2]
      idx = (temp - tc.floor).floor         # サブ区間のインデックス
      tc = (temp % 1.0 + tc.floor) * 2 - 1  # チェビシェフ時間
      return [tc, idx]
    rescue => e
      raise
    end
  end
end

