class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @articles = Article.where("title ILIKE ?", "%#{params[:query]}%")
        .or(Article.where("content ILIKE ?", "%#{params[:query]}%"))
    elsif params[:filter_by].present?
      @articles = Article.where(category: params[:filter_by])
    else
      @articles = Article.all
    end
  end

  def show
    @article = Article.find(params[:id])
    @categorie = Category.new
  end

  def new
    @article = Article.new
    # @category = Category.new
    @categories = Instrument.categories
  end

  def edit
    @article = Article.find(params[:id])
    @categories = Article.categories
  end

  def create
    @article = Article.new(article_params)
    @category = Category.find(params[:id])
    @article.categories << @category

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :url, :category)
    end
end
