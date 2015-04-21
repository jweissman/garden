require 'spec_helper'
require 'garden'

describe Garden do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end

describe Plot do
  it 'should have flowers' do
    expect(subject.flowers).not_to be_empty

    expect(subject.flowers.size).to  be > 1
    expect(subject.flowers.first).to be_a(Flower)
  end

  it 'should allow planting flowers' do
    pos = [1,1]
    expect(subject.flowers).to receive(:<<).with(instance_of(Flower))
    subject.plant!(pos)
  end

  it 'should develop flowers' do
    expect(subject.flowers.first).to receive(:develop!)
    subject.develop!
  end

  describe 'interactions' do
    let(:flower) { subject.flowers.first }
    let(:position) { flower.location }

    describe '#water!' do
      it 'should allow watering flowers' do
	expect(flower.moisture).to receive(:increment)
	subject.water!(position)
      end
    end

    #describe '#harvest!' do
    #  it 'should allow harvesting flowers' do
    #    subject.harvest!(position)
    #  end
    #end
  end

  describe '#layout' do
    before { subject.recompute_layout }
    let(:flower) { subject.layout[[0,0]] }
    
    it 'should report size of flowers' do
      expect(flower[:size]).to eql(:small)
    end

    it 'should report age of flowers' do
      expect(flower[:age]).to eql(:zygote)
    end

    it' should report moisture of flowers' do
      expect(flower[:moisture]).to eql(:well_hydrated)
    end

    it 'should report ripeness of flowers' do
      expect(flower[:ripeness]).to eql(:unripe)
    end
  end
end

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
