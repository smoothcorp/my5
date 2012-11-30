describe "routing to subscriptions" do
  it "does not expose a list of subscriptions to the public" do
    { :get => "/subscriptions" }.should_not route_to(
      {
        :controller => "subscriptions",
        :action => "index"
      }
    )
  end

  it "does not expose individual subscriptions to the public" do
    { :get => "/subscriptions/1" }.should_not route_to(
      {
        :controller => "subscriptions",
        :action => "show",
        :id => 1
      }
    )
  end

  it "routes /my5/subscriptions/new to subscriptions#new" do
    { :get => "/my5/subscriptions/new" }.should route_to({ :controller => "subscriptions", :action => "new" })
  end
end