require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
require 'bcrypt'
require 'date'
require 'sinatra/flash'
require "carrierwave"
require 'carrierwave/orm/activerecord'
require 'active_support/number_helper'

#Configure Carrierwave
CarrierWave.configure do |config|
  config.root = File.dirname(__FILE__) + "/public"
end

set :database, {adapter: 'mysql2', database: 'guysdb', username: 'someguy', password: 'justguyshere'}

def validate_user
  if session[:guserid]
    @guser = GUser.find(session[:guserid])
  end
end

class GuysRateThingsApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  get "/" do
    validate_user
    etype = "eList";
    @dispList = List.where("approved = ?", true).order(created_at: :desc).limit(15)
    @elist = List.where(approved: true, lType: "elist").order(created_at: :desc).limit(4)
    erb:index
  end

  get "/logOut" do
    session[:guserid] = false
    redirect back
  end
  get "/about" do
    validate_user
    erb:about
  end

  get "/register" do 
    puts "ERROR MESSAGE: " + flash[:err].to_s
    erb:register
  end
  get "/listDisplay" do
    validate_user
    erb:listDisplay
  end

  #admin pae that lists any user created lists that have
  #not been approved
  get "/listApproval" do
    validate_user
    if(!@guser.blank?)
      if(@guser.admin == true)
        @notApp = List.where("approved = ?", false)
        erb:approvalLists
      else
        redirect "/"
      end
    else
      redirect"/"
    end 
  end

  #admin page that lists any user profile images that
  #have not been approved
  get "/approval" do
    validate_user
    if(!@guser.blank?)
      if(@guser.admin == true)
        @notApp = GUser.where("pic_approved = ?", false)
        erb:approval
      else
        redirect "/"
      end
    else
      redirect"/"
    end
  end
  
  #page for administrators to enable/disable or delete accounts
  get "/manageUsers" do
    validate_user
    if @guser.blank? || !@guser.admin
      redirect "/"
    end

    @basicUsers = GUser.where(admin: false).order(username: :asc)
    erb :manageUsers
  end

  #enable or disable a user account
  post "/activateProcess" do
    payload = request.body.read
    puts "Recieved " + payload
    data = JSON.parse(payload)

    user = GUser.find_by(username: data["user"])
    user.update(active: data["activate"])
    
    content_type :json
    {
      userActive: user.active
    }.to_json
  end

  post "/deleteUserProcess" do
    payload = request.body.read
    puts "Received " + payload
    data = JSON.parse(payload)

    user = GUser.find_by(username: data["user"])

    #delete any following/follower links
    followerRecords = Follower.where(user_id: user.id)
    followingRecords = Follower.where(follower_id: user.id)
    for foll in followerRecords do
      foll.delete
    end
    for foll in followingRecords do
      foll.delete
    end

    #delete any lists that were made by this user
    lists = List.where(user_id: user.id)
    for lst in list do
      items = ListItem.where(list_id: lst.id)
      for it in items do
        it.delete
      end
      lst.delete
    end
    
    #delete the user
    user.delete
    
    content_type :json
    {
      success: true
    }.to_json
  end

  get"/search" do
    validate_user
    
    erb :search
  end

  #a user's profile page
  get "/profile/:user" do
    validate_user
    @user =  GUser.find_by(username: params[:user])
    if @user.blank?
      redirect "/"
    end
    id = @user.id
    bio = @user.bio_text
    creation_date = @user.created_at
    fname = @user.fname
    lname = @user.lname
    pimg = @user.profilepic.url
    username = @user.username
    gp = @user.guypoints
    approved = @user.pic_approved
    @user_lists = List.where(user_id: @user.id)
    list_count = @user_lists.count
    isGUSerFollowing = false
    follower_count = Follower.where(user_id: @user.id).count
    following_count = Follower.where(follower_id: @user.id).count
    if !@guser.blank?
      isGUserFollowing = !Follower.where(user_id: @user.id, follower_id: @guser.id).blank?
    end
    
    @pfile = {username: username, bio: bio, fname: fname, lname: lname, pimg: pimg, cd: creation_date, fc: follower_count, fingc: following_count,  lc: list_count,id: id, papp: approved, isFollowing: isGUserFollowing, guypoints: gp}
    erb :profile
  end

  #displaying a list
  get "/profile/:user/:unique" do
    validate_user
    @user =  GUser.find_by(username: params[:user])
    if @user.blank?
      redirect "/"
    end
    @glist = List.find_by(user_id: @user.id, unique: params[:unique])
    if @glist.blank?
      redirect "/"
    end
    if((@guser.blank? ||  @guser.admin == false) && @glist.approved == false)
      redirect "/"
    end 
    @items = ListItem.where(list_id: @glist.id)

    if(@guser.blank?)
      @likeByMe = false
    else
      @likeByMe = !ListLike.find_by(list_id: @glist.id, user_id: @guser.id).blank?
    end
    erb :list
  end

  get "/profile/:user/display/followers" do
    validate_user
    @user = GUser.find_by(username: params[:user])    
    if @user.blank?
      redirect "/"
    end
    followersIDList = Follower.where(user_id: @user.id)    
    @followersList = Array.new
    for fol in followersIDList do
      follower = GUser.find(fol.follower_id)
      @followersList.append(follower)
    end  
    erb :followersPage
  end

  get "/profile/:user/display/following" do
    validate_user
    @user = GUser.find_by(username: params[:user])
    if @user.blank?
      redirect "/"
    end
    followingIDList = Follower.where(follower_id: @user.id)
    @followingList = Array.new
    for fol in followingIDList do
      follower = GUser.find(fol.user_id)
      @followingList.append(follower)
    end    
    erb :followingPage
  end
  
  get "/elist/view/:unique" do
    validate_user
    @glist = List.find_by(unique: params[:unique])
    if @glist.blank?
      redirect "/"
    end
    @items = ListItem.where(list_id: @glist.id).order(value: :desc)
    @user = GUser.find_by(id: @glist.user_id)
    erb :elistV
  end
  
  get "/elist/join/:unique" do
    validate_user
    @glist = List.find_by(unique: params[:unique])
    if @glist.blank?
      redirect "/"
    end
    item = ListItem.where(list_id: @glist.id).order('RAND()').limit(2)
    @right = item.first()
    @left = item.last()
    while(@right == @left)
      @left = ListItem.where(list_id: @glist.id).order('RAND()').first()
    end
    erb :elistJ
  end
   
  get "/createlist" do
    validate_user
    if @guser.blank?
      redirect "/"
    end
    erb:createList
  end
  
  post "/login_action" do
    @guser = GUser.find_by(username: params[:username])
    if !@guser.blank?
      if !@guser.active
        flash[:err] = "Account is no longer active!"
      else    
        hashed_pass = BCrypt::Password.new(@guser.password)
        if hashed_pass == params[:password]
          session[:guserid] = @guser.id
          puts "LOGGED IN " + @guser.username + " with ID: " + @guser.id.to_s
        else
          flash[:err] = "Invalid Username/Password Combination!"
        end
      end
    else
      flash[:err] = "Username Not Found!"
    end
    redirect back
  end
  
  get "/listApp/:user/:unique" do
    @user =  GUser.find_by(username: params[:user])
    @glist = List.find_by(user_id: @user.id, unique: params[:unique])
    @glist.approved = true
    @glist.save!
    redirect "/listApproval"
  end

  get "/listRej/:user/:unique" do
    @user =  GUser.find_by(username: params[:user])
    @glist = List.find_by(user_id: @user.id, unique: params[:unique])
    @glist.delete
    redirect "/listApproval"
  end
  
  post "/approvalPicProcess" do
    payload = request.body.read
    puts "Recieved" + payload
    data = JSON.parse(payload)
    if(data["approved"] == true)
      @dude = GUser.find_by(username: data["user"])
      @dude.pic_approved = true
      @dude.save!
    else
      @dude = GUser.find_by(username: data["user"])
      File.delete(@dude.profilepic.url) if File.exist?(@dude.profilepic.url)
      @dude.profilepic = nil
      @dude.pic_approved= true
      @dude.save!
    end
    content_type :json
    {
      success: true,
      isApproved: data["approve"]
    }.to_json
  end
  post "/voteProcess" do
    payload = request.body.read
    puts "Recieved" + payload
    data = JSON.parse(payload)
    right= ListItem.find_by(list_id: data["listU"], id: data["right"])
    left= ListItem.find_by(list_id: data["listU"], id: data["left"])
    puts "found right and left"
    diffone = left.value - right.value
    difftwo = right.value - left.value
    oneWP = 1.0/ (10.pow(diffone/400)+1)
    twoWP = 1.0/ (10.pow(difftwo/400)+1)
    puts "established variables"
    if(data["score"]=="1")
      right.value = right.value +(20*(1-oneWP))
      right.save!
      left.value = left.value + (20*(0-twoWP))
      left.save!
      puts "right wins and elo changed"
    elsif(data["score"]==0)
      right.value = right.value + (20*(0-oneWP))
      left.value = left.value + (20*(1-twoWP))
      right.save!
      left.save!
    else
      right.value = right.value + (20*(0.5-oneWP))
      left.value = left.value + (20*(0.5-twoWP))
      right.save!
      left.save!
    end
    item = ListItem.where(list_id: data["listU"]).order('RAND()').limit(2)
    @right = item.first()
    @left = item.last()
    while(@right == @left)
      @left = ListItem.where(list_id: data["listU"]).order('RAND()').first()
    end
    content_type :json
    {
      left: @left,
      right: @right,
      success: true
    }.to_json
  end
  post "/followerProcess" do
    payload = request.body.read
    puts "got " + payload
    data = JSON.parse(payload)
    succ = true
    followed = false
    @dude = GUser.find_by(username: data["user"])
    @folwer = GUser.find_by(username: data["follower"])
    followee = Follower.where("user_id = ? AND follower_id = ?", @dude.id, @folwer.id)
    if(data["follow"]== true)
      puts followee.to_s
      if(followee.blank?)
        Follower.create(user_id: @dude.id, follower_id: @folwer.id)
        puts @folwer.username + " FOLLOWING " + @dude.username
        followed = true
      else
        succ = false
        puts "ALREADY FOLLOWING ERROR"
      end
    else
      puts "ATTEMPTING TO UNFOLLOW"
      if(!followee.blank?)
        followee.destroy_all
        followed = false
      else
        succ = false
        puts "UNFOLLOWING ERROR"
      end
    end    
    follower_count = Follower.where(user_id: @dude.id).count
    content_type :json
    {
      success: succ,
      isFollowing: followed,
      fCount: follower_count
    }.to_json
  end 
  post "/edit_profile" do
    @user = GUser.find_by(id: session[:guserid])
    puts "USER FOUND: " + @user.username.to_s
    puts "EDITING BIO: " + params[:bio].to_s
    @user.update(bio_text: params[:bio])

    if !params[:formFile].blank?
      @user.profilepic = params[:formFile]
      puts "FILE INFO: " + @user.profilepic.to_s
      @user.pic_approved = false
      @user.save!
    else
      puts "file not saved"
    end
    @user = GUser.find_by(id: session[:guserid])

    puts "image url: " + @user.profilepic.url.to_s
    puts "image path: " + @user.profilepic.current_path.to_s
    puts "image identifier: " + @user.profilepic.identifier.to_s
    redirect "/profile/" + @user.username.to_s
  end
  post '/recruit' do
    @email = params[:email]
    open('emails.txt', 'a') { |f|
      f << @email
      f << "\n"
    }
    redirect "/about"
  end
  post '/list_action' do
    @user = GUser.find_by(id: session[:guserid])
    puts "USER FOUND: " + @user.username.to_s
    time = DateTime.now
    type = "gList"
    etype = "eList"
    uuid = SecureRandom.hex(12)
    num = params[:item_count].to_i
    if (num < 9) 
      @glist = List.create(user_id: @user.id, title: params[:listTitle], lType: type, created_at: time, modified_at: time, active: true, likes: 0, approved: false, unique: uuid)
    else
      @glist = List.create(user_id: @user.id, title: params[:listTitle], lType: etype, created_at: time, modified_at: time, active: true, likes: 0, approved: false, unique: uuid)
    end
    puts "List Created: "+ @glist.title
    puts "unique id is " + @glist.unique 
    count = 1
    while count <= num do
      input = "textarea"+count.to_s
      tit = "item"+count.to_s+"_title"
      imt = "input"+count.to_s
      
      @item = ListItem.create(list_id: @glist.id, description: params[input], rank: count, value: 1600, title: params[tit])
      count = count +1

      if !params[imt].blank? 
        @item.itemimg = params[imt]
        @item.save!
      end
    end
    redirect "/profile/" + @user.username.to_s
  end

  post'/listLikeAction' do
    payload = request.body.read
    data = JSON.parse(payload)

    @happyList = List.find_by(unique: data["listid"])
    @dude = GUser.find_by(username: data["liker"])
    
    listyLikey = ListLike.where("list_id = ? AND user_id = ?", @happyList.id, @dude.id)
    if(data["likeAction"])
      ListLike.create(list_id: @happyList.id, user_id: @dude.id)
    else
      listyLikey.destroy_all
    end
    
    @guy = GUser.find_by(username: data["happyUser"])
    if(data["likeAction"])
      @guy.guypoints = @guy.guypoints + 5
    else
      @guy.guypoints = @guy.guypoints - 5
    end
    @guy.save

    /update guy points here /
    /modify guy point of person who owns list, happyUser/

    likeCount = ListLike.where(list_id: @happyList.id).count
    @happyList.likes = likeCount
    @happyList.save
    
    content_type :json
    {
      likeNum: likeCount
    }.to_json
  end

  post'/cmtLikeAction' do
    payload = request.body.read
    data = JSON.parse(payload)
    puts "got payload: " + payload
    @happyGuy = GUser.find_by(username: data["happyUser"])
    @theList = List.find_by(unique: data["listid"])
    listOfCmts = Comment.where(user_id: @happyGuy.id, list_id: @theList.id)
    
    if listOfCmts.length()== 1
      @happyCmt = listOfCmts[0]
    else 
      listOfCmts.each do |n|
        if n.text == data["text"]
          @happyCmt = n
        end
      end
    end

    
    @dude = GUser.find_by(username: data["liker"])
     
    cmtLikey = CommentLike.where("comment_id = ? AND user_id = ?", @happyCmt.id, @dude.id)
    
    if(data["likeAction"])
      CommentLike.create(comment_id: @happyCmt.id, user_id: @dude.id)
    else
      cmtLikey.destroy_all
    end
    
    @guy = GUser.find_by(username: data["happyUser"])
    if(data["likeAction"])
      @guy.guypoints = @guy.guypoints + 2
    else
      @guy.guypoints = @guy.guypoints - 2
    end
    @guy.save

    likeCount = CommentLike.where(comment_id: @happyCmt.id).count
   
    @happyCmt.likes = likeCount
    @happyCmt.save

    likeString = likeCount
    puts likeCount
    
    content_type :json
    {
      likeNum: likeCount
    }.to_json
  end
  
  post '/commentAction' do
    payload = request.body.read
    puts "got " + payload
    data = JSON.parse(payload)
    user = GUser.find_by(username: data["commenter"])

    whichList = List.find_by(unique: data["listid"])
    Comment.create(text: data["commentText"], created_at: DateTime.now, list_id: whichList.id, user_id: user.id, likes: 0)
    if user.profilepic.blank?
      imgPath = "/imgs/defaultprofile.png"
    else
      imgPath = user.profilepic.url
    end
    
    userComments = Comment.where(list_id: whichList.id, user_id: user.id).order("created_at desc")
    allComments = Comment.where(list_id: whichList.id).order("created_at desc")
    imgs = []
    users = []
    boolLikes = []
    numLikes = []
    
    allComments.each do |comment|
      currUser = GUser.find(comment.user_id)
      users.append(currUser)
      
      boolLikes.append(CommentLike.find_by(comment_id: comment.id, user_id: user.id).blank?)
      
      numLikes.append(comment.likes)
      
      if currUser.profilepic.blank?
        imgs.append("/imgs/defaultprofile.png")
      else
        imgs.append(currUser.profilepic.url)
      end
    end
    content_type :json
    {
      prof: imgPath,
      userComments: userComments,
      allComments: allComments,
      profileImgs: imgs,
      allUsers: users,
      boolLikes: boolLikes,
      numLikes: numLikes
    }.to_json
  end
  
  post '/load_comments' do
    payload = request.body.read
    puts "got " + payload
    data = JSON.parse(payload)
    whichList = List.find_by(unique: data["listid"])
    allComments = Comment.where(list_id: whichList.id).offset(data["commentCount"]).order("created_at desc").limit(data["limit"])
    imgs = []
    users = []
    boolLikes = []
    numLikes = []
     
    theBro = GUser.find_by(username: data["theUser"])
    isUserAThing = !theBro.blank?
    
    allComments.each do |comment|
      currUser = GUser.find(comment.user_id)
      users.append(currUser)
      if(isUserAThing)
        boolLikes.append(CommentLike.find_by(comment_id: comment.id, user_id: theBro.id).blank?)
      else
        boolLikes.append(false)
      end

      numLikes.append(comment.likes)
      
      if currUser.profilepic.blank?
        imgs.append("/imgs/defaultprofile.png")
      else
        imgs.append(currUser.profilepic.url)
      end
    end
    content_type :json
    {
      allComments: allComments,
      profileImgs: imgs,
      allUsers: users,
      boolLikes: boolLikes,
      numLikes: numLikes
    }.to_json
  end

  not_found do
  status 404
  erb:oops
  end

  get '/hannah' do
    erb :cardle, :layout => false
  end

  
  post '/register_action' do
    @guser = GUser.find_by(username: params[:username].downcase)
    puts "POTENTIAL USERNAME: " + params[:username].to_s
    if @guser.blank?
      @guser = GUser.find_by(email: params[:email].downcase)
      if @guser.blank?
        puts "NO USER FOUND!"
        time = DateTime.now
        hashed_pwd = BCrypt::Password.create(params[:password])
        @guser = GUser.create(username: params[:username].downcase, password: hashed_pwd.to_s,
                              created_at: time, fname: params[:fname].capitalize, email: params[:email].downcase,
                              lname: params[:lname].capitalize, active: true, modified_at: time, guypoints: 0)
        puts "CREATED USER!"
        session[:guserid] = @guser.id
        redirect "/"
      else
        flash[:err] = "Email Already In Use!"
        puts "Error MSG: " + flash[:err].to_s
        redirect "/register"
      end
    else
      flash[:err] = "Username Already Exists"
      puts "Error MSG: " + flash[:err].to_s
      redirect "/register"
    end
  end   
end
