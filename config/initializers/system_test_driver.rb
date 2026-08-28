if Rails.env.test?
  require "capybara"
  require "selenium-webdriver"

  Capybara.register_driver :selenium_chrome_headless do |app|
    options = Selenium::WebDriver::Chrome::Options.new

    # Capybara 3.40.0 標準の selenium_chrome_headless と同じ設定
    options.add_argument("--headless=new")
    options.add_argument("--disable-gpu") if Gem.win_platform?
    options.add_argument("--disable-site-isolation-trials")

    # Chromeのパスワード関連UIが
    # Seleniumの操作を妨げないようにする
    options.add_preference(
      "credentials_enable_service",
      false
    )

    options.add_preference(
      "profile.password_manager_enabled",
      false
    )

    options.add_preference(
      "profile.password_manager_leak_detection",
      false
    )

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options
    )
  end
end