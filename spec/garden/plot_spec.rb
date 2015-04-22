require 'spec_helper'
require 'garden'
require 'pry'
include Garden

describe Plot do
  it 'should have flowers' do
    expect(subject.flowers).not_to be_empty
    expect(subject.flowers.size).to  be > 1
    expect(subject.flowers.first).to be_a(Flower)
  end

  describe '#initialize' do
    let(:subject) { Plot.new(xys) }
    let(:xys) { [[0,0],[1,0],[2,1]] }
    before { subject.recompute_layout }

    it 'should place flowers on init' do
      expect(subject.layout.keys).to eql(xys)
    end
  end

  it 'should allow planting flowers' do
    pos = [4, 5]
    expect(subject.flowers).to receive(:<<).with(instance_of(Flower))
    subject.plant!(pos)
  end

  describe '#develop!' do
    it 'should develop flowers' do
      expect(subject.flowers.first).to receive(:develop!)
      subject.develop!
    end

    let(:pop) { subject.flowers.count }
    it 'should cull dead flowers' do
      subject.develop! until subject.flowers.first.age_category == :dead
      expect { subject.develop! }.to change { subject.flowers.count }.from(pop).to(0)
      expect(subject.layout).to eql({})
    end
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
    let(:flower) { subject.layout[[1,1]] }
    
    it 'should report size of flowers' do
      expect(flower[:size]).to eql(:small)
    end

    it 'should report age of flowers' do
      expect(flower[:age]).to eql(:seed)
    end

    it' should report moisture of flowers' do
      expect(flower[:moisture]).to eql(:well_hydrated)
    end

    it 'should report ripeness of flowers' do
      expect(flower[:ripeness]).to eql(:unripe)
    end
  end
end
