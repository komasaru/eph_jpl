require "spec_helper"

describe EphJpl::Ephemeris do
  # Edit BIN_PATH to fit your environment!
  BIN_PATH = "/home/masaru/src/ephemeris_jpl/JPLEPH"

  context %Q{.new(11, 3, 2457465.5, bin_object) } do
    let(:b) { EphJpl::Binary.new(BIN_PATH, 11, 3, 2457465.5).get_binary }
    let(:e) { described_class.new(11, 3, 2457465.5, b) }

    context "object" do
      it { expect(e).to be_an_instance_of(described_class) }
    end

    context ".target" do
      it { expect(e.target).to eq 11 }
    end

    context ".center" do
      it { expect(e.center).to eq 3 }
    end

    context ".target_name" do
      it { expect(e.target).to eq "Sun" }
    end

    context ".center_name" do
      it { expect(e.center).to eq "Earth" }
    end

    context ".jd" do
      it { expect(e.jd).to eq 2457465.5 }
    end

    context ".bin" do
      it { expect(e.bin).to be_an_instance_of(Hash) }
    end

    context ".km" do
      it { expect(e.km).to be false }
    end

    context ".get_list" do
      subject { e.send(:get_list) }
      it { expect(subject).to match([0, 0, 2, 0, 0, 0, 0, 0, 0, 2, 0, 0]) }
    end

    context ".interpolate" do
      subject { e.send(:interpolate, e.target) }
      it { expect(subject).to match([
        be_within(1.0e-18).of(0.003771551748320806),
        be_within(1.0e-19).of(0.0018431350949994834),
        be_within(1.0e-18).of(0.000621880474698687),
        be_within(1.0e-24).of(3.4280959410765515e-08),
        be_within(1.0e-21).of(6.406731351691763e-06),
        be_within(1.0e-22).of(2.7674423390648843e-06)
      ]) }
    end

    context ".norm_time" do
      subject { e.send(:norm_time, e.target) }
      it { expect(subject).to match([0.125, 0]) }
    end

    context ".calc" do
      subject { e.calc }
      it { expect(subject).to match([
        be_within(1.0e-14).of(0.99443659220701),
        be_within(1.0e-18).of(-0.038162917689578336),
        be_within(1.0e-18).of(-0.016551776709600584),
        be_within(1.0e-18).of(0.000993337565612388),
        be_within(1.0e-17).of(0.01582779844821734),
        be_within(1.0e-19).of(0.0068618662767956536)
      ]) }
    end
  end

  context %Q{.new(11, 3, 2457465.5, bin_object, true) } do
    let(:b) { EphJpl::Binary.new(BIN_PATH, 11, 3, 2457465.5).get_binary }
    let(:e) { described_class.new(11, 3, 2457465.5, b, true) }

    context ".km" do
      it { expect(e.km).to be true }
    end
  end
end

