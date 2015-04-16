require 'rails_helper'

describe "password_resets/new.html.erb" do
  it "renders a form to request a password reset" do
    render
    expect(rendered).to have_selector("form[method=post][action='#{password_resets_path}']") do |form|
      expect(form).to have_selector("input", :type => "text", :name => "email")
      expect(form).to have_selector("input", :type => "submit")
    end
  end
end
