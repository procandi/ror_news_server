class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]

  #use for android search by title. @xieyinghua
  def search_by_title
    title=params[:title]
    @news=News.where("title like '%#{title}%'")

    respond_to do |format|
      if @news!=nil
        format.html { render :index }
        format.json { render json: @news, status: :ok }
      else
        @news = News.all
        format.html { render :index }
        format.json { render json: nil, status: :ok }
      end
    end
  end

  #use for android search by id. @xieyinghua
  def search_by_id
    id=params[:id]
    @news=News.where("id>=#{id}-10")

    respond_to do |format|
      if @news!=nil
        format.html { render :index }
        format.json { render json: @news, status: :ok }
      else
        @news = News.all
        format.html { render :index }
        format.json { render json: nil, status: :ok }
      end
    end
  end

  # GET /news
  # GET /news.json
  def index
    @news = News.all
  end

  # GET /news/1
  # GET /news/1.json
  def show
  end

  # GET /news/new
  def new
    @news = News.new
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news
  # POST /news.json
  def create
    if params[:cros]!='y'
      #create from page query. @xieyinghua
      @news = News.new(news_params)
    else
      #create from cros post. @xieyinghua
      new_news_params=Hash.new
      new_news_params[:postdate]=params[:postdate]
      new_news_params[:posttime]=params[:posttime]
      new_news_params[:title]=params[:title]
      new_news_params[:body]=params[:body]
      new_news_params[:picture]=params[:picture]

      @new=News.new(new_news_params)
    end

    respond_to do |format|
      if @news.save
        format.html { redirect_to @news, notice: 'News was successfully created.' }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    if params[:cros]=='y'
      #create from cros post. @xieyinghua
      id=params[:id]
      @news=News.where("id='#{id}'").first
      @user.postdate=params[:postdate]
      @user.posttime=params[:posttime]
      @user.title=params[:title]
      @user.body=params[:body]
      @user.picture=params[:picture]
    end

    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to @news, notice: 'News was successfully updated.' }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    if params[:cros]=='y'
      #create from cros post. @xieyinghua
      id=params[:id]
      @news=News.where("id='#{id}'").first
    end

    @news.destroy
    respond_to do |format|
      format.html { redirect_to news_index_url, notice: 'News was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_params
      params.require(:news).permit(:postdate, :posttime, :title, :body, :picture)
    end
end
