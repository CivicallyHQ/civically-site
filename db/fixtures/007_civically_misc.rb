unless Rails.env.test?
  if lounge = Category.find_by(id: SiteSetting.lounge_category_id)
    if topic = Topic.find_by_id(lounge.topic_id)
      Post.find_by(topic_id: topic.id).destroy
      topic.destroy
    end
    Topic.where(title: I18n.t('lounge_welcome.title')).destroy_all
    lounge.destroy
  end

  if feedback = Category.find_by(id: SiteSetting.meta_category_id)
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
end
