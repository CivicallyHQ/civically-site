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
      'tl4_vote_limit': 1
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
      'meta': true
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
      'meta': true
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
      'enable_topic_voting': "true"
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
      'topic_types': 'question'
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
      'meta': true
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
      'meta': true
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
  topic = Topic.find(lounge.topic_id)
  Post.find_by(topic_id: topic.id).destroy
  topic.destroy
  Topic.where(title: I18n.t('lounge_welcome.title')).destroy_all
  lounge.destroy
end

if feedback = Category.find_by(name: 'Site Feedback')
  topic = Topic.find(feedback.topic_id)
  Post.find_by(topic_id: topic.id).destroy
  topic.destroy
  feedback.destroy
end

if topic = Topic.find_by(title: I18n.t('discourse_welcome_topic.title'))
  topic.destroy
end

if topic = Topic.find_by(title: "READ ME FIRST: Admin Quick Start Guide")
  topic.destroy
end
