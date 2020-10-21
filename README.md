# Private Events

### Functionality



### Thoughts

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

```

