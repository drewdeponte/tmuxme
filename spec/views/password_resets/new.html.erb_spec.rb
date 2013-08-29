require 'spec_helper'

describe "password_resets/new.html.erb" do
  it "renders a form to request a password reset" do
    render
    rendered.should have_selector("form[method=post][action='#{password_resets_path}']") do |form|
      form.should have_selector("input", :type => "text", :name => "email")
      form.should have_selector("input", :type => "submit")
    end
  end
end
