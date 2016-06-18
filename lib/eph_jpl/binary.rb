module EphJpl
  class Binary
    def initialize(*args)
      @bin_path, @target, @center, @jd = *args
      @pos = 0
    end

    def get_binary
      begin
        ttl    = get_ttl          # TTL
        cnams  = get_cnams        # CNAM
        sss    = get_sss          # SS
        ncon   = get_ncon         # NCON
        au     = get_au           # AU
        emrat  = get_emrat        # EMRAT
        ipts   = get_ipts         # IPT
        numde  = get_numde        # NUMDE
        ipts  << get_ipts_13      # IPT(Month's libration)
        cvals  = get_cvals(ncon)  # CVAL（定数値）
        jdepoc = cvals[4]         # JDEPOC
        coeffs, jds_cheb = get_coeffs(sss, ipts)  # Coefficient, JDs(for Chebyshev polynomial)
        return {
          ttl: ttl, cnams: cnams, sss: sss, ncon: ncon, au: au, emrat: emrat,
          numde: numde, ipts: ipts, cvals: cvals, jdepoc: jdepoc,
          coeffs: coeffs, jds_cheb: jds_cheb
        }
      rescue => e
        raise
      end
    end

    private

    #=========================================================================
    # TTL
    #
    # @param:  <none>
    # @return: TTL
    #=========================================================================
    def get_ttl
      recl = 84

      begin
        ttl = (0..2).map do |i|
          File.binread(@bin_path, recl, @pos + recl * i).unpack("A*")[0]
        end.join("\n")
        @pos += recl * 3
        return ttl
      rescue => e
        raise
      end
    end

    #=========================================================================
    # CNAM
    #
    # @param:  <none>
    # @return: Array of CNAM
    #=========================================================================
    def get_cnams
      recl = 6

      begin
        cnams = (0..399).map do |i|
          File.binread(@bin_path, recl, @pos + recl * i).unpack("A*")[0]
        end
        @pos += recl * 400
        return cnams
      rescue => e
        raise
      end
    end

    #=========================================================================
    # SS
    #
    # @param:  <none>
    # @return: Array of SS
    #=========================================================================
    def get_sss
      recl = 8

      begin
        sss = (0..2).map do |i|
          File.binread(@bin_path, recl, @pos + recl * i).unpack("d*")[0]
        end
        @pos += recl * 3
        return sss
      rescue => e
        raise
      end
    end

    #=========================================================================
    # NCON
    #
    # @param:  <none>
    # @return: NCON
    #=========================================================================
    def get_ncon
      recl = 4

      begin
        ncon = File.binread(@bin_path, recl, @pos).unpack("I*")[0]
        @pos += recl
        return ncon
      rescue => e
        raise
      end
    end

    #=========================================================================
    # AU
    #
    # @param:  <none>
    # @return: AU
    #=========================================================================
    def get_au
      recl = 8

      begin
        au = File.binread(@bin_path, recl, @pos).unpack("d*")[0]
        @pos += recl
        return au
      rescue => e
        raise
      end
    end

    #=========================================================================
    # EMRAT
    #
    # @param:  <none>
    # @return: <none>
    #=========================================================================
    def get_emrat
      recl = 8

      begin
        emrat = File.binread(@bin_path, recl, @pos).unpack("d*")[0]
        @pos += recl
        return emrat
      rescue => e
        raise
      end
    end

    #=========================================================================
    # IPT
    #
    # @param:  <none>
    # @return: Array of IPT
    #=========================================================================
    def get_ipts
      recl = 4

      begin
        ipts = (0..11).map do |i|
          ary = (0..2).map do |j|
            File.binread(@bin_path, recl, @pos + recl * j).unpack("I*")[0]
          end
          @pos += recl * 3
          ary
        end
        return ipts
      rescue => e
        raise
      end
    end

    #=========================================================================
    # NUMDE
    #
    # * If NUMDE != 430, raise error!
    #
    # @param:  <none>
    # @return: NUMDE
    #=========================================================================
    def get_numde
      recl = 4

      begin
        numde = File.binread(@bin_path, recl, @pos).unpack("I*")[0]
        raise Const::MSG_ERR_8 unless numde == 430
        @pos += recl
        return numde
      rescue => e
        raise
      end
    end

    #=========================================================================
    # IPT_13(Month's libration)
    #
    # @param:  <none>
    # @return: Array of IPT
    #=========================================================================
    def get_ipts_13
      recl = 4

      begin
        ipts = (0..2).map do |i|
          File.binread(@bin_path, recl, @pos + recl * i).unpack("I*")[0]
        end
        @pos += recl * 3
        return ipts
      rescue => e
        raise
      end
    end

    #=========================================================================
    # CVAL
    #
    # @param:  NCON
    # @return: Array of CVAL
    #=========================================================================
    def get_cvals(ncon)
      pos = Const::KSIZE * Const::RECL
      recl = 8

      begin
        return (0..ncon - 1).map do |i|
          File.binread(@bin_path, recl, pos + recl * i).unpack("d*")[0]
        end
      rescue => e
        raise
      end
    end

    #=========================================================================
    # COEFF
    #
    # * Set JD(start, end) for Chebyshev polynomial to the array @jd_cheb
    #
    # @param: Array of SS
    # @param: Array of IPT
    # @return: <none>
    #=========================================================================
    def get_coeffs(sss, ipts)
      idx = ((@jd - sss[0]) / sss[2]).floor  # レコードインデックス
      pos = Const::KSIZE * Const::RECL * (2 + idx)
      recl = 8
      coeffs = Array.new

      begin
        items = (0..(Const::KSIZE / 2) - 1).map do |i|
          File.binread(@bin_path, recl, pos + recl * i).unpack("d*")[0]
        end
        jd_cheb = [items.shift, items.shift]
        ipts.each_with_index do |ipt, i|
          n = i == 11 ? 2 : 3  # 要素数
          ary_1 = Array.new
          ipt[2].times do |j|
            ary_0 = Array.new
            n.times do |k|
              ary_0 << items.shift(ipt[1])
            end
            ary_1 << ary_0
          end
          coeffs << ary_1
        end
        return [coeffs, jd_cheb]
      rescue => e
        raise
      end
    end
  end
end

