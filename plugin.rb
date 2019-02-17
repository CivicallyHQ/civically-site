# name: civically-site
# app: store
# about: Civically site-specific functionality
# version: 0.1
# authors: angus
# url: https://github.com/civicallyhq/civically-site
# image_url: https://civically.io/plugins/civically-private/images/people_background.png

register_asset 'stylesheets/common/civically-site.scss'
register_asset 'stylesheets/mobile/civically-site.scss', :mobile

register_html_builder('server:before-head-close') do
  "<script type='text/javascript' src='//s3.amazonaws.com/downloads.mailchimp.com/js/mc-validate.js'></script>"
  "<script type='text/javascript'>(function($) {window.fnames = new Array(); window.ftypes = new Array();fnames[0]='EMAIL';ftypes[0]='email';fnames[1]='FNAME';ftypes[1]='text';fnames[2]='LNAME';ftypes[2]='text';fnames[3]='ADDRESS';ftypes[3]='address';fnames[4]='PHONE';ftypes[4]='phone';fnames[5]='BIRTHDAY';ftypes[5]='birthday';}(jQuery));var $mcj = jQuery;</script>"
end

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

  ## Overrides core Site.json_for to allow categories to be loaded for resource pages.
  add_class_method(:site, :json_for) do |guardian|
    seq = nil

    if guardian.anonymous?
      seq = MessageBus.last_id('/site_json')

      cached_json, cached_seq, cached_version = $redis.mget('site_json', 'site_json_seq', 'site_json_version')

      if cached_json && seq == cached_seq.to_i && Discourse.git_version == cached_version
        return cached_json
      end

    end

    site = Site.new(guardian)
    json = MultiJson.dump(SiteSerializer.new(site, root: false, scope: guardian))

    if guardian.anonymous?
      $redis.multi do
        $redis.setex 'site_json', 1800, json
        $redis.set 'site_json_seq', seq
        $redis.set 'site_json_version', Discourse.git_version
      end
    end

    json
  end

  DiscourseEvent.trigger(:civically_site_ready)
end
