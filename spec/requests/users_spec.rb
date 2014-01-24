require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      before do
        visit signup_path
        fill_in "Name",         :with => ""
        fill_in "Email",        :with => ""
        fill_in "Password",     :with => ""
        fill_in "Confirmation", :with => ""
      end

      it "should render the template" do
        click_button
        response.should render_template('users/new')
      end

      it "should have error selector" do
        click_button
        response.should have_selector('div#error_explanation')
      end

      it "should not change user count" do
        lambda do
          click_button
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      before do
        visit signup_path
        fill_in "Name",         :with => "Example User"
        fill_in "Email",        :with => "user@example.com"
        fill_in "Password",     :with => "foobar"
        fill_in "Confirmation", :with => "foobar"
      end

      it "should have welcome selector" do
        click_button
        response.should have_selector("div.flash.success", :content => "Welcome")
      end

      it "should render template" do
        click_button
        response.should render_template('users/show')
      end

      it "should change user count by 1" do
        lambda do
          click_button
        end.should change(User, :count).by(1)
      end
    end
  end
end
