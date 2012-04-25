# NUBIC/surveyor gem tutorial for Rails beginners
- - -
The [NUBIC/surveyor gem](https://github.com/NUBIC/surveyor) is an awesome ruby gem and developer tool that brings surveys into Rails applications. Surveys are written in the Surveyor DSL (Domain Specific Language). If your Rails app needs to asks users questions as part of a survey, quiz, or questionnaire then you should consider using Surveyor.

This tutorial is to help Rails beginners implement and extend this gem in their Rails project.  The "kitchen sink" Survey in the [surveyor README](https://github.com/NUBIC/surveyor#readme) is a great place to get started, as is the "extending surveyor" README.  However, for beginners, I thought it might be useful to have an example that walks through how to tie the surveyor gem to your user model and make some basic customizations.  For this tutorial I am using Rails 3.2.3 and Ruby 1.9.3p125 (2012-02-16 revision 34643) [x86_64-darwin10.8.0].

#Surveyor Tutorial
- - -

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

Then, in the command line:

    $ git add .
    $ git commit -am "Installed surveyor assets"
    $ git push
    $ git push heroku
    $ heroku run rake db:migrate
    $ heroku run rake surveyor FILE=surveys/kitchen_sink_survey.rb
    $ heroku open

Now navigate to http://[yourappname].herokuapp.com/surveys    


