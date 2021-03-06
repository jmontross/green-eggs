Given /^I have created a poll$/ do
  @poll = Factory(:poll)
end

Then /^"([^"]*)" should receive an email with a ballot link$/ do |email|
  unread_emails_for(email).size.should == 1
  msg = open_email(email)
  ballot = @poll.reload.ballots.last
  ballot_link = "http://#{ActionMailer::Base.default_url_options[:host]}/#{@poll.id}/#{ballot.key}"
  msg.body.should include(ballot_link)
end

Then /^I follow the ballot link$/ do
  click_first_link_in_email
end
