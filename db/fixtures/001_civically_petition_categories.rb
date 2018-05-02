unless Rails.env.test?
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
        'topic_types': 'petition',
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

  unless SiteSetting.place_petition_category_id.to_i > 1
    category = Category.create(
      user: Discourse.system_user,
      name: 'Place',
      color: SecureRandom.hex(3),
      permissions: { everyone: 2 },
      allow_badges: true,
      text_color: 'FFFFF',
      topic_id: -1,
      topic_featured_link_allowed: true,
      parent_category_id: SiteSetting.petition_category_id,
      custom_fields: {
       'meta': true,
       'topic_types': 'petition',
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
      }
    )
    if category.save
      t = Topic.new(
        title: I18n.t("place_petitions_welcome.title"),
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
        raw: I18n.t('place_petitions_welcome.body'),
        user: Discourse.system_user
      )

      SiteSetting.place_petition_category_id = category.id
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
        'topic_types': 'petition',
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
      }
    )

    if category.save
      t = Topic.new(
        title: I18n.t("app_petitions_welcome.title"),
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
        raw: I18n.t('app_petitions_welcome.body'),
        user: Discourse.system_user
      )

      SiteSetting.app_petition_category_id = category.id
    end
  end
end
