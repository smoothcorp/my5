module My5::HealthCheckinsHelper
  def chart_from_checkins(health_checkins)
    stress_ratings = health_checkins.map {|h|  h.stress_rating || 0 }
    energy_ratings = health_checkins.map {|h|  h.energy_rating || 0 }
    comfort_ratings = health_checkins.map {|h|  h.comfort_rating || 0 }
    dates_for_axis = health_checkins.map {|h|  h.created_at.strftime("%e %b %l:%M%p") }
    chart = Gchart.line(:data => [stress_ratings, energy_ratings, comfort_ratings], :axis_with_labels => 'x',
            :axis_labels => ['Jan|July|Jan|July|Jan'], :theme => :thirty7signals)
  end
end
