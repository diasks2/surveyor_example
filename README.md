# NUBIC/surveyor gem tutorial for Rails beginners
- - -
The [NUBIC/surveyor gem](https://github.com/NUBIC/surveyor) is an awesome ruby gem and developer tool that brings surveys into Rails applications. Surveys are written in the Surveyor DSL (Domain Specific Language). If your Rails app needs to asks users questions as part of a survey, quiz, or questionnaire then you should consider using Surveyor.

This tutorial is to help Rails beginners implement and extend this gem in their Rails project.  The "kitchen sink" Survey in the [surveyor README](https://github.com/NUBIC/surveyor#readme) is a great place to get started, as is the "extending surveyor" README.  However, for beginners, I thought it might be useful to have an example that walks through how to tie the surveyor gem to your user model and make some basic customizations.  For this tutorial I am using Rails 3.2.3 and Ruby 1.9.3p125 (2012-02-16 revision 34643) [x86_64-darwin10.8.0].

#Surveyor Tutorial
- - -

###Section 1 - Create a new rails app and get the 'kitchen sink' survey working

1) Create a new repository on [GitHub](https://github.com) named 'surveyor_example'

2) Create a new rails project

    $ rails new surveyor_example
    $ cd surveyor_example

3) Open the project in your favorite text editor (example: I am using Sublime Text 2)

    $ subl .

4) Update the Gemfile. Cut & Paste the contents of this [tutorials Gemfile](https://github.com/diasks2/surveyor_example/blob/master/Gemfile) into your Gemfile.

5) Install and include the new gems

    $ bundle install

5a) In my case, my rake version is 0.9.2.2 and the surveyor gem requires 0.9.2, so I received the following error:
> "You have requested: rake = 0.9.2 
The bundle currently has rake locked at 0.9.2.2."

If this happens to you, run the following in your command line:

    $ bundle update rake

6) Initialize the Git repository and push to GitHub

    $ git init
    $ git add .
    $ git commit -m "Initial commit"
    $ git remote add origin git@github.com:<username>/surveyor_example.git
    $ git push -u origin master

7) (Optional) Deploy the app to Heroku. (Assuming you have already created a Heroku account. If not, check out this [tutorial](http://ruby.railstutorial.org/chapters/beginning?version=3.2#sec:1.4.1)) 

    $ heroku create --stack cedar
    $ git push heroku master

8) Generate surveyor assets

    $ script/rails generate surveyor:install

9) Migrate the database (If you received the rake version error above, be sure to include 'bundle exec' before your rake command)

    $ bundle exec rake db:migrate        

10) Try out the 'kitchen sink' survey

    $ bundle exec rake surveyor FILE=surveys/kitchen_sink_survey.rb

11) Test it on the local server (start the server)

    $ rails s

And visit: [http://localhost:3000/surveys](http://localhost:3000/surveys)

12) Deploy and test it on Heroku

In the production.rb file (located in config/environments) set:

     config.assets.compile = true

* this is due to [open issue #307](https://github.com/NUBIC/surveyor/issues/307)

Then, in the command line:

    $ git add .
    $ git commit -am "Installed surveyor assets"
    $ git push
    $ git push heroku
    $ heroku run rake db:migrate
    $ heroku run rake surveyor FILE=surveys/kitchen_sink_survey.rb
    $ heroku open

Now navigate to http://[yourappname].herokuapp.com/surveys

you can visit the example for this tutorial here: [http://surveyor-example.herokuapp.com/surveys](http://surveyor-example.herokuapp.com/surveys)

###Section 2 - Create your own survey

13) Try making your own survey

Create a new file in the surveys folder of your project, name it 'my_survey.rb' and edit it as you like.

14) Parse the survey

    $ bundle exec rake surveyor FILE=surveys/my_survey.rb  

15) Try it on the local server    

    $ rails s

And visit: [http://localhost:3000/surveys](http://localhost:3000/surveys)

16) Try it on Heroku

    $ heroku run rake surveyor FILE=surveys/my_survey.rb
    $ heroku open

Now navigate to http://[yourappname].herokuapp.com/surveys

