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
  SiteSetting.events_add_to_calendar = true

  if Rails.env.development?
    SiteSetting.port = 3000
    SiteSetting.bootstrap_mode_enabled = false
    SiteSetting.show_create_topics_notice = false
  end

  TopicQuery.public_valid_options.push(:no_definitions)
  Category.register_custom_field_type('meta', :boolean)

  add_to_serializer(:basic_category, :meta) { object.custom_fields['meta'] }
  add_to_class(:category, 'meta') { self.custom_fields['meta'] }

  load File.expand_path('../lib/seed_db.rb', __FILE__)

  DiscourseEvent.trigger(:civically_site_ready)
end
