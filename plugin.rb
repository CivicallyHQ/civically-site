# name: civically-site
# app: store
# about: Civically site-specific functionality
# version: 0.1
# authors: angus
# url: https://github.com/civicallyhq/civically-site

register_asset 'stylesheets/common/civically-site.scss'
register_asset 'stylesheets/mobile/civically-site.scss', :mobile

after_initialize do
  Category.register_custom_field_type('meta', :boolean)
  add_to_serializer(:basic_category, :meta) { object.custom_fields['meta'] }
  add_to_class(:category, 'meta') { self.custom_fields['meta'] }

  load File.expand_path('../lib/team_edits.rb', __FILE__)
  load File.expand_path('../lib/static_edits.rb', __FILE__)

  if SiteSetting.invite_only
    add_body_class('invite-only')
  end

  CIVICALLY_TAG_GROUPS = [
    'civically_actions',
    'civically_parties',
    'civically_subjects'
  ]

  add_to_class(:site, :civically_tags) do
    @civically_tags ||= begin
      Tag.joins('JOIN tag_group_memberships ON tags.id = tag_group_memberships.tag_id')
        .joins('JOIN tag_groups ON tag_group_memberships.tag_group_id = tag_groups.id')
        .where('tag_groups.name in (?)', CIVICALLY_TAG_GROUPS)
        .group('tag_groups.name, tags.name')
        .pluck('tag_groups.name, tags.name')
        .each_with_object({}) do |arr, result|
          type = arr[0].split("_").last
          result[type] = [] if result[type].blank?
          result[type].push(arr[1])
        end
    end
  end

  add_to_serializer(:site, :civically_tags) { object.civically_tags }

  DiscourseEvent.trigger(:civically_site_ready)
end
