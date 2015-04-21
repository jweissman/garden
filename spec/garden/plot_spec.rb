require 'spec_helper'
require 'garden'
include Garden

describe Plot do
  it 'should have flowers' do
    expect(subject.flowers).not_to be_empty
    expect(subject.flowers.size).to  be > 1
    expect(subject.flowers.first).to be_a(Flower)
  end

  it 'should allow planting flowers' do
    pos = [1, 1]
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
	expect(flower.moisture).to receive(:reset)
	subject.water!(position)
      end
    end

    describe '#harvest!' do
      it 'should allow harvesting flowers' do
	expect(flower.age).to receive(:reset)
	expect(flower.size).to receive(:reset)
	expect(flower.moisture).to receive(:reset)
	expect(flower.ripeness).to receive(:reset)

        subject.harvest!(position)
      end
    end
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
