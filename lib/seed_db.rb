unless SiteSetting.petition_category_id.to_i > 1
  category = Category.create(
    user: Discourse.system_user,
    name: 'Petitions',
    color: SecureRandom.hex(3),
    permissions: { everyone: 2 },
    allow_badges: true,
    text_color: 'FFFFF',
    topic_featured_link_allowed: true,
    custom_fields: {
      'meta': true,
      'enable_topic_voting': "true",
      'petition_enabled': true,
      'petition_vote_threshold': 100,
      'tl0_vote_limit': 1,
      'tl1_vote_limit': 1,
      'tl2_vote_limit': 1,
      'tl3_vote_limit': 1,
      'tl4_vote_limit': 1,
      'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail_width': 600,
      'topic_list_thumbnail_height': 300
    })
  if category.save
    t = Topic.new(
      title: I18n.t("petitions_welcome.title"),
      user: Discourse.system_user,
      pinned_at: Time.now,
      category_id: category.id
    )
    t.skip_callbacks = true
    t.ignore_category_auto_close = true
    t.delete_topic_timer(TopicTimer.types[:close])
    t.save!(validate: false)

    category.topic_id = t.id
    category.save!

    t.posts.create(
      raw: I18n.t('petitions_welcome.body'),
      user: Discourse.system_user
    )

    SiteSetting.petition_category_id = category.id
  end
end

unless Category.find_by(name: 'Work')
  category = Category.create(
    user: Discourse.system_user,
    name: 'Work',
    color: SecureRandom.hex(3),
    allow_badges: true,
    text_color: 'FFFFF',
    topic_featured_link_allowed: true,
    custom_fields: {
      'meta': true,
      'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail_width': 600,
      'topic_list_thumbnail_height': 300
    })
  if category.save
    t = Topic.new(
      title: I18n.t("work_welcome.title"),
      user: Discourse.system_user,
      pinned_at: Time.now,
      category_id: category.id
    )
    t.skip_callbacks = true
    t.ignore_category_auto_close = true
    t.delete_topic_timer(TopicTimer.types[:close])
    t.save!(validate: false)

    category.topic_id = t.id
    category.save!

    t.posts.create(
      raw: I18n.t('work_welcome.body'),
      user: Discourse.system_user
    )
  end
end

work_category = Category.find_by(name: 'Work')

unless Category.find_by(name: 'Plugins')
  category = Category.create(
    user: Discourse.system_user,
    name: 'Plugins',
    color: SecureRandom.hex(3),
    allow_badges: true,
    permissions: { everyone: 2 },
    text_color: 'FFFFF',
    parent_category_id: work_category.id,
    custom_fields: {
      'meta': true,
      'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail_width': 600,
      'topic_list_thumbnail_height': 300
    }
  )
  if category.save
    t = Topic.new(
     title: I18n.t("plugins_welcome.title"),
     user: Discourse.system_user,
     pinned_at: Time.now,
     category_id: category.id
    )
    t.skip_callbacks = true
    t.ignore_category_auto_close = true
    t.delete_topic_timer(TopicTimer.types[:close])
    t.save!(validate: false)

    category.topic_id = t.id
    category.save!

    t.posts.create(
     raw: I18n.t('plugins_welcome.body'),
     user: Discourse.system_user
    )
  end
end

unless SiteSetting.app_petition_category_id.to_i > 1
  category = Category.create(
    user: Discourse.system_user,
    name: 'App',
    color: SecureRandom.hex(3),
    permissions: { everyone: 2 },
    allow_badges: true,
    text_color: 'FFFFF',
    topic_id: -1,
    topic_featured_link_allowed: true,
    parent_category_id: SiteSetting.petition_category_id,
    custom_fields: {
      'meta': true,
      'enable_topic_voting': "true",
      'petition_enabled': true,
      'petition_vote_threshold': 100,
      'tl0_vote_limit': 1,
      'tl1_vote_limit': 1,
      'tl2_vote_limit': 1,
      'tl3_vote_limit': 1,
      'tl4_vote_limit': 1
    }
  )

  SiteSetting.app_petition_category_id = category.id
end

unless SiteSetting.app_category_id.to_i > 1
  category = Category.create(
    user: Discourse.system_user,
    name: 'Apps',
    color: SecureRandom.hex(3),
    permissions: { everyone: 2 },
    allow_badges: true,
    text_color: 'FFFFF',
    topic_id: -1,
    topic_featured_link_allowed: true,
    custom_fields: {
      'meta': true,
      'rating_enabled': true,
      'topic_types': 'rating'
    }
  )

  if category.save
    SiteSetting.app_category_id = category.id

    t = Topic.new(
      title: I18n.t("about_apps.title"),
      user: Discourse.system_user,
      pinned_at: Time.now,
      category_id: category.id
    )
    t.skip_callbacks = true
    t.ignore_category_auto_close = true
    t.delete_topic_timer(TopicTimer.types[:close])
    t.save!(validate: false)

    category.topic_id = t.id
    category.save!

    t.posts.create(
      raw: I18n.t('about_apps.body'),
      user: Discourse.system_user
    )
  end
