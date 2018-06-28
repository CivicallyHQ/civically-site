Discourse.static_doc_topic_ids.push(SiteSetting.about_topic_id)

Discourse::Application.routes.prepend do
  get "about" => "static#show", id: "about", constraints: { format: /(json|html)/ }
end

module StaticControllerCivicallyExtension
  def show
    if params[:id] == 'about'
      @page = 'about'
      @topic = Topic.find_by_id(SiteSetting.about_topic_id)
      raise Discourse::NotFound unless @topic
      @title = "#{@topic.title} - #{SiteSetting.title}"
      @body = @topic.posts.first.cooked
      @faq_overriden = !SiteSetting.faq_url.blank?
      render :show, layout: !request.xhr?, formats: [:html]
      return
    else
      super
    end
  end
end

require_dependency 'static_controller'
class StaticController
  prepend StaticControllerCivicallyExtension
end

StaticController.class_eval do
  prepend_view_path(Rails.root.join('plugins', 'civically-site', 'app/views'))

  def blank
    render html: '', layout: true
  end
end

ExceptionsController.class_eval do
  before_action :set_body_class
  prepend_view_path(Rails.root.join('plugins', 'civically-site', 'app/views'))

  def set_body_class
    @custom_body_class = 'not-found'
  end
end
