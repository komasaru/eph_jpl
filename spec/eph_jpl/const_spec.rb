require 'spec_helper'

describe EphJpl::Const do
  context "USAGE" do
    #it { expect(described_class::USAGE).to eq <<-EOS
    it { expect(described_class::USAGE).to eq <<-EOS
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
    }
  end

  context "MSG_ERR_1" do
    it { expect(described_class::MSG_ERR_1).to eq "Binary file path is invalid!" }
  end

  context "MSG_ERR_2" do
    it { expect(described_class::MSG_ERR_2).to eq "Binary file is not found!" }
  end

  context "MSG_ERR_3" do
    it { expect(described_class::MSG_ERR_3).to eq "TARGET is invalid!" }
  end

  context "MSG_ERR_4" do
    it { expect(described_class::MSG_ERR_4).to eq "CENTER is invalid!" }
  end

  context "MSG_ERR_5" do
    it { expect(described_class::MSG_ERR_5).to eq "TARGET == CENTER ?" }
  end

  context "MSG_ERR_6" do
    it { expect(described_class::MSG_ERR_6).to eq "TARGET or CENTER is invalid!" }
  end

  context "MSG_ERR_7" do
    it { expect(described_class::MSG_ERR_7).to eq "JD is invalid!" }
  end

  context "MSG_ERR_8" do
    it { expect(described_class::MSG_ERR_8).to eq "KM flag is invalid!" }
  end

  context "MSG_ERR_9" do
    it { expect(described_class::MSG_ERR_9).to eq "This library is supporting only DE430!" }
  end

  context "EPOCH_PERIOD" do
    it { expect(described_class::EPOCH_PERIOD).to match([2287184.5, 2688976.5]) }
  end

  context "KSIZE" do
    it { expect(described_class::KSIZE).to eq 2036 }
  end

  context "RECL" do
    it { expect(described_class::RECL).to eq 4 }
  end

  context "ASTRS" do
    it { expect(described_class::ASTRS).to match([
      "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus",
      "Neptune", "Pluto", "Moon", "Sun", "Solar system Barycenter",
      "Earth-Moon barycenter", "Earth Nutations", "Lunar mantle Librations"
    ]) }
  end

  context "KIND" do
    it { expect(described_class::KIND).to eq 2 }
  end

  context "BARY" do
    it { expect(described_class::BARY).to be true }
  end

  context "KM" do
    it { expect(described_class::KM).to be false }
  end
end

