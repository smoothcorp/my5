module GAReports
  class Exits
    extend Garb::Model

    metrics :exits, :pageviews
    dimensions :page_path
  end
  
  class Overview
    extend Garb::Model

    metrics :pageviews, :visitors, :newVisits, :bounces, :visitBounceRate
    # dimensions :page_path
  end
end