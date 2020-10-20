class InvitationsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_event, only: [:new, :create, :edit, :update]
  before_action :require_host!, only: [:new, :create, :edit, :update]

  before_action :set_invitation, only: [:accept, :pend, :decline]
  before_action :require_recipient!, only: [:accept, :pend, :decline]

  def new
    # @event = Event.find_by(id: params[:event_id])
  end

  def create
    # fail
    params[:recipient].select { |_k, v| v == '1' }.keys.map(&:to_i).each do |user_id|
      @event.invitations.find_or_create_by(recipient_id: user_id)
    end
    redirect_to event_url(@event)
  end

  def edit

  end

  def update
    params[:recipient].each do |user_id, value|
      if value == '1'
        @event.invitations.find_or_create_by(recipient_id: user_id.to_i)
      else
        @event.invitations.find_by(recipient_id: user_id.to_i).try(:destroy)
      end
    end
    redirect_to event_url(@event)
  end

  # def destroy
  #   @invitation.destroy
  #   redirect_back fallback_location: user_path
  # end

  def accept
    @invitation.update(rsvp: 'ACCEPTED')
    redirect_back fallback_location: user_path
  end

  def pend
    @invitation.update(rsvp: 'PENDING')
    redirect_back fallback_location: user_path
  end

  def decline
    @invitation.update(rsvp: 'DECLINED')
    redirect_back fallback_location: user_path
  end

  private

  def invitation_params
    params.require(:invitation).permit(:event_id, :recipient_id)
  end

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def require_host!
    unless current_user.try(:id) == @event.host_id
      flash[:alert] = 'You are not authorized to edit invitations for this event!'
      redirect_to root_url
    end
  end

  def require_recipient!
    unless current_user.try(:id) == @invitation.recipient_id
      flash[:alert] = 'You are not authorized to respond to this invitation!'
      redirect_to root_url
    end
  end
end