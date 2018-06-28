SiteSetting.title = 'Civically'
SiteSetting.allow_uncategorized_topics = false
SiteSetting.tagging_enabled = true
SiteSetting.limit_suggested_to_category = true
SiteSetting.allow_user_locale = true

SiteSetting.logo_url = '/plugins/civically-site/images/logo.png'
SiteSetting.logo_small_url = '/plugins/civically-site/images/logo_small.png'
SiteSetting.large_icon_url = '/plugins/civically-site/images/logo_banner_android.png'
SiteSetting.favicon_url = '/plugins/civically-site/images/logo_favicon.ico'
SiteSetting.apple_touch_icon_url = '/plugins/civically-site/images/logo_touch.png'
SiteSetting.default_opengraph_image_url = '/plugins/civically-site/images/logo_banner_facebook.png'
SiteSetting.twitter_summary_large_image_url = '/plugins/civically-site/images/logo_banner_twitter.png'

if SiteSetting.respond_to?("events_add_to_calendar".to_sym)
  SiteSetting.events_add_to_calendar = true
end

if SiteSetting.respond_to?("discourse_donations_enabled".to_sym)
  SiteSetting.discourse_donations_enabled = true
  SiteSetting.discourse_donations_types = 'month|once|week|year'
  SiteSetting.discourse_donations_enable_transaction_fee = true
end

if Rails.env.development?
  SiteSetting.port = 3000
  SiteSetting.bootstrap_mode_enabled = false
  SiteSetting.show_create_topics_notice = false
end
