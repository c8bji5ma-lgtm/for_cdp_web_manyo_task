require "application_system_test_case"

class ApplicationSystemSmokeTest < ApplicationSystemTestCase
  driven_by :rack_test

  test "renders the public error page" do
    visit "/404.html"

    assert_text "お探しのページは見つかりません。"
  end
end