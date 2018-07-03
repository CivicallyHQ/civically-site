require_dependency 'user'
class ::User
  def team_bio
    self.user_profile.bio_cooked
  end
end

module ::CivicallyTeam
  class Engine < ::Rails::Engine
    engine_name "civically_team"
    isolate_namespace CivicallyTeam
  end
end

class CivicallyTeam::Team
  def self.members
    @members ||= Group.lookup_group('Civically').users.human_users
  end
end

class CivicallyTeam::TeamSerializer < ApplicationSerializer
  attributes :name, :title, :position, :username, :avatar_template, :team_bio
end

require_dependency 'application_controller'
class CivicallyTeam::MembersController < ::ApplicationController
  def index
    render json: ActiveModel::ArraySerializer.new(CivicallyTeam::Team.members, each_serializer: CivicallyTeam::TeamSerializer).as_json
  end
end

CivicallyTeam::Engine.routes.draw do
  get "" => "members#index"
  put "toggle-membership" => "members#toggle_membership"
end

Discourse::Application.routes.append do
  mount ::CivicallyTeam::Engine, at: "team"
end
