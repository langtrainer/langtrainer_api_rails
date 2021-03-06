require 'rails_helper'

describe V1::WorldsController do
  describe 'GET world' do
    let(:user) { Factory.build(:user_stub) }

    let(:courses) do
      [].tap do |courses|
        3.times do |i|
          units = double
          units_array = [].tap do |units|
            3.times do |j|
              steps = [].tap do |steps|
                3.times do |k|
                  steps << Factory.build(:step_stub, id: 3*i + 3*j + k)
                end
              end

              unit = Factory.build(:unit_stub, id: 3*i + j)
              allow(unit).to receive(:steps).and_return(steps)
              units << unit
            end
          end

          c = Factory.build(:course_stub, id: i)
          allow(units).to receive(:published).and_return(units_array)
          allow(c).to receive(:units).and_return(units)
          courses << c
        end
      end
    end

    let(:params) { Hash.new }

    before(:each) do
      expect(User).to receive(:fetch).with(params[:token]).and_return(user)
      expect(Course).to receive(:published).and_return(courses)
    end

    it 'should render the token, published languages and published courses' do
      get :world, format: :json
      verify(format: :json) { response.body }
    end
  end
end
