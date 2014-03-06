require 'spec_helper'

describe "Static pages" do
  subject { page }

  share_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }
    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    #Test to make sure the feed properly displays the user's microposts on the home screen
    describe "for signed-in users" do
      #Create a user
      let(:user) { FactoryGirl.create(:user) }
      before do
        #Create two microposts for the user with different content
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        #sign the user in
        sign_in user
        #go to the homepage
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          #The first # is code for a CSS id whereas the second #{} is the beginning of a Ruby string interpolation,
          #in this case, the user feed microposts's id
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      #Test to make sure the feed still appears when a post error occurs
      describe "should still display post feed when invalid data is submitted" do
        before { click_button "Post" }
        it { should have_content("Lorem ipsum") }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }
    it_should_behave_like "all static pages"
  end

  #Make sure all links work properly
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end