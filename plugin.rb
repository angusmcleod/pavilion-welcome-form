# name: pavilion-welcome-form
# about: Pavilion welcome form
# version: 0.1
# authors: Angus McLeod

register_asset 'stylesheets/welcome-form.scss'

after_initialize do
  Discourse::Application.routes.append do
    mount ::DiscourseUserForm::Engine, at: "user_form"
    get "welcome/user" => "users#index"
  end

  UsersController.class_eval do
    def perform_account_activation
      raise Discourse::InvalidAccess.new if honeypot_or_challenge_fails?(params)
      if @user = EmailToken.confirm(params[:token])

        # Log in the user unless they need to be approved
        if Guardian.new(@user).can_access_forum?
          @user.enqueue_welcome_message('welcome_user') if @user.send_welcome_message
          log_on_user(@user)

          if Wizard.user_requires_completion?(@user)
            return redirect_to(wizard_path)
          elsif SiteSetting.welcome_user_enabled
            return redirect_to("/welcome/user")
          elsif destination_url = cookies[:destination_url]
            cookies[:destination_url] = nil
            return redirect_to(destination_url)
          end
        else
          @needs_approval = true
        end

      else
        flash.now[:error] = I18n.t('activation.already_done')
      end
      render layout: 'no_ember'
    end
  end
end
