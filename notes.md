# TOM 2015-07-27

## Comments about config/initializers/twitter.rb
when working with external services, have a single class that wraps the few methods
separating into multiple files is probably over complicating it.

## On hitting a private method
TwitterClientWrapper does not have access to Twitter::REST::Client's private methods. (#collect_with_max_id)
Private method error is a red flag that i'm out of bounds.
When i hit a private method, i should wonder if i'm too 'deep' and look for a public api method.
this gem should provide some public methods, like 'get user tweets'

## before_actions use
before_actions should be used for things like ensure logged in. So, if this before_filter fails i'll redirect. Before_filters are environment setup activities

But loading up things that the action / template will use.
Because you can memoizing method @layout ||= Theme...

with before_filter might pass but it doesn't get to the action so it's somewhat irrelevant. But with momoized methods, i've gotten to the action i want. before_filters have these only and except blocks



# Jon D. 2015-07-09

## Example rake task

    namespace :hp do
      desc 'this is a test'
      task :my_task do
        puts 'got here!'
      end
    end


## PREFER OBJECTS OVER STRING
code smell if you're passing in a string over passing an object.
example:  Foo.user('dave')
it's okay if it's string parsing kind of work
but if it's not, better to pass a user object.

## Exceptions
should occur when something happens that means that the rest of this processing
from here on out can't go on.
example
user_profile(user)
if username doesn't exist - Exception: record not found. (AR::RecordNotFound)
working with exteral services - you will encounter an exception.


# Jon D. 2015-07-01

# HOMEWORK
Database Theory & Fundamentals


Get presenters into the view
View doesn't need to go plumbing around looking for it's data,
it's just a method.


# Jon Daniel 6/17/15

- live code the rake task.
- Rake task should pull tweets from DB first.
- if no db tweets (because rake task hasn't run) keep thing with a 'please tell dave to run rake task.'
- show page should show tweets from db, not from twitter for MVP.

## TODO
- Fetch data from twitter
- print to screen as json so we know what we want to store in our DB
- print out the other tweets to assemble

## DB DESIGN
QUESTIONS TO ASK

## what tables do we have in this app? 
HOLD OFF FROM DOING A SETTING or any EXTRA TABLES until absolutely necessary
_don't worry about fields_
- users (chief table) id, user, handle, has_many: tweets, polished_tweets
- polished_tweets text, tags, images, tweet_id, belongs to user, has_one raw_tweet
- raw_tweets - primary_id, json blob, raw_tweet_id, belongs to user, has_one: polished

## HOMEWORK
### 1. how are we going to save and retrieve tweets?
    opitmal data types for different values
    build basic tests around models - validation
    start doing a mysql migration and build models for them

### What do we need to store?
- does this have a #b?
- user_id
- tags
- text
- image info

## Last week deals went down. What caused it and how do we prepare for this?
- introduce specific issues for a couple hours a month.
- see how the application breaks and provide best way to solve them. In the spirit of building fault tolerant software.

# Jon Daniel 6/2/15

LEt's write a rake task to explore.
rake tasks help explore an idea rather than build an app

=begin

  blog: https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/48-advanced-modules/lessons/117-included-and-extend

  two: http://ruby-doc.org/core-2.2.2/Module.html

  adding both class and object methods.
  this way would let you add both with 'include'
  rather than added include FOO and extend FOO::ClassMethods


    Person.find() # class context
    person.addresses.find(:blah) # object context

  module ClassMethods
  end

  def included(klass)
    klass.extend(TweetParser::ClassMethods)
  end
=end


## features
print param we pass in.

    namespace :twitter do
      task :index_tweets, [:handle] => [:environment] do # => :environment specifies dependencies.
        puts "hello #{:handle}!"
        # rake twitter:index_tweets(handle)
      end
    end

    [ 14:31 06/03 ] ~/Dropbox/300_code/learn/hashPage
    [ master * ] $ be rake twitter:get(:wwwoodall)
    bash: syntax error near unexpected token `('

    [ 14:35 06/03 ] ~/Dropbox/300_code/learn/hashPage
    [ master * ] $ be rake twitter:get[wwwoodall]
    wwwoodall

    [ 14:36 06/03 ] ~/Dropbox/300_code/learn/hashPage
    [ master * ] $ be rake twitter:get wwwoodall

    rake aborted!
    Don't know how to build task 'wwwoodall'

    (See full trace by running task with --trace)


# Tom Copeland 6/1/15

1. Business idea.

2. Product person defines what happens when a user does X.
### high level user stories
- as a user when i sign in using twitter, i expect my hash page to start working
— break that down further
    - as a user (system stories)

### System stories
- in order to make a hashpage work i have to fetch the tweets
- and then process them

## Rules
- need to store how many times we fetch tweets
- need to set rules of when / how we fetch tweets
- figure out how we store tweets (whole blob, or upfront parsing, or raw data with bg job)


## decisions to make in terms of generating hashpage that the user sees

(Already have the tweets…)

### step 1 options…

### Questions
how to control the fetching of tweets
- gets data into system

how to generate the website based on content of tweets
- determines how fast you want the site to be.

#### option 1 - easy but slower?  (do on fly)
#### option 2 - fast but more complicated (storage questions)

### steps 2 - 4 are the same.
#### 2. parse tweets
#### 3. extract
#### 4. generate page


## HOMEWORK - DB MODEL
- timestamps, id, blob, textarea 65k - tweets


# Jon Daniel 5/13

## When multiple tests fail

Q - what’s going on?
- is it configurations? (how the tests setup)
- is it environment? (diff version of mysql, osx, etc.)
- are these tests just broken? (Check CI)

Don’t make changes until the build passes. May need to comment out some tests.

Focus on the deepest test possible first (not a view or controller, but more of a service, or model, or any library)


# Tom Copeland

5/11

 Why to use attr_reader :tweets?
 Could also have a private method called tweets to further manipulate b/c now I have a hook to get into.
 Example;
 def tweets
   @tweets.reverse
 end
