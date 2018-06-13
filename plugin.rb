# name: civically-site
# app: store
# about: Civically site-specific functionality
# version: 0.1
# authors: angus
# url: https://github.com/civicallyhq/civically-site

register_asset 'stylesheets/common/civically-site.scss'
register_asset 'stylesheets/mobile/civically-site.scss', :mobile

after_initialize do
  SiteSetting.title = 'Civically'
  SiteSetting.allow_uncategorized_topics = false
  SiteSetting.tagging_enabled = true
  SiteSetting.events_add_to_calendar = true
  SiteSetting.limit_suggested_to_category = true
  SiteSetting.allow_user_locale = true

  if Rails.env.development?
    SiteSetting.port = 3000
    SiteSetting.bootstrap_mode_enabled = false
    SiteSetting.show_create_topics_notice = false
  end

  TopicQuery.public_valid_options.push(:no_definitions, :subtype)
  Category.register_custom_field_type('meta', :boolean)

  add_to_serializer(:basic_category, :meta) { object.custom_fields['meta'] }
  add_to_class(:category, 'meta') { self.custom_fields['meta'] }

  register_seedfu_fixtures(Rails.root.join("plugins", "civically-site", "db", "fixtures").to_s)

  DiscourseEvent.trigger(:civically_site_ready)
end
