class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    Rails.logger.debug "=== CREATE USER ACTION STARTED ==="
    Rails.logger.debug "Step 1: Received params: #{params.inspect}"
    
    Rails.logger.debug "Step 2: Extracting user_params..."
    filtered_params = user_params
    Rails.logger.debug "Step 3: Filtered params: #{filtered_params.inspect}"
    
    Rails.logger.debug "Step 4: Creating new User instance..."
    @user = User.new(filtered_params)
    Rails.logger.debug "Step 5: User instance created: #{@user.inspect}"
    Rails.logger.debug "Step 6: User attributes: #{@user.attributes.inspect}"
    Rails.logger.debug "Step 7: User valid? #{@user.valid?}"
    
    unless @user.valid?
      Rails.logger.debug "Step 8: Validation errors: #{@user.errors.full_messages.inspect}"
    end
    
    respond_to do |format|
      Rails.logger.debug "Step 9: Attempting to save user..."
      
      if @user.save
        Rails.logger.debug "Step 10: ✅ User saved successfully! ID: #{@user.id}"
        Rails.logger.debug "Step 11: Redirecting to user show page..."
        
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        Rails.logger.debug "Step 10: ❌ User save failed!"
        Rails.logger.debug "Step 11: Save errors: #{@user.errors.full_messages.inspect}"
        Rails.logger.debug "Step 12: Rendering new form with errors..."
        
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    
    Rails.logger.debug "=== CREATE USER ACTION COMPLETED ==="
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      Rails.logger.debug "Parameter filtering: Raw params = #{params.inspect}"
      filtered = params.expect(user: [ :name, :email ])
      Rails.logger.debug "Parameter filtering: Filtered params = #{filtered.inspect}"
      filtered
    end
end
