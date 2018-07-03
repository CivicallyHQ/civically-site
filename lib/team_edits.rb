User.register_custom_field_type('team_member', :boolean)

require_dependency 'user'
class ::User
  def team_member
    if self.custom_fields['team_member']
      self.custom_fields['team_member']
    else
      false
    end
  end

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
  before_action :ensure_admin, only: [:toggle_membership]

  def index
    render json: ActiveModel::ArraySerializer.new(CivicallyTeam::Team.members, each_serializer: CivicallyTeam::TeamSerializer).as_json
  end

  def toggle_membership
    params.require(:user_id)

    if user = User.find_by(id: params[:user_id])
      user.custom_fields['team_member'] = !user.team_member
      user.save_custom_fields(true)

      render json: success_json.merge(state: user.team_member)
    else
      render json: failed_json.merge(message: 'Could not find user')
    end
  end
end

CivicallyTeam::Engine.routes.draw do
  get "" => "members#index"
  put "toggle-membership" => "members#toggle_membership"
end

Discourse::Application.routes.append do
  mount ::CivicallyTeam::Engine, at: "team"
end
