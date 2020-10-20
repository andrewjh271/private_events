class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invitation, except: :create
  before_action :require_host!, only: [:create, :destroy]
  before_action :require_recipient!, only: [:accept, :pend, :decline]

  def create
    Invititation.create(invitation_params)
    redirect_back fallback_location: user_path
  end

  def destroy
    @invitation.destroy
    redirect_back fallback_location: user_path
  end

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

  def require_host!
    unless current_user.try(:id) == @invitation.event.host
      flash[:alert] = 'You are not authorized to edit this invitation!'
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