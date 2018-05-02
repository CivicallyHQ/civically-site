unless Rails.env.test?
  Badge.where(icon: 'fa-user').each do |b|
    if b.badge_grouping_id != 4
      b.badge_grouping_id = 4
      b.save!
    end
  end

  Badge.where(icon: 'fa-certificate').each do |b|
    if b.badge_grouping_id != 3
      b.badge_grouping_id = 3
      b.save!
    end
  end

  Badge.where(icon: 'fa-heart').each do |b|
    if b.badge_grouping_id != 2
      b.badge_grouping_id = 2
      b.save!
    end
  end

  Badge.where(icon: 'fa-user-plus').each do |b|
    if b.badge_grouping_id != BadgeGrouping::Place
      b.badge_grouping_id = BadgeGrouping::Place
      b.save!
    end
  end

  if grouping = BadgeGrouping.find_by(name: "Trust Level")
    grouping.name = "Status"
    grouping.save!
  end

  if grouping = BadgeGrouping.find_by(name: "Posting")
    grouping.name = "Posts"
    grouping.save!
  end

  unless ::BadgeGrouping.where(name: 'Place').exists?
    ::BadgeGrouping.all.each do |g|
      g.position = g.position + 1
      g.save
    end

    group = BadgeGrouping.new(id: BadgeGrouping::Place)
    group.name = 'Place'
    group.position = 0
    group.save
  end

  unless Badge.exists?(Badge::Pioneer)
    pioneer = Badge.new(
      id: Badge::Pioneer,
      name: I18n.t('badges.pioneer.name'),
      badge_type_id: BadgeType::Bronze,
      badge_grouping_id: BadgeGrouping::Place,
      default_icon: 'fa-tree',
      allow_title: true,
      multiple_grant: false,
      target_posts: false,
      show_posts: false,
      default_badge_grouping_id: BadgeGrouping::Place,
      auto_revoke: false,
      description: I18n.t('badges.pioneer.description'),
      long_description: I18n.t('badges.pioneer.long_description')
    )
    pioneer.save
  end

  unless Badge.exists?(Badge::Pathfinder)
    pathfinder = Badge.new(
      id: Badge::Pathfinder,
      name: I18n.t('badges.pathfinder.name'),
      badge_type_id: BadgeType::Silver,
      badge_grouping_id: BadgeGrouping::Place,
      default_icon: 'fa-tree',
      allow_title: true,
      multiple_grant: false,
      target_posts: false,
      show_posts: false,
      default_badge_grouping_id: BadgeGrouping::Place,
      auto_revoke: false,
      description: I18n.t('badges.pathfinder.description'),
      long_description: I18n.t('badges.pathfinder.long_description')
    )
    pathfinder.save
  end

  unless Badge.exists?(Badge::Founder)
    founder = Badge.new(
      id: Badge::Founder,
      name: I18n.t('badges.founder.name'),
      badge_type_id: BadgeType::Gold,
      badge_grouping_id: BadgeGrouping::Place,
      default_icon: 'fa-tree',
      allow_title: true,
      multiple_grant: false,
      target_posts: false,
      show_posts: false,
      default_badge_grouping_id: BadgeGrouping::Place,
      auto_revoke: false,
      description: I18n.t('badges.founder.description'),
      long_description: I18n.t('badges.founder.long_description')
    )
    founder.save
  end
end
