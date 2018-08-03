# name: civically-site
# app: store
# about: Civically site-specific functionality
# version: 0.1
# authors: angus
# url: https://github.com/civicallyhq/civically-site

register_asset 'stylesheets/common/civically-site.scss'
register_asset 'stylesheets/mobile/civically-site.scss', :mobile

after_initialize do
  TopicQuery.public_valid_options.push(:no_definitions, :subtype)

  Category.register_custom_field_type('meta', :boolean)
  add_to_serializer(:basic_category, :meta) { object.custom_fields['meta'] }
  add_to_class(:category, 'meta') { self.custom_fields['meta'] }

  load File.expand_path('../lib/team_edits.rb', __FILE__)
  load File.expand_path('../lib/static_edits.rb', __FILE__)

  if SiteSetting.invite_only
    add_body_class('invite-only')
  end

  DiscourseEvent.trigger(:civically_site_ready)
end
