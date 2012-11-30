class HealthCheckin < ActiveRecord::Base
  after_initialize :init

  def init
    self.status ||= 1
  end

  belongs_to :customer

  ZONES = ["Stress", "Energy", "Comfort"]

  def self.possible_values
    (0..10).collect do |val|
      case val
      when 0
        ["#{val} (Low)", val]
      when 10
        ["#{val} (High)", val]
      else
        [val, val]
      end
    end
  end

  def step=(val)
    @step = val
  end

  def step
    @step || 0
  end
end
