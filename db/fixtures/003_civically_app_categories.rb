unless Rails.env.test?
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
end
