require 'rails/generators'
require 'rails/generators/migration'
module Authlogic
	module Generators
		class SetupGenerator < Rails::Generators::Base
			desc "A generator that sets your app up with basic authentication using authlogic."
			
			include Rails::Generators::Migration
			
			def self.source_root
        		@_authlogic_source_root ||= File.expand_path("../templates", __FILE__)
			end
			
      def generate_migrations
        pattern = "create_users.rb"
        file_names = Dir["#{Rails.root}/db/migrate/**/*.rb"].reject { |file_name| File.basename(file_name).to_s[15..file_name.size] != pattern }
        unless file_names[0].blank?
          if FileTest.exist?(file_names[0])
            say_status "identical", "#{file_names[0]}", :blue
          end
        else
          migration_template "db/migrate/create_users.rb", "db/migrate/create_users.rb"
        end
      end  

      def copy_controllers
        copy_file "app/controllers/user_sessions_controller.rb", "app/controllers/user_sessions_controller.rb"
        copy_file "app/controllers/users_controller.rb", "app/controllers/users_controller.rb"
      end

      def copy_models
        copy_file "app/models/user.rb", "app/models/user.rb"
        copy_file "app/models/user_session.rb", "app/models/user_session.rb"
      end

      def copy_views
        copy_file "app/views/users/_form.html.erb", "app/views/users/_form.html.erb"
        copy_file "app/views/users/edit.html.erb", "app/views/users/edit.html.erb"
        copy_file "app/views/users/new.html.erb", "app/views/users/new.html.erb"
        copy_file "app/views/users/show.html.erb", "app/views/users/show.html.erb"

        copy_file "app/views/user_sessions/new.html.erb", "app/views/user_sessions/new.html.erb"

        copy_file "app/views/password_resets/edit.html.erb", "app/views/password_resets/edit.html.erb"
        copy_file "app/views/password_resets/new.html.erb", "app/views/password_resets/new.html.erb"
      end

      def generate_routes
        line = "::Application.routes.draw do"
        gsub_file 'config/routes.rb', /(#{Regexp.escape(line)})/mi do |match|
          "#{match}\n 
          # Routes Generated by authlogic_template_generator

          match '/reset-password' => 'password_resets#new', :as => :reset_password, :via => [:get]
          match '/reset-password' => 'password_resets#create', :as => :reset_password, :via => [:post]

          match '/login' => 'user_sessions#create', :as => :login, :via => [:post]
          match '/login' => 'user_sessions#create', :as => :login, :via => [:get]
          match '/logout' => 'user_sessions#destroy', :as => :logout, :via => [:post]

          resources :users
          resources :password_resets, :only => [:edit, :update]

          # End Routes Generated by authlogic_template_generator
          "
        end
        say_status "edited", "config/routes.rb", :yellow
      end  

      def edit_application_controller
        line = "protect_from_forgery"

        gsub_file 'app/controllers/application_controller.rb', /(#{Regexp.escape(line)})/mi do |match|
          "#{match}\n 
      # Start generated code from authlogic_template_generator    
      helper :all
      helper_method :current_user_session, :current_user
      filter_parameter_logging :password, :password_confirmation

      private
        def current_user_session
          return @current_user_session if defined?(@current_user_session)
          @current_user_session = UserSession.find
        end

        def current_user
          return @current_user if defined?(@current_user)
          @current_user = current_user_session && current_user_session.record
        end

        def require_user
          unless current_user
            store_location
            flash[:notice] = \"You must be logged in to access this page\"
            redirect_to new_user_session_url
            return false
          end
        end

        def require_no_user
          if current_user
            store_location
            flash[:notice] = \"You must be logged out to access this page\"
            redirect_to account_url
            return false
          end
        end

        def store_location
          session[:return_to] = request.request_uri
        end

        def redirect_back_or_default(default)
          redirect_to(session[:return_to] || default)
          session[:return_to] = nil
        end
        # End code generated from the authlogic_template_generator
          "
        end
        say_status "edited", "app/controllers/application_controller.rb", :yellow    
      end

      private

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def gsub_file(relative_destination, regexp, *args, &block)
        path = relative_destination
        content = File.read(path).gsub(regexp, *args, &block)
        File.open(path, 'wb') { |file| file.write(content) }
      end
      
		end
	end
end