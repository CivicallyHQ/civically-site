unless Rails.env.test?
  unless Category.find_by(name: 'World')
    world_category = Category.create(
      user: Discourse.system_user,
      name: 'World',
      slug: 'world',
      color: SecureRandom.hex(3),
      allow_badges: true,
      text_color: 'FFFFF',
      topic_featured_link_allowed: true,
      custom_fields: {
        'is_place': true,
        'place_type': 'international',
        'can_join': false,
        'location': {
          "name": "World",
          "flag": "/images/emoji/twitter/earth_africa.png",
          "route_to": "/c/world",
          "geo_location": {
            "type": "international",
            "international_code": "world"
          }
        },
        'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
        'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
        'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
        'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
        'topic_list_thumbnail_width': 600,
        'topic_list_thumbnail_height': 200
      })

    if world_category.save
      t = Topic.new(
        title: I18n.t("place.about.title", place: 'World'),
        user: Discourse.system_user,
        pinned_at: Time.now,
        category_id: world_category.id
      )
      t.skip_callbacks = true
      t.ignore_category_auto_close = true
      t.delete_topic_timer(TopicTimer.types[:close])
      t.save!(validate: false)

      world_category.topic_id = t.id
      world_category.save!

      t.posts.create(
        raw: I18n.t('place.about.post', place: 'World'),
        user: Discourse.system_user
      )
    end
  end

  unless Category.find_by(name: 'European Union')
    eu_category = Category.create(
      user: Discourse.system_user,
      name: 'European Union',
      slug: 'eu',
      color: SecureRandom.hex(3),
      allow_badges: true,
      text_color: 'FFFFF',
      topic_featured_link_allowed: true,
      custom_fields: {
        'is_place': true,
        'place_type': 'international',
        'can_join': false,
        'location': {
          "name": "European Union",
          "flag": "/plugins/civically-place/images/flags/eu_32.png",
          "route_to": "/c/eu",
          "geo_location": {
            "boundingbox": [30.5,71.3,-12.7,35.1],
            "type": "international",
            "international_code": "eu"
          }
        },
        'topic_list_social': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
        'topic_list_thumbnail': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
        'topic_list_excerpt': "latest|new|unread|top|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
        'topic_list_action': "latest|unread|top|new|agenda|latest-mobile|new-mobile|unread-mobile|top-mobile|agenda-mobile",
        'topic_list_thumbnail_width': 600,
        'topic_list_thumbnail_height': 200
      })

    if eu_category.save
      t = Topic.new(
        title: I18n.t("place.about.title", place: 'European Union'),
        user: Discourse.system_user,
        pinned_at: Time.now,
        category_id: eu_category.id
      )
      t.skip_callbacks = true
      t.ignore_category_auto_close = true
      t.delete_topic_timer(TopicTimer.types[:close])
      t.save!(validate: false)

      eu_category.topic_id = t.id
      eu_category.save!

      t.posts.create(
        raw: I18n.t('place.about.post', place: 'European Union'),
        user: Discourse.system_user
      )
    end
  end
end
