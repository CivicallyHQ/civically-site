# name: civically-site
# app: system
# about: Civically site-specific functionality
# version: 0.1
# authors: angus
# url: https://github.com/civicallyhq/civically-site

register_asset 'stylesheets/civically-site.scss'

after_initialize do
  SiteSetting.title = 'Civically'
  SiteSetting.allow_uncategorized_topics = false
  SiteSetting.tagging_enabled = true
  SiteSetting.events_add_to_calendar = true
  SiteSetting.topic_list_tags_category_link = true

  if Rails.env.development?
    SiteSetting.port = 3000
    SiteSetting.bootstrap_mode_enabled = false
    SiteSetting.show_create_topics_notice = false
  end

  TopicQuery.public_valid_options.push(:no_definitions)
  Category.register_custom_field_type('meta', :boolean)

  add_to_serializer(:basic_category, :meta) { object.custom_fields['meta'] }
  add_to_class(:category, 'meta') { self.custom_fields['meta'] }

  register_seedfu_fixtures(Rails.root.join("plugins", "civically-site", "db", "fixtures").to_s)

  DiscourseEvent.trigger(:civically_site_ready)
end
