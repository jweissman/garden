require 'spec_helper'
require 'garden'
describe Flower do
  it 'should have a location' do
    expect(subject.location).to eql([0,0])
  end

  it 'should have a color' do
    expect(subject.color).to eql(:red)
  end

  it 'should have a moisture level' do
    expect(subject.moisture_category).to eql(:well_hydrated)
  end

  it 'should have an age' do
    expect(subject.age_category).to eql(:zygote)
  end

  it 'should have a size' do
    expect(subject.size_category).to eql(:small)
  end

  it 'should have a ripeness' do
    expect(subject.ripeness_category).to eql(:unripe)
  end

  describe '#develop!' do
    it 'should increase age' do
      expect(subject.age).to receive(:increment)
      subject.develop!
    end

    it 'should increase size' do
      expect(subject.size).to receive(:increment)
      subject.develop!
    end

    it 'should increment ripeness' do
      expect(subject.ripeness).to receive(:increment)
      subject.develop!
    end

    it 'should reduce moisture' do
      expect(subject.moisture).to receive(:decrement)
      subject.develop!
    end
  end

  describe 'category transitions' do
    before do
      subject.develop! until \
	subject.age_category != Aspects::Age.values.first &&
	subject.size_category != Aspects::Size.values.first &&
	subject.ripeness_category != Aspects::Ripeness.values.first &&
	subject.moisture_category != Aspects::Moisture.values.last
    end

    it 'should have a new age category' do
      expect(subject.age_category).to eql(:embryo)
    end

    it 'should have a new size category' do
      expect(subject.size_category).to eql(:medium)
    end

    it 'should have a new moisture category' do
      expect(subject.moisture_category).to eql(:dry)
    end

    it 'should have a new ripeness category' do
      expect(subject.ripeness_category).to eql(:ripe)
    end
  end
end
