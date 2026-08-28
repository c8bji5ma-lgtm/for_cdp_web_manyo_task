require "test_helper"

class ApplicationRequestSmokeTest < ActionDispatch::IntegrationTest
  test "serves the public error page through the application stack" do
    get "/404.html"

    assert_response :success

    body = response.body.dup
    body.force_encoding(Encoding::UTF_8)

    assert_includes body, "お探しのページは見つかりません。"
  end
end