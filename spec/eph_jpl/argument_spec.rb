require "spec_helper"

describe EphJpl::Argument do
  # Edit BIN_PATH to fit your environment!
  BIN_PATH = "/home/masaru/src/ephemeris_jpl/JPLEPH"
  BIN_DUMMY = "/path/to/dummy"

  context %Q{.new("#{BIN_PATH}", 11, 3, 2457465.5) } do
    let(:a) { described_class.new(BIN_PATH, 11, 3, 2457465.5) }

    context "object" do
      it { expect(a).to be_an_instance_of(described_class) }
    end

    context ".get_args" do
      subject { a.get_args }
      it { expect(subject).to match([BIN_PATH, 11, 3, 2457465.5, false]) }
    end

    context ".get_binpath" do
      subject { a.send(:get_binpath) }
      it { expect(subject).to eq BIN_PATH }
    end

    context ".check_bin_path" do
      let(:bin_path) { a.send(:get_binpath) }
      subject { a.send(:check_bin_path, bin_path) }
      it { expect(subject).to eq nil }
    end

    context ".get_target" do
      subject do
        a.send(:get_binpath)
        a.send(:get_target)
      end
      it { expect(subject).to eq 11 }
    end

    context ".get_center" do
      subject do
        a.send(:get_binpath)
        a.send(:get_target)
        a.send(:get_center)
      end
      it { expect(subject).to eq 3 }
    end

    context ".get_jd" do
      subject do
        a.send(:get_binpath)
        a.send(:get_target)
        a.send(:get_center)
        a.send(:get_jd)
      end
      it { expect(subject).to eq 2457465.5 }
    end

    context ".get_km" do
      subject do
        a.send(:get_binpath)
        a.send(:get_target)
        a.send(:get_center)
        a.send(:get_jd)
        a.send(:get_km)
      end
      it { expect(subject).to be false }
    end
  end

  context %Q{.new("#{BIN_DUMMY}", 11, 3, 2457465.5) } do
    let(:a) { described_class.new(BIN_DUMMY, 11, 3, 2457465.5) }

    context ".check_bin_path" do
      let(:bin_path) { a.send(:get_binpath) }
      subject { a.send(:check_bin_path, bin_path) }
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_2) }
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 11, 2457465.5) } do
    let(:a) { described_class.new(BIN_PATH, 11, 11, 2457465.5) }

    context ".check_target_center" do
      subject do
        a.send(:check_target_center, 11, 11)
      end
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_5) }
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 0, 2457465.5) } do
    let(:a) { described_class.new(BIN_PATH, 11, 0, 2457465.5) }

    context ".check_target_center" do
      subject do
        a.send(:check_target_center, 11, 0)
      end
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_6) }
    end
  end

  context %Q{.new("#{BIN_PATH}", 14, 3, 2457465.5) } do
    let(:a) { described_class.new(BIN_PATH, 14, 3, 2457465.5) }

    context ".check_target_center" do
      subject do
        a.send(:check_target_center, 14, 3)
      end
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_6) }
    end
  end

  context %Q{.new("#{BIN_PATH}", 16, 3, 2457465.5) } do
    let(:a) { described_class.new(BIN_PATH, 16, 3, 2457465.5) }

    context "get_args" do
      subject { a.get_args }
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_3) }
    end

    context ".get_target" do
      subject do
        a.send(:get_binpath)
        a.send(:get_target)
      end
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_3) }
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 0, 2457465.5) } do
    let(:a) { described_class.new(BIN_PATH, 11, 17, 2457465.5) }

    context ".get_args" do
      subject { a.get_args }
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_4) }
    end

    context ".get_center" do
      subject do
        a.send(:get_binpath)
        a.send(:get_target)
        a.send(:get_center)
      end
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_4) }
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 3, 2000000.5) } do
    let(:a) { described_class.new(BIN_PATH, 11, 3, 2000000.5) }

    context ".get_args" do
      subject { a.get_args }
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_7) }
    end

    context ".get_jd" do
      subject do
        a.send(:get_binpath)
        a.send(:get_target)
        a.send(:get_center)
        a.send(:get_jd)
      end
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_7) }
    end
  end

  context %Q{.new("#{BIN_PATH}", 11, 3, 2457465.5, 2) } do
    let(:a) { described_class.new(BIN_PATH, 11, 3, 2457465.5, 2) }

    context ".get_args" do
      subject { a.get_args }
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_8) }
    end

    context ".get_km" do
      subject do
        a.send(:get_binpath)
        a.send(:get_target)
        a.send(:get_center)
        a.send(:get_jd)
        a.send(:get_km)
      end
      it { expect{subject}.to raise_error(EphJpl::Const::MSG_ERR_8) }
    end
  end
end