###Section 3 - Add a user model

17) Create a Users controller

    $ rails generate controller Users new

18) Generate a User model

    $ rails generate model User name:string email:string

19) Migrate the new model

    $ bundle exec rake db:migrate

20) Add some basic validations to the User model

    class User < ActiveRecord::Base
      attr_accessible :name, :email, :password, :password_confirmation
      has_secure_password

      before_save { |user| user.email = email.downcase }

      validates :name, presence: true, length: { maximum: 50 }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
      validates :password, length: { minimum: 6 }
      validates :password_confirmation, presence: true
    end

21) Add an index to the user email

    $ rails generate migration add_index_to_users_email

22) Navigate to the db/migrate folder and open the file that was just created db/migrate/[timestamp]_add_index_to_users_email.rb and edit it like below

    class AddIndexToUsersEmail < ActiveRecord::Migration
      def change
        add_index :users, :email, unique: true
      end
    end  

23) Add password_digest to the model

    $ rails generate migration add_password_digest_to_users password_digest:string    

24) Migrate the database

    $ bundle exec rake db:migrate 

25) Open the rails console and create a new user
 
    $ rails console
    >> User.create(name: "Your Name", email: "yourname@example.com",
    ?> password: "foobar", password_confirmation: "foobar")

26) Commit the changes
  
    $ git add .
    $ git commit -m "A basic User model"
    $ git push
    $ git push heroku

###Section 4 - Create a sign up and sign in form

27)  Add a Users resource to the routes file (config/routes.rb)

    SurveyorExample::Application.routes.draw do
      resources :users

      match '/signup',  to: 'users#new'

    end
    
be sure to remove the line 'get "users/new"'

28) Create a form to sign up new users

Edit this view: app/views/users/new.html.erb

You can copy the code from [this example](https://github.com/diasks2/surveyor_example/blob/master/app/views/users/new.html.erb)

29) Update the UsersController

    class UsersController < ApplicationController
      def new
         @user = User.new
      end

      def show
         @user = User.find(params[:id])
      end

      def create
        @user = User.new(params[:user])
        if @user.save
          redirect_to @user
        else
          render 'new'
        end
      end

    end

30) Add a page to show user info at [app/views/users/show.html.erb](https://github.com/diasks2/surveyor_example/blob/master/app/views/users/show.html.erb)

    <%= @user.name %>, <%= @user.email %>

31) Generate a Sessions Controller

    $ rails generate controller Sessions

32) Update the [config/routes.rb](https://github.com/diasks2/surveyor_example/blob/master/config/routes.rb) file:

    SurveyorExample::Application.routes.draw do
      resources :users
      resources :sessions, only: [:new, :create, :destroy]

      match '/signup',  to: 'users#new'
      match '/signin',  to: 'sessions#new'
      match '/signout', to: 'sessions#destroy', via: :delete
    end

33) Add a new, create and destroy method to the SessionsController [app/controllers/sessions_controller.rb](https://github.com/diasks2/surveyor_example/blob/master/app/controllers/sessions_controller.rb)

    class SessionsController < ApplicationController
      def new
      end

      def create
      end

      def destroy
      end
    end

34) Create a signin view [app/views/sessions/new.html.erb](https://github.com/diasks2/surveyor_example/blob/master/app/views/sessions/new.html.erb)

    <h1>Sign in</h1>

    <%= form_for(:session, url: sessions_path) do |f| %>

    <%= f.label :email %>
    <%= f.text_field :email %>

    <%= f.label :password %>
    <%= f.password_field :password %>

    <%= f.submit "Sign in" %>
    <% end %>

35) Update the SessionsController

36) Update the ApplicationController

37) Generate remember token

    $ rails generate migration add_remember_token_to_users

38) Add the remember token to the users table (db/migrate/[timestamp]_add_remember_token_to_users.rb)

    class AddRememberTokenToUsers < ActiveRecord::Migration
      def change
        add_column :users, :remember_token, :string
        add_index  :users, :remember_token
      end
    end    

39) Migrate the database

    $ bundle exec rake db:migrate

40) Update the user model

41) Add a SessionsHelper

    









