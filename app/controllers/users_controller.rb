class UsersController < ApplicationController
 before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers] #Requiring a logged-in user for the index action
 before_action :correct_user,   only: [:edit, :update]
 before_action :admin_user,     only: :destroy   #A before filter restricting the destroy action to admins.

  #@users = User.all

  COUNTRIES = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados",
    "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde",
    "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti",
    "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon",
    "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary",
    "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia",
    "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte",
    "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue",
    "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda",
    "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena",
    "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands",
    "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]


  def user_profile
    begin
      @user = User.find(@_env["HTTP_REFERER"].last)
      render json: {name: @user.name , email: @user.email }

    rescue ActiveRecord::RecordNotFound => e
      @user = nil
      render json: {name: 'vizhooels', email: 'abunawose@vizhooels.com' }
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def search
    @user = User.find(params[:id] || params[:user_id]) || current_user
    @categories = []
    @options    = {}
    if params[:search].blank?
      flash.now[:danger] = "Invalid title search"
      @feed_items = []
    else

      if params[:category]
        @feed_items = @user.feed.where("content LIKE ?", "%#{params[:search].upcase.strip}%").where("category LIKE ?", "%#{ params[:category].upcase.strip}%").paginate(page: params[:page])
      else
        @feed_items = @user.feed.where("content LIKE ?", "%#{params[:search].upcase.strip}%").paginate(page: params[:page])
      end


      @categories = _creat_menu_categories(@feed_items)

      #_set_default_categories(@feed_items)

    end
  end


  def new
    @countries = COUNTRIES
    @user = User.new
  end

  def show
    begin
      @user = User.find(params[:id] || params[:user_id]) || current_user
      @microposts = @user.microposts

      #_set_default_categories(@user.microposts)

      @categories = []
      @options    = {}
      @categories = _creat_menu_categories(@microposts)
      @spacial = @categories.select {|mic| mic.category == "SPECIAL OF THE DAY"}.first || nil
    rescue ActiveRecord::RecordNotFound => e
      @user = nil
      flash.now[:danger] = "User does not exists."
    end
  end

  def category_search
    @user = User.find(params[:id] || params[:user_id]) || current_user
    @microposts = @user.microposts

    unless params[:category][:title].present?
      flash.now[:danger] = "Invalid category search"
      @feed_items = []
    else
      @selected_cat = @microposts.select {|mic| mic.category == params[:category][:title] }
      @category = params[:category][:title]
      @category_title = params[:category][:title]
      @feed_items = @microposts.where(:category => params[:category][:title])
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash.now[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  #Adding a working destroy action.
  def destroy
    User.find(params[:id]).destroy
    flash.now[:success] = "User deleted"
    redirect_to users_url
  end

  #The following and followers actions.
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def _creat_menu_categories(feed_items)
      no_doubles = []
      feed_items.each do |micropost|
        if micropost.category.present?
          unless no_doubles.map(&:category).include?(micropost.category)
            no_doubles.push(micropost)
            @options[micropost.category] = @user.microposts.where(:category => micropost.category)
          end
        end
      end
      no_doubles
    end

    def user_params
      params.require(:user).permit(
                            :name, :email, :password,
                            :password_confirmation, :phone,
                            :address_line1, :address_line2,
                            :city, :region, :postal_code, :country)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash.now[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
