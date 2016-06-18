require "spec_helper"

describe EphJpl::Binary do
  # Edit BIN_PATH to fit your environment!
  BIN_PATH = "/home/masaru/src/ephemeris_jpl/JPLEPH"

  context %Q{.new("#{BIN_PATH}", 11, 3, 2457465.5) } do
    let(:b) { described_class.new(BIN_PATH, 11, 3, 2457465.5) }

    context "object" do
      it { expect(b).to be_an_instance_of(EphJpl::Binary) }
    end

    context "@pos" do
      subject { b.instance_variable_get(:@pos) }
      it { expect(subject).to eq 0 }
    end

    context ".get_binary" do
      subject { b.get_binary }
      it do
        expect(subject).to be_an_instance_of(Hash)
        expect(subject[:jdepoc]).to eq 2440400.5
      end
    end

    context ".get_ttl" do
      subject { b.send(:get_ttl) }
      it { expect(subject).to match(/^JPL Planetary Ephemeris DE430/) }
    end

    context ".get_cnams" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
      end
      it { expect(subject[0,10]).to match([
        "DENUM", "LENUM", "TDATEF", "TDATEB", "JDEPOC",
        "CENTER", "CLIGHT", "BETA", "GAMMA", "AU"
      ]) }
    end

    context ".get_sss" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
      end
      it { expect(subject).to match([2287184.5, 2688976.5, 32.0]) }
    end

    context ".get_ncon" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
        b.send(:get_ncon)
      end
      it { expect(subject).to eq 572 }
    end

    context ".get_au" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
        b.send(:get_ncon)
        b.send(:get_au)
      end
      it { expect(subject).to eq 149597870.7 }
    end

    context ".get_emrat" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
        b.send(:get_ncon)
        b.send(:get_au)
        b.send(:get_emrat)
      end
      it { expect(subject).to be_within(1.0e-14).of(81.30056907419062) }
    end

    context ".get_ipts" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
        b.send(:get_ncon)
        b.send(:get_au)
        b.send(:get_emrat)
        b.send(:get_ipts)
      end
      it { expect(subject).to match([
        [  3, 14, 4], [171, 10, 2], [231, 13, 2], [309, 11, 1], [342,  8, 1],
        [366,  7, 1], [387,  6, 1], [405,  6, 1], [423,  6, 1], [441, 13, 8],
        [753, 11, 2], [819, 10, 4]
      ]) }
    end

    context ".get_ipts" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
        b.send(:get_ncon)
        b.send(:get_au)
        b.send(:get_emrat)
        b.send(:get_ipts)
        b.send(:get_numde)
      end
      it { expect(subject).to eq 430 }
    end

    context ".get_ipts_13" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
        b.send(:get_ncon)
        b.send(:get_au)
        b.send(:get_emrat)
        b.send(:get_ipts)
        b.send(:get_numde)
        b.send(:get_ipts_13)
      end
      it { expect(subject).to match([899, 10, 4]) }
    end

    context ".get_cvals" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
        b.send(:get_ncon)
        b.send(:get_au)
        b.send(:get_emrat)
        b.send(:get_ipts)
        b.send(:get_numde)
        b.send(:get_ipts_13)
        b.send(:get_cvals, 572)
      end
      it { expect(subject[0,12]).to match([
        430.0, 430.0, 20130329200438.0, 20130329191007.0, 2440400.5,
        0.0, 299792.458, 1.0, 1.0, 149597870.7,
        be_within(1.0e-14).of(81.30056907419062),
        be_within(1.0e-25).of(4.91248045036476e-11)
      ]) }
    end

    context ".get_coeffs" do
      subject do
        b.send(:get_ttl)
        b.send(:get_cnams)
        b.send(:get_sss)
        b.send(:get_ncon)
        b.send(:get_au)
        b.send(:get_emrat)
        b.send(:get_ipts)
        b.send(:get_numde)
        b.send(:get_ipts_13)
        b.send(:get_cvals, 572)
        b.send(:get_coeffs, [2287184.5, 2688976.5, 32.0], [
          [  3, 14, 4], [171, 10, 2], [231, 13, 2], [309, 11, 1], [342,  8, 1],
          [366,  7, 1], [387,  6, 1], [405,  6, 1], [423,  6, 1], [441, 13, 8],
          [753, 11, 2], [819, 10, 4], [899, 10, 4]
        ])
      end
      it { expect(subject[0][0][0][0][0,5]).to match([
        be_within(1.0e-8).of(45504893.24150742),
        be_within(1.0e-9).of(7731834.965392029),
        be_within(1.0e-10).of(-776090.8071882643),
        be_within(1.0e-9).of(-41121.3443020638),
        be_within(1.0e-13).of(-503.7461853424133)
      ]) }
      it { expect(subject[1]).to match([2457456.5, 2457488.5]) }
    end
  end
end

