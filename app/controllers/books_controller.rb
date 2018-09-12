class BooksController < ApplicationController
  include BookQuery

  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :search_params, only: [:index, :search]

  # GET /books
  # GET /books.json
  def index
    books_search = BookQuery.search(search_params)
    @presenter = Books::SearchPresenter.new(books_search)

    @books = Kaminari.paginate_array(
      books_search,
      total_count: @presenter.total_count
    ).page(search_params[:page]).per(Book.per_page)
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    books_search = BookQuery.search(search_params)
    @presenter = Books::SearchPresenter.new(books_search, search_params)

    @books = Kaminari.paginate_array(
      books_search,
      total_count: @presenter.total_count
    ).page(search_params[:page]).per(Book.per_page)
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:name, :description, :isbn, :author_id, :published_at, :pages, :book_category_id)
    end

    def search_params
      defaults = {
        book_category: '',
        query: '',
        gte: 0,
        lte: 9999,
        page: 1
      }

      params[:gte] = params[:range].split('-').first.to_i if params[:range]
      params[:lte] = params[:range].split('-').last.to_i if params[:range]

      params.permit(:query, :book_category, :gte, :lte, :page).reverse_merge(defaults)
    end
end
