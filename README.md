# Private Events

Created as part of the Odin Project curriculum. View live page.

For full functionality sign up or login with *odin@example.com* and *password*.

### Functionality

Logged in users can create, edit, and invite/uninvite other users to their own events. Users can change their RSVPs to upcoming invitations, but not to past ones.

Event hosts can only uninvite users who have not yet confirmed their attendance and can only update the invitation list for upcoming events.

### Thoughts

One of the main challenges I ran into was deciding how to allow event hosts to invite guests. With my current form skillset a checkbox seemed to be the best option, but ideally there would be a text field that autocompletes from the database of users. I struggled for a long time to try for an efficient way of prechecking the box of any user who was already invited:

```ruby
User.order(:username).includes(:invitations).each do |user|
{ checked: user.invitations.any? { |inv| inv.event_id == @event.id } } # Ruby; no index
{ checked: user.invitations.exists?(event: @event) } # n+1 query
  
User.all.order(:username)
  .includes(:invitations)
  .where('invitations.event_id = ?', @event.id)
  .references(:invitations).each #where clause filters users, not invitations

{ checked: @event.invitations.exists?(recipient_id: user.id) }) # n+1 query
{ checked: @event.invitations.any? { |inv| inv.recipient_id == user.id } } # Ruby; no index

temp_invitations = @event.invitations.pluck(:recipient_id)
{ checked: !!temp_invitations.delete(user.id) } # much faster than anything else I tried

```

My eventual solution has the advantages of only making one query, storing a relatively lightweight array of `recipient_id` integers, and diminishing average search times as found elements are deleted from the array. It was much faster than any alternative I tried. Still, it doesn't feel like the most elegant solution.

Another big disadvantage of the checkbox approach for invitations was that I need to handle every username every time, since there's no way to know which ones changed and target only those. For a large database of users this implementation would need to improve.

I had to use `user.username` instead of `f.label(user.id, user.username)` for the checkbox labels in order to get them to display inline.

I used a scaffold generator for the `Event` model, which again proved helpful and educational.

For this project I was a little picker about the styling, and decided I didn't want the `field-with-error` class applied on `label` elements. To avoid that particular piece of Rails magic I just went with the raw html `<label for='event_name'>Name</label>` instead of `<%#= form.label :name %>`.

##### Testing

I wrote tests from scratch for `spec/controllers/events_controller_spec.rb`, and  `spec/models/*` with techniques I learned from App Academy, using the `shoulda-matchers`, `rails-controller-testing`, and `factory-bot-rails` gems. In projects where I wrote my own authorization I had been using this helper method to stub methods related to authentication:

```ruby
def login(user)
  allow_any_instance_of(ApplicationController).to receive(:current_user) { user }
  allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
end
```

With Devise, however, I just needed to add these lines to `spec/rails_helper.rb`:

```ruby
config.include Devise::Test::IntegrationHelpers, type: :request
config.include Devise::Test::ControllerHelpers, type: :view
config.include Devise::Test::ControllerHelpers, type: :controller
```

Then I could use the simple `sign_in user`.

Because `rspec-rails` was already bundled when I generated the `Event` scaffolding, a bunch of tests were generated in the `spec` folder. I decided to look into these and make them pass as well since they contained techniques I hadn't seen before.

I didn't encounter too many snags here, but getting syntax that worked for stuff like `assert_select "div", /Nov 11 2022 12:00am/, count: 1` in the view specs took me a while. 

I was also getting this quirky error with the views:

```
ActionView::Template::Error:
       Error: Function rgb is missing argument $green.
               on line 465 of stdin
       >>   background-color: rgb(216 216 216);
```

The issue was the missing alpha value in `application.css` (which was not actually an issue outside the view tests), but I was confused about line 465 and mentions of stdin, which didn't correspond to anything in my project folder but were probably results of the Asset Pipeline.

-Andrew Hayhurst