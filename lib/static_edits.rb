STATIC_ROUTES = ['start', 'organisation', 'government', 'about', 'team', 'donate', 'faq', 'tos', 'privacy']

Discourse.static_doc_topic_ids.push(SiteSetting.about_topic_id)

Discourse::Application.routes.prepend do
  get "about" => "static#show", id: "about", constraints: { format: /(json|html)/ }
end

PAGES_WITH_EMAIL_PARAM = ['login', 'password_reset', 'signup']

module StaticControllerCivicallyExtension
  def show
    return redirect_to(path '/') if current_user && (params[:id] == 'login' || params[:id] == 'signup')

    map = {
      "about" => { topic_id: "about_topic_id" },
      "faq" => { topic_id: "guidelines_topic_id" },
      "tos" => { topic_id: "tos_topic_id" },
      "privacy" => { topic_id: "privacy_topic_id" }
    }

    @page = params[:id]

    # The /guidelines route ALWAYS shows our FAQ, ignoring the faq_url site setting.
    @page = 'faq' if @page == 'guidelines'

    # Don't allow paths like ".." or "/" or anything hacky like that
    @page.gsub!(/[^a-z0-9\_\-]/, '')

    if map.has_key?(@page)
      @topic = Topic.find_by_id(SiteSetting.send(map[@page][:topic_id]))
      raise Discourse::NotFound unless @topic
      @title = "#{@topic.title} - #{SiteSetting.title}"
      @body = @topic.posts.first.cooked
      @faq_overriden = !SiteSetting.faq_url.blank?
      render :show, layout: !request.xhr?, formats: [:html]
      return
    end

    if I18n.exists?("static.#{@page}")
      render html: I18n.t("static.#{@page}"), layout: !request.xhr?, formats: [:html]
      return
    end

    if PAGES_WITH_EMAIL_PARAM.include?(@page) && params[:email]
      cookies[:email] = { value: params[:email], expires: 1.day.from_now }
    end

    file = "static/#{@page}.#{I18n.locale}"
    file = "static/#{@page}.en" if lookup_context.find_all("#{file}.html").empty?
    file = "static/#{@page}"    if lookup_context.find_all("#{file}.html").empty?

    if lookup_context.find_all("#{file}.html").any?
      render file, layout: !request.xhr?, formats: [:html]
      return
    end

    raise Discourse::NotFound
  end
end

require_dependency 'static_controller'
class StaticController
  prepend StaticControllerCivicallyExtension
end

module ApplicationControllerCivicallyExtension
  def redirect_to_login_if_required
    return if current_user || (request.format.json? && is_api?)

    allowed_routes = STATIC_ROUTES + ['/']
    url = request.referer || request.original_url
    return if allowed_routes.any? { |str| /#{str}/ =~ url }

    if SiteSetting.login_required?
      flash.keep

      if params[:authComplete].present?
        redirect_to path("/login?authComplete=true")
      else
        # save original URL in a cookie (javascript redirects after login in this case)
        cookies[:destination_url] = destination_url
        redirect_to path("/login")
      end
    end
  end
end

require_dependency 'application_controller'
class ApplicationController
  prepend_view_path(Rails.root.join('plugins', 'civically-site', 'app/views'))
  prepend ApplicationControllerCivicallyExtension
end

StaticController.class_eval do
  before_action :set_body_class

  def blank
    render html: '', layout: true
  end

  def set_body_class
    @custom_body_class = 'static'
  end
end

ExceptionsController.class_eval do
  before_action :set_body_class
  prepend_view_path(Rails.root.join('plugins', 'civically-site', 'app/views'))

  def set_body_class
    @custom_body_class = 'not-found'
  end
end
