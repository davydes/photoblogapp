require 'rails_helper'

RSpec.describe ExplorerController, :type => :controller do
  it "is available before an action" do
    expect(controller).to be_an_instance_of(ExplorerController)
  end
  describe "index" do
    it "renders index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
