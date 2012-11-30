require 'spec_helper'

describe Program do

  def reset_program(options = {})
    @valid_attributes = {
      :id => 1
    }

    @program.destroy! if @program
    @program = Program.create!(@valid_attributes.update(options))
  end

  before(:each) do
    reset_program
  end

  context "validations" do
    
  end

end