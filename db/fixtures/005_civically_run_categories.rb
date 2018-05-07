unless Rails.env.test?
  unless Category.find_by(name: 'Run')
    category = Category.create(
      user: Discourse.system_user,
      name: 'Run',
      color: SecureRandom.hex(3),
      allow_badges: true,
      text_color: 'FFFFF',
      custom_fields: {
        'meta': true,
        'topic_types': 'general',
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
       title: I18n.t("run_welcome.title"),
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
       raw: I18n.t('run_welcome.body'),
       user: Discourse.system_user
      )
    end
  end

  run_category = Category.find_by(name: 'Run')

  unless Category.find_by(name: 'Policies')
    category = Category.create(
      user: Discourse.system_user,
      name: 'Policies',
      color: SecureRandom.hex(3),
      allow_badges: true,
      permissions: { everyone: 2 },
      text_color: 'FFFFF',
      parent_category_id: run_category.id,
      custom_fields: {
        'meta': true,
        'topic_types': 'general',
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
      text_color: 'FFFFF',
      parent_category_id: run_category.id,
      custom_fields: {
        'meta': true,
        'topic_types': 'general',
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

  unless Category.find_by(name: "Help")
    category = Category.create(
      user: Discourse.system_user,
      name: 'Help',
      color: SecureRandom.hex(3),
      allow_badges: true,
      text_color: 'FFFFF',
      parent_category_id: run_category.id,
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
end
