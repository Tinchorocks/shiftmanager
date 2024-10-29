# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
  # GET /shifts
  describe "#index" do
    context 'when user is not logged' do 
      it 'doesnt raise CanCan::AccessDenied' do 
        expect { get :index }.not_to raise_error
      end

      it 'redirects with an error message' do 
        get :index
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context 'when user is logged in' do 
      context 'when user doesnt have permissions' do 
        let(:user) { create(:user) }
        
        before do 
          sign_in(user)
        end

        it 'doesnt raise CanCan::AccessDenied' do 
          expect { get :index }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          get :index
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end

      context 'when user have :admin permissions' do 
        let(:user) { create(:user, :admin) }

        before do 
          sign_in(user)
          get :index
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }
        let(:shift1) { create(:shift, start_time: Time.now.days_ago(-1).change(hour: 12), end_time: Time.now.days_ago(-1).change(hour: 13)) }
        let(:shift2) { create(:shift, start_time: Time.now.days_ago(-1).change(hour: 22), end_time: Time.now.days_ago(-1).change(hour: 23)) }
        
        before do 
          sign_in(user)
          get :index
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access all shifts" do
          expect(assigns(:shifts)).to eq([shift1, shift2])
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }
        let(:shift1) { create(:shift) }
        let(:shift2) { create(:shift, user: user) }

        before do 
          sign_in(user)
          get :index
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access only his own shifts" do
          expect(assigns(:shifts)).to eq([shift2])
        end
      end
    end
  end

  # GET /shifts/:id
  describe "#show" do
    let(:shift) { create(:shift) }
    let(:params) { { id: shift.id } }

    context 'when user is not logged' do 
      it 'doesnt raise CanCan::AccessDenied' do 
        expect { get :show, params: params }.not_to raise_error
      end

      it 'redirects with an error message' do 
        get :show, params: params 
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context 'when user is logged in' do 
      context 'when user doesnt have permissions' do 
        let(:user) { create(:user) }
        
        before do 
          sign_in(user)
        end

        it 'doesnt raise CanCan::AccessDenied' do 
          expect { get :show, params: params  }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          get :show, params: params 
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end

      context 'when user have :admin permissions' do 
        let(:user) { create(:user, :admin) }

        before do 
          sign_in(user)
          get :show, params: params 
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }

        before do 
          sign_in(user)
          get :show, params: params 
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access shift" do
          expect(assigns(:shift)).to eq(shift)
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

        before do 
          sign_in(user)
          get :show, params: params 
        end
        
        context 'when shift is for another employee' do 
          it 'redirects with an error message' do 
            get :show, params: params 
            expect(response).to have_http_status(302)
            expect(flash[:alert]).to eq("You are not authorized to access this page.")
          end
        end

        context 'when shift is for itself' do 
          let(:user_shift) { create(:shift, user: user) }
          let(:params) { { id: user_shift.id } }

          before do 
            get :show, params: params 
          end

          it "returns an HTTP 200" do
            expect(response).to have_http_status(200)
          end
          
          it "can access his own shift" do
            expect(assigns(:shift)).to eq(user_shift)
          end
        end
      end
    end
  end

  # GET /shifts/new
  describe "#new" do
    context 'when user is not logged' do 
      it 'doesnt raise CanCan::AccessDenied' do 
        expect { get :new }.not_to raise_error
      end

      it 'redirects with an error message' do 
        get :new
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context 'when user is logged in' do 
      context 'when user doesnt have permissions' do 
        let(:user) { create(:user) }
        
        before do 
          sign_in(user)
        end

        it 'doesnt raise CanCan::AccessDenied' do 
          expect {  get :new  }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          get :new
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end

      context 'when user have :admin permissions' do 
        let(:user) { create(:user, :admin) }

        before do 
          sign_in(user)
          get :new 
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access shift creation" do
          expect(assigns(:shift)).to be_a(Shift)
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }

        before do 
          sign_in(user)
          get :new 
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access shift creation" do
          expect(assigns(:shift)).to be_a(Shift)
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

        before do 
          sign_in(user)
           get :new 
        end
        
        it 'doesnt raise CanCan::AccessDenied' do 
          expect {  get :new  }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          get :new
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end
  end

  # POST /shifts
  describe "#create" do
    let(:params) { 
      {  
        shift: {
          start_time: Time.now.days_ago(-1).change(hour: 12), # Tomorrow at 12
          end_time: Time.now.days_ago(-1).change(hour: 13), # Tomorrow at 13
          acknowledged: false,
          notes: 'Test Notes.'
        }
      }
    }
    
    context 'when user is not logged' do 
      it 'doesnt raise CanCan::AccessDenied' do 
        expect { post :create, params: params }.not_to raise_error
      end

      it 'redirects with an error message' do 
        post :create, params: params
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context 'when user is logged in' do 
      context 'when user doesnt have permissions' do 
        let(:user) { create(:user) }
        
        before do 
          params[:shift][:user_id] = user.id
          sign_in(user)
        end

        it 'doesnt raise CanCan::AccessDenied' do 
          expect { post :create, params: params }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          post :create, params: params
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end

      context 'when user have :admin permissions' do 
        let(:user) { create(:user, :admin) }

        before do 
          params[:shift][:user_id] = user.id
          sign_in(user)
          post :create, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("Shift was successfully created.")
        end

        it "can create a shift" do
          expect(assigns(:shift)).to be_a(Shift)
          expect(assigns(:shift).start_time).to eq(params[:shift][:start_time])
          expect(assigns(:shift).end_time).to eq(params[:shift][:end_time])
          expect(assigns(:shift).notes).to eq(params[:shift][:notes])
          expect(assigns(:shift).acknowledged).to eq(params[:shift][:acknowledged])
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }
        let(:another_user) { create(:user, :employee) }

        before do 
          params[:shift][:user_id] = user.id
          sign_in(user)
          post :create, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("Shift was successfully created.")
        end

        it "can create a shift" do
          expect(assigns(:shift)).to be_a(Shift)
          expect(assigns(:shift).start_time).to eq(params[:shift][:start_time])
          expect(assigns(:shift).end_time).to eq(params[:shift][:end_time])
          expect(assigns(:shift).notes).to eq(params[:shift][:notes])
          expect(assigns(:shift).acknowledged).to eq(params[:shift][:acknowledged])
        end

        it "can create a shift for a different user" do
          params[:shift][:user_id] = another_user.id
          post :create, params: params
          expect(assigns(:shift)).to be_a(Shift)
          expect(assigns(:shift).start_time).to eq(params[:shift][:start_time])
          expect(assigns(:shift).end_time).to eq(params[:shift][:end_time])
          expect(assigns(:shift).notes).to eq(params[:shift][:notes])
          expect(assigns(:shift).acknowledged).to eq(params[:shift][:acknowledged])
          expect(assigns(:shift).user.id).to eq(params[:shift][:user_id])
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

        before do 
          sign_in(user)
           post :create, params: params
        end
        
        it 'doesnt raise CanCan::AccessDenied' do 
          expect {  post :create, params: params }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          post :create, params: params
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end
  end

  # GET /shifts/:id/edit
  describe "#edit" do
    let(:shift) { create(:shift) }
    let(:params) { { id: shift.id } }

    context 'when user is not logged' do 
      it 'doesnt raise CanCan::AccessDenied' do 
        expect { get :edit, params: params }.not_to raise_error
      end

      it 'redirects with an error message' do 
        get :edit, params: params 
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context 'when user is logged in' do 
      context 'when user doesnt have permissions' do 
        let(:user) { create(:user) }
        
        before do 
          sign_in(user)
        end

        it 'doesnt raise CanCan::AccessDenied' do 
          expect { get :edit, params: params  }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          get :edit, params: params 
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end

      context 'when user have :admin permissions' do 
        let(:user) { create(:user, :admin) }

        before do 
          sign_in(user)
          get :edit, params: params 
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }

        before do 
          sign_in(user)
          get :edit, params: params 
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access shift" do
          expect(assigns(:shift)).to eq(shift)
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

        before do 
          sign_in(user)
          get :edit, params: params 
        end
        
        context 'when shift is for another employee' do 
          it 'redirects with an error message' do 
            get :edit, params: params 
            expect(response).to have_http_status(302)
            expect(flash[:alert]).to eq("You are not authorized to access this page.")
          end
        end

        context 'when shift is for itself' do 
          let(:user_shift) { create(:shift, user: user) }
          let(:params) { { id: user_shift.id } }

          before do 
            get :edit, params: params 
          end

          # An employee shouldnt be able to edit shifts, only read them
          # Update by an employee should only happen when a shift is acknowledged
          it 'redirects with an error message' do 
            get :edit, params: params 
            expect(response).to have_http_status(302)
            expect(flash[:alert]).to eq("Employees cant edit shifts.")
          end
        end
      end
    end
  end

  # PATCH /shifts/:id
  describe "#update" do
    let(:shift) { create(:shift) }
    let(:params) { 
      {  
        id: shift.id,
        shift: {
          start_time: Time.now.days_ago(-1).change(hour: 20), # Tomorrow at 20
          end_time: Time.now.days_ago(-1).change(hour: 21), # Tomorrow at 21
          acknowledged: true,
          notes: 'Test Update Notes.'
        }
      }
    }
    
    context 'when user is not logged' do 
      it 'doesnt raise CanCan::AccessDenied' do 
        expect { patch :update, params: params }.not_to raise_error
      end

      it 'redirects with an error message' do 
        patch :update, params: params
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context 'when user is logged in' do 
      context 'when user doesnt have permissions' do 
        let(:user) { create(:user) }
        
        before do 
          sign_in(user)
        end

        it 'doesnt raise CanCan::AccessDenied' do 
          expect { patch :update, params: params }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          patch :update, params: params
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end

      context 'when user have :admin permissions' do 
        let(:user) { create(:user, :admin) }

        before do 
          sign_in(user)
          patch :update, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("Shift was successfully updated.")
        end

        it "can update a shift" do
          expect(assigns(:shift)).to be_a(Shift)
          expect(assigns(:shift).start_time).to eq(params[:shift][:start_time])
          expect(assigns(:shift).end_time).to eq(params[:shift][:end_time])
          expect(assigns(:shift).notes).to eq(params[:shift][:notes])
          expect(assigns(:shift).acknowledged).to eq(params[:shift][:acknowledged])
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }
        let(:another_user_shift) { create(:shift, user: create(:user, :employee)) }

        before do 
          sign_in(user)
          patch :update, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("Shift was successfully updated.")
        end

        it "can update a shift" do
          expect(assigns(:shift)).to be_a(Shift)
          expect(assigns(:shift).start_time).to eq(params[:shift][:start_time])
          expect(assigns(:shift).end_time).to eq(params[:shift][:end_time])
          expect(assigns(:shift).notes).to eq(params[:shift][:notes])
          expect(assigns(:shift).acknowledged).to eq(params[:shift][:acknowledged])
        end

        it "can update a shift related to another user" do
          params[:id] = another_user_shift.id
          patch :update, params: params
          expect(assigns(:shift)).to be_a(Shift)
          expect(assigns(:shift).start_time).to eq(params[:shift][:start_time])
          expect(assigns(:shift).end_time).to eq(params[:shift][:end_time])
          expect(assigns(:shift).notes).to eq(params[:shift][:notes])
          expect(assigns(:shift).acknowledged).to eq(params[:shift][:acknowledged])
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }
        let(:user_shift) { create(:shift, user: user, start_time: Time.now.days_ago(-1).change(hour: 22), end_time: Time.now.days_ago(-1).change(hour: 23))}

        before do 
          sign_in(user)
        end

        context 'when shift is related to another user' do 
          before do 
            patch :update, params: params
          end

          it 'doesnt raise CanCan::AccessDenied' do 
            expect { patch :update, params: params }.not_to raise_error
          end
          
          it 'redirects with an error message' do 
            patch :update, params: params
            expect(response).to have_http_status(302)
            expect(flash[:alert]).to eq("You are not authorized to access this page.")
          end
        end

        context 'when shift is owned by employee' do 
          before do 
            user_shift.update!(acknowledged: false)
            params[:id] = user_shift.id
            params[:shift][:start_time] = Time.now.days_ago(-3).change(hour: 5)
            params[:shift][:end_time] = Time.now.days_ago(-3).change(hour: 6)
            params[:shift][:notes] = 'Test Update Notes'
            params[:shift][:acknowledged] = true
            patch :update, params: params
          end

          it 'redirects with a success message' do 
            expect(response).to have_http_status(302)
            expect(flash[:notice]).to eq("Shift was successfully acknowledged.")
          end

          it 'updates shift acknowledged' do 
            expect(assigns(:shift).acknowledged).to eq(params[:shift][:acknowledged])
          end

          it 'doesnt update other than acknowledged field' do 
            expect(assigns(:shift).start_time).not_to eq(params[:shift][:start_time])
            expect(assigns(:shift).end_time).not_to eq(params[:shift][:end_time])
            expect(assigns(:shift).notes).not_to eq(params[:shift][:notes])
          end
        end
      end
    end
  end

  # DELETE /shifts/:id
  describe "#destroy" do
    let(:shift) { create(:shift) }
    let(:params) { 
      {  
        id: shift.id
      }
    }
    
    context 'when user is not logged' do 
      it 'doesnt raise CanCan::AccessDenied' do 
        expect { delete :destroy, params: params }.not_to raise_error
      end

      it 'redirects with an error message' do 
        delete :destroy, params: params
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context 'when user is logged in' do 
      context 'when user doesnt have permissions' do 
        let(:user) { create(:user) }
        
        before do 
          sign_in(user)
        end

        it 'doesnt raise CanCan::AccessDenied' do 
          expect { delete :destroy, params: params }.not_to raise_error
        end
  
        it 'redirects with an error message' do 
          delete :destroy, params: params
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end

      context 'when user have :admin permissions' do 
        let(:user) { create(:user, :admin) }

        before do 
          sign_in(user)
          delete :destroy, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("Shift was successfully deleted.")
        end

        it "can delete a shift" do
          expect(Shift.all).to be_empty 
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }

        before do 
          sign_in(user)
          delete :destroy, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("Shift was successfully deleted.")
        end

        it "can delete a shift" do
          expect(Shift.all).to be_empty
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

        before do 
          sign_in(user)
          delete :destroy, params: params
        end

        it 'doesnt raise CanCan::AccessDenied' do 
          expect { delete :destroy, params: params }.not_to raise_error
        end
        
        it 'redirects with an error message' do 
          delete :destroy, params: params
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end
  end
end