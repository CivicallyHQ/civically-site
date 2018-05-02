unless Rails.env.test?
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
        'topic_types': 'general',
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
end
