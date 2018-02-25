helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end

get '/' do 
    @posts = Post.order(created_at: :desc)
    erb :index
end

get '/login' do   #when a get request comes into /login
    erb(:login)   #render app/views/login.erb
end

post '/login' do
    username = params[:username]
    password = params[:password]
    
    user = User.find_by(username: username)
    
    if user && user.password == password
        session[:user_id] = user.id
        redirect(to('/'))
    else
        @error_message = "Login failed."
        erb(:login)
    end
end
    
get '/logout' do
    session[:user_id] = nil
    redirect(to('/'))
end

get '/home' do
    redirect(to('/'))
end

get '/' do
    @posts = post.order(created_at: :desc)
    erb(:index)
end

get '/posts/new' do     #GET HTTP method "display the form"
    @post = Post.new
    erb(:"posts/new")
end

post '/posts' do
    photo_url = params[:photo_url]
    
    #instantiate new post
    @post = Post.new({ photo_url: photo_url, user_id: current_user.id })
    
    #if @post validates, save
    if @post.save
        redirect(to('/'))
    else
        erb(:"posts/new")
        #if it doesn't validate, print error message
        #@post.errors.full_messages.inspect
    end
end

get '/posts/:id' do
    @post = Post.find(params[:id])  #find the post with the ID from the URL
    erb(:"posts/show")              #render app/views/posts/show.erb
end

get '/signup' do        #if a user navigates to the path "/signup",
    @user = User.new    #setup empty @user object
    erb(:signup)        #render "app/views/signup.erb"
end

post '/signup' do
    
    # grab user input values from params
    email       = params[:email]
    avatar_url  = params[:avatar_url]
    username    = params[:username]
    password    = params[:password]
    
   
    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
    
   
    if @user.save
        redirect(to('login'))
    else
        erb(:signup)
    end
end


post '/comments' do
    text = params[:text]
    post_id = params[:post_id]
    
    comment = Comment.new({ text: text, post_id: post_id, user_id: current_user.id})
    
    comment.save
    
    redirect(to('/'))
end
post '/likes' do 
    post_id = params[:post_id]
    
    like = Like.new({ post_id: post_id, user_id: current_user.id })
    
    like.save
    redirect(back)
end

delete '/likes/:id' do
    like = Like.find(params[:id])
    like.destroy
    redirect(back)
end