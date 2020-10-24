require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  # include Devise::Test::ControllerHelpers

  # config.include Devise::Test::ControllerHelpers, type: :controller added to spec/rails_helper
  # in place of include call above, which also works
  
  # sign_in is a Devise ControllerHelper method that 'bypasses any warden authentication callback.'

  let(:user) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event) }

  describe 'GET #new' do
    it 'requires authenticated user' do
      get :new
      expect(response).to redirect_to(new_user_session_url)
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
    end


    it 'renders the new template for authenticated user' do
      sign_in user
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'without authentication' do
      it 'requires current_user' do
        post :create, params: { event: { name: 'Book Swap',
                                         date: '2022/11/11',
                                         location: 'San Diego Zoo',
                                         host: user } }
        expect(response).to redirect_to(new_user_session_url)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'with invalid params' do
      before(:each) { sign_in user }

      it 'validates the presence of name' do
        post :create, params: { event: { date: '2022/11/11',
                                         location: 'San Diego Zoo',
                                         host: user } }
        expect(response).to render_template(:new)
      end

      it 'validates the presence of date' do
        post :create, params: { event: { name: 'Book Swap',
                                         location: 'San Diego Zoo',
                                         host: user } }
        expect(response).to render_template(:new)
      end

      it 'validates the presence of location' do
        post :create, params: { event: { date: '2022/11/11',
                                         name: 'San Diego Zoo',
                                         host: user } }
        expect(response).to render_template(:new)
      end

      it 'validates that date is in the future' do
        post :create, params: { event: { date: '2019/11/11',
                                         name: 'Book Swap',
                                         location: 'San Diego Zoo',
                                         host: user } }
        expect(response).to render_template(:new)
      end
    end
    context 'with valid params' do
      before(:each) { sign_in user }

      it 'redirects to new event invitations page on success' do
        post :create, params: { event: { date: '2022/11/11',
                                         name: 'Book Swap',
                                         location: 'San Diego Zoo',
                                         host: user } }
        expect(flash[:notice]).to eq('Event was successfully created.')
        expect(response).to redirect_to(new_event_invitations_url(Event.last))
      end
    end
  end

  describe 'GET #show' do
    it 'shows event' do
      get :show, params: { id: event.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'requires authenticated user' do
      get :edit, params: { id: event.id }
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
    end

    it 'requires authorized user' do
      sign_in user
      get :edit, params: { id: event.id }
      expect(response).to redirect_to(root_url)
      expect(flash[:alert]).to eq('You are not authorized to edit this event!')
    end

    it 'renders the edit template for authorized user' do
      sign_in user
      event = FactoryBot.create(:event, host: user)
      get :edit, params: { id: event.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #update' do

    context 'without authentication' do
      it 'requires current_user' do
        patch :update, params: { event: { name: 'Soccer practice' }, id: event.id }
        expect(response).to redirect_to(new_user_session_url)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'without authorization' do
      it 'only allows host to update' do
        sign_in user
        patch :update, params: { event: { name: 'Soccer practice' }, id: event.id }
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to eq('You are not authorized to edit this event!')
      end
    end

    context 'with authorization' do

      before(:each) do
        sign_in user
        @event = FactoryBot.create(:event, host: user)
      end
      context 'with invalid params' do
  
        it 'validates name' do
          patch :update, params: { event: { name: nil }, id: @event.id }
          expect(response).to render_template(:edit)
        end
  
        it 'validates date is in future' do
          post :update, params: { event: { date: '2019/11/11' }, id: @event.id }
          expect(response).to render_template(:edit) 
        end
      end

      context 'with valid params' do
        it 'redirects to event show page on success' do
          post :update, params: { event: { title: 'Soccer practice' }, id: @event.id }
          expect(flash[:notice]).to eq('Event was successfully updated.')
          expect(response).to redirect_to(event_url(@event))
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'without authorization' do
      it 'only allows host to update' do
        sign_in user
        delete :destroy, params: { id: event.id }
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to eq('You are not authorized to edit this event!')
      end
    end

    context 'with authorization' do
      it 'destroys event and redirects to root' do
        sign_in user
        event = FactoryBot.create(:event, host: user)
        delete :destroy, params: { id: event.id }
        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to eq('Event was successfully deleted.')
      end
    end
  end
end