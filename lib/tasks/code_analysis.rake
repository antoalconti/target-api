task :code_analysis do
  sh 'bundle exec rubocop app config lib spec'
end
