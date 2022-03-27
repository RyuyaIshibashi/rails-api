class ArticlesController < ApplicationController
  def index
    articles = Article.recent
    render json: serializer.new(articles), status: :ok
  end

  def show
    render json: {}
  end

  def serializer
    ArticleSerializer
  end
end
