# NUBIC/surveyor gem tutorial for Rails beginners
- - -
The [NUBIC/surveyor gem](https://github.com/NUBIC/surveyor) is an awesome ruby gem and developer tool that brings surveys into Rails applications. Surveys are written in the Surveyor DSL (Domain Specific Language). If your Rails app needs to asks users questions as part of a survey, quiz, or questionnaire then you should consider using Surveyor.

This tutorial is to help Rails beginners implement and extend this gem in their Rails project.  The "kitchen sink" Survey in the [surveyor README](https://github.com/NUBIC/surveyor#readme) is a great place to get started, as is the "extending surveyor" README.  However, for beginners, I thought it might be useful to have an example that walks through how to tie the surveyor gem to your user model and make some basic customizations.

Surveyor Tutorial
- - -

1) Create a new repository on [GitHub](https://github.com) named 'surveyor_example'

2) Create a new rails project

    $ rails new surveyor_example
    $ cd surveyor_example

3) Open the project in your favorite text editor (example: I am using Sublime Text 2)

    $ subl .

4) Update the Gemfile. Cut & Paste the contents of this [tutorials Gemfile](https://github.com/diasks2/surveyor_example/blob/master/Gemfile) into your Gemfile

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


