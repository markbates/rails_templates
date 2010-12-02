gem 'acts-as-taggable-on'

run 'bundle install'

generate('acts_as_taggable_on:migration')

rake 'db:migrate'