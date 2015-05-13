require 'spec_helper'


describe Array do

  let( :valid_advisors )  { ['F1021786', 'F653317' ] }
      let( :an_array ) { Array.new }
  context '#update_or_create' do
    context 'a simple array' do
      it "each call increments the array-size" do
	expect{ 0.upto(10){|x|  an_array.update_or_create(x) } }.to change{ an_array.size }.by 11 
	expect( an_array).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      end
      it "update works" do
	an_array.update_or_create 5 
	expect{ an_array.update_or_create 5 }.not_to change{ an_array.size }
      end
    end
    context 'a hash with one comparable item' do
      it "each call increments the array-size" do
	expect{ 0.upto(10){|x|  an_array.update_or_create({ x: x, y: x.to_s}, :y) } }.to change{ an_array.size }.by 11 
      end
      it "update works" do
	an_array.update_or_create({ x: 5, y: '5'})   
	expect{ an_array.update_or_create( { x: 5, y: '5' }, :y) }.not_to change{ an_array.size }
      end

    end
    context 'a hash with many comparable items' do
      it "each call increments the array-size" do
	expect{ 0.upto(10){|x|  an_array.update_or_create({ x: x, y: x.to_s, z: x.between?(3,6)? "EUR" : 'USD'}, :y) } }.to change{ an_array.size }.by 11 
      end
      it "simple update works" do
	an_array.update_or_create({ x: 5, y: '5'})   
	expect{ an_array.update_or_create( { x: 5, y: '5' }, :y) }.not_to change{ an_array.size }
      end
      it "complex update works" do
	an_array.update_or_create({ x: 5, y: '5', z: "USD"})   
	an_array.update_or_create({ x: 4, y: '5', z: "EUR"})   
	expect( an_array.size ).to eq 2
	expect{ an_array.update_or_create( { x: 5, y: '5', z: 'USD' }, :y,:z) }.not_to change{ an_array.size }
	expect{ an_array.update_or_create( { x: 5, y: '5', z: 'EUR' }, :y,:z) }.not_to change{ an_array.size }
	expect{ an_array.update_or_create( { x: 5, y: '5', z: 'EUR' }, :y,:z) }.not_to change{ an_array.size }
	expect{ an_array.update_or_create( { x: 10, y: '5', z: 'EUR' }, :y,:z) }.to change{ an_array.last[:x] }.to 10
	expect{ an_array.update_or_create( { x: 10, y: 'zzu', z: 'EUR' },:x,:z) }.to change{ an_array.last[:y] }.to 'zzu' 
	expect{ an_array.update_or_create( { x: 5, y: 'zzu', z: 'USD' },:x,:z) }.to change{ an_array.first[:y] }.to 'zzu' 
	expect( an_array.size ).to eq 2
      end

    end
  end




end
