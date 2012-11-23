And /^there is publisher with id, "([^"]*)"$/ do |user_id|
  User.create!({:login => user_id,
                :password => 'password',
                :email => user_id + '@test.com',
                :profile_id => 2,
                :name => user_id,
                :state => 'active'})
end

And /^there is contributor with id, "([^"]*)"$/ do |user_id|
  User.create!({:login => user_id,
                :password => 'password',
                :email => user_id + '@test.com',
                :profile_id => 3,
                :name => user_id,
                :state => 'active'})
end

And /^the following articles exist:$/ do |articles_table|
  articles_table.hashes.each do |article|
    Article.create!(article)
  end
end

Given /^I am logged into the admin panel as "([^"]*)"$/ do |user_id|
  visit '/accounts/login'
  fill_in 'user_login', :with => user_id
  fill_in 'user_password', :with => 'password'
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end

And /^"([^"]*)" writes article "([^"]*)" with "([^"]*)"$/ do |user, article_title, article_body|
  step %Q(I am logged into the admin panel as "#{user}")
  step %Q(I go to the new article page)
  step %Q(fill in "article_title" with "#{article_title}")
  step %Q(I fill in "article__body_and_extended_editor" with "#{article_body}")
  step %Q(I press "Publish")
  step %Q(I log out)
end

And /^I log out$/ do
  visit '/accounts/logout'
end

Given /^"([^"]*)" has comment "([^"]*)"$/ do |article_title, comment|
  article = Article.find_by_title(article_title)
  article.comments.create(:body => comment, :author => 'Commenter1', :state => 'ham', :created_at => '2005-01-01 02:00:00', :updated_at => '2005-01-01 02:00:00', :published_at => '2005-01-01 02:00:00')
  article.save
end

Then /^I should see "([^"]*)" field$/ do |label|
  page.should have_field(label)
end

Then /^I should not see "([^"]*)" field$/ do |label|
  page.should have_no_field(label)
end

Then /^I should see "([^"]*)" button$/ do |label|
  page.should have_button(label)
end

Then /^I should not see "([^"]*)" button$/ do |label|
  page.should have_no_button(label)
end

When /^I fill in "([^"]*)" with article ID of "([^"]*)"$/ do |field, article_title|
  article = Article.find_by_title(article_title)
  fill_in field, :with => article.id
end

Then /^I should see editor having "([^"]*)"$/ do |content|
  step %Q(I should see \"article__body_and_extended_editor\" having "#{content}")
end

Then /^I should see title field having "([^"]*)"$/ do |content|
  step %Q(I should see \"article_title\" having "#{content}")
end

Then /^I should see "([^"]*)" having "([^"]*)"$/ do |field, content|
  find_field(field).value.should =~ Regexp.new(Regexp.escape(content))
end

Then /^I can merge "([^"]*)" and "([^"]*)" by RESTful link$/ do |article_title_1, article_title_2|
  article_1 = Article.find_by_title(article_title_1)
  article_2 = Article.find_by_title(article_title_2)
  visit "/admin/content/merge/#{article_1.id}?merge_with=#{article_2.id}"
  page.should have_content("Articles were successfully merged.")
end

Then /^I should see Author of "([^"]*)" is "([^"]*)"$/ do |article_title, article_author|
  assert_equal article_author, Article.find_by_title("#{article_title}").author
end

Then /^I should see "([^"]*)" has comment "([^"]*)"$/ do |article_title, comment|
end