end

unless Category.find_by(name: 'Plans')
  category = Category.create(
    user: Discourse.system_user,
    name: 'Plans',
    color: SecureRandom.hex(3),
    allow_badges: true,
    text_color: 'FFFFF',
    topic_featured_link_allowed: true,
    custom_fields: {
      'meta': true,
      'enable_topic_voting': "true",
      'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail_width': 600,
      'topic_list_thumbnail_height': 300
    })
  if category.save
    t = Topic.new(
      title: I18n.t("plans_welcome.title"),
      user: Discourse.system_user,
      pinned_at: Time.now,
      category_id: category.id
    )
    t.skip_callbacks = true
    t.ignore_category_auto_close = true
    t.delete_topic_timer(TopicTimer.types[:close])
    t.save!(validate: false)

    category.topic_id = t.id
    category.save!

    t.posts.create(
      raw: I18n.t('plans_welcome.body'),
      user: Discourse.system_user
    )
  end
end

unless Category.find_by(name: 'Help')
  category = Category.create(
    user: Discourse.system_user,
    name: 'Help',
    color: SecureRandom.hex(3),
    allow_badges: true,
    text_color: 'FFFFF',
    custom_fields: {
      'meta': true,
      'enable_accepted_answers': true,
      'topic_types': 'question',
      'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail_width': 600,
      'topic_list_thumbnail_height': 300
    }
  )
  if category.save
    t = Topic.new(
     title: I18n.t("help_welcome.title"),
     user: Discourse.system_user,
     pinned_at: Time.now,
     category_id: category.id
    )
    t.skip_callbacks = true
    t.ignore_category_auto_close = true
    t.delete_topic_timer(TopicTimer.types[:close])
    t.save!(validate: false)

    category.topic_id = t.id
    category.save!

    t.posts.create(
     raw: I18n.t('help_welcome.body'),
     user: Discourse.system_user
    )
  end
end

help_category = Category.find_by(name: 'Help')

unless Category.find_by(name: 'Policies')
  category = Category.create(
    user: Discourse.system_user,
    name: 'Policies',
    color: SecureRandom.hex(3),
    allow_badges: true,
    permissions: { everyone: 2 },
    text_color: 'FFFFF',
    parent_category_id: help_category.id,
    custom_fields: {
      'meta': true,
      'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail_width': 600,
      'topic_list_thumbnail_height': 300
    }
  )
  if category.save
    t = Topic.new(
     title: I18n.t("policies_welcome.title"),
     user: Discourse.system_user,
     pinned_at: Time.now,
     category_id: category.id
    )
    t.skip_callbacks = true
    t.ignore_category_auto_close = true
    t.delete_topic_timer(TopicTimer.types[:close])
    t.save!(validate: false)

    category.topic_id = t.id
    category.save!

    t.posts.create(
     raw: I18n.t('policies_welcome.body'),
     user: Discourse.system_user
    )
  end
end

unless Category.find_by(name: 'How To')
  category = Category.create(
    user: Discourse.system_user,
    name: 'How To',
    color: SecureRandom.hex(3),
    allow_badges: true,
    permissions: { everyone: 2 },
    text_color: 'FFFFF',
    parent_category_id: help_category.id,
    custom_fields: {
      'meta': true,
      'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
      'topic_list_thumbnail_width': 600,
      'topic_list_thumbnail_height': 300
    }
  )
  if category.save
    t = Topic.new(
     title: I18n.t("how_to_welcome.title"),
     user: Discourse.system_user,
     pinned_at: Time.now,
     category_id: category.id
    )
    t.skip_callbacks = true
    t.ignore_category_auto_close = true
    t.delete_topic_timer(TopicTimer.types[:close])
    t.save!(validate: false)

    category.topic_id = t.id
    category.save!

    t.posts.create(
     raw: I18n.t('how_to_welcome.body'),
     user: Discourse.system_user
    )
  end
end

if lounge = Category.find_by(id: SiteSetting.lounge_category_id)
  if topic = Topic.find_by_id(lounge.topic_id)
    Post.find_by(topic_id: topic.id).destroy
    topic.destroy
  end
  Topic.where(title: I18n.t('lounge_welcome.title')).destroy_all
  lounge.destroy
end

if feedback = Category.find_by(name: 'Site Feedback')
  if topic = Topic.find_by_id(feedback.topic_id)
    Post.find_by(topic_id: topic.id).destroy
    topic.destroy
  end
  feedback.destroy
end

if topic = Topic.find_by(title: I18n.t('discourse_welcome_topic.title'))
  topic.destroy
end

if topic = Topic.find_by(title: "READ ME FIRST: Admin Quick Start Guide")
  topic.destroy
end

unless Theme.exists?(name: "Civically Wizards")
  RemoteTheme.import_theme("https://github.com/civicallyhq/civically-wizards")
end
