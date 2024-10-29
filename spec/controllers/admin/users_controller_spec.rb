# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  # GET /admin/users
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
        let(:user1) { create(:user) }
        let(:user2) { create(:user) }

        before do 
          sign_in(user)
          get :index
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access all users but itself" do
          expect(assigns(:users)).to eq([user1, user2])
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

        before do 
          sign_in(user)
          get :index
        end
        
        it 'redirects with an error message' do 
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end
  end

  # GET /admin/users/:id
  describe "#show" do
    let(:user) { create(:user) }
    let(:params) { { id: user.id } }

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
        let(:another_user) { create(:user, :employee) }

        before do 
          sign_in(user)
          params[:id] = another_user.id
          get :show, params: params 
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access another_user details" do
          expect(assigns(:user)).to eq(another_user)
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

        before do 
          sign_in(user)
          get :show, params: params
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
    end
  end

  # GET /admin/users/new
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

        it "can access user creation" do
          expect(assigns(:user)).to be_a(User)
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

        it "can access user creation" do
          expect(assigns(:user)).to be_a(User)
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

  # POST /admin/users
  describe "#create" do
    let(:params) { 
      {  
        user: {
          email: 'user@test.com',
          password: 'test123',
          name: 'Test User',
          employee_id: 'TEST123'
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
          params[:user][:id] = user.id
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
          params[:user][:id] = user.id
          sign_in(user)
          post :create, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("User was successfully created.")
        end

        it "can create a user" do
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user).email).to eq(params[:user][:email])
          expect(assigns(:user).name).to eq(params[:user][:name])
          expect(assigns(:user).employee_id).to eq(params[:user][:employee_id])
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }
        let(:another_user) { create(:user, :employee) }

        before do 
          params[:user][:id] = user.id
          sign_in(user)
          post :create, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("User was successfully created.")
        end

        it "can create a user" do
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user).email).to eq(params[:user][:email])
          expect(assigns(:user).name).to eq(params[:user][:name])
          expect(assigns(:user).employee_id).to eq(params[:user][:employee_id])
        end

        it "can create a user for a different user" do
          params[:user][:id] = another_user.id
          post :create, params: params
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user).email).to eq(params[:user][:email])
          expect(assigns(:user).name).to eq(params[:user][:name])
          expect(assigns(:user).employee_id).to eq(params[:user][:employee_id])
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

  # GET /admin/users/:id/edit
  describe "#edit" do
    let(:user) { create(:user) }
    let(:params) { { id: user.id } }

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
        let(:another_user) { create(:user, :employee) }

        before do 
          sign_in(user)
          params[:id] = another_user.id
          get :edit, params: params 
        end
        
        it "returns an HTTP 200" do
          expect(response).to have_http_status(200)
        end

        it "can access users" do
          expect(assigns(:user)).to eq(another_user)
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

        before do 
          sign_in(user)
          get :edit, params: params 
        end
        
        it 'redirects with an error message' do 
          get :edit, params: params 
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq("You are not authorized to access this page.")
        end
      end
    end
  end

  # PATCH /admin/users/:id
  describe "#update" do
    let(:user) { create(:user) }
    let(:params) { 
      {  
        id: user.id,
        user: {
          email: 'updateduser@test.com',
          password: 'updatedtest123',
          name: 'Updated Test User',
          employee_id: 'UPDATEST123'
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
          expect(flash[:notice]).to eq("User was successfully updated.")
        end

        it "can update a user" do
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user).email).to eq(params[:user][:email])
          expect(assigns(:user).name).to eq(params[:user][:name])
          expect(assigns(:user).employee_id).to eq(params[:user][:employee_id])
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }
        let(:another_user) { create(:user, :employee) }

        before do 
          sign_in(user)
          params[:id] = another_user.id
          patch :update, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("User was successfully updated.")
        end

        it "can update another user" do
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user).email).to eq(params[:user][:email])
          expect(assigns(:user).name).to eq(params[:user][:name])
          expect(assigns(:user).employee_id).to eq(params[:user][:employee_id])
        end
      end

      context 'when user have :employee permissions' do 
        let(:user) { create(:user, :employee) }

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
    end
  end

  # DELETE /admin/users/:id
  describe "#destroy" do
    let(:user) { create(:user) }
    let(:params) { 
      {  
        id: user.id
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
          expect(flash[:notice]).to eq("User was successfully deleted.")
        end

        it "can delete a user" do
          expect(User.accessible_by(user.ability)).to be_empty 
        end
      end

      context 'when user have :scheduler permissions' do 
        let(:user) { create(:user, :scheduler) }
        let(:another_user) { create(:user, :employee) }

        before do 
          sign_in(user)
          params[:id] = another_user.id
          delete :destroy, params: params
        end
        
        it "redirects with a success message" do
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq("User was successfully deleted.")
        end

        it "can delete another user" do
          expect(User.accessible_by(user.ability)).to be_empty
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