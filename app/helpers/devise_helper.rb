module DeviseHelper

  def devise_error_messages!
    flash_alerts = []
    error_key = 'errors.messages.not_saved'

    if !flash.empty?
      flash_alerts.push(flash[:error]) if flash[:error]
      flash_alerts.push(flash[:alert]) if flash[:alert]
      flash_alerts.push(flash[:notice]) if flash[:notice]
      error_key = 'devise.failure.invalid'
    end

    return "" if resource.errors.empty? && flash_alerts.empty?
    errors = resource.errors.empty? ? flash_alerts : resource.errors.full_messages

    messages = errors.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t(error_key, :count    => errors.count,
                                 :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="row">
    <div class="small-8">
      <div class="row">
        <div class="small-3 columns">

        </div>
        <div class="small-9 columns">
          <div id="error_explanation">
            <p>#{messages}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
    HTML

    html.html_safe
  end

end

  
