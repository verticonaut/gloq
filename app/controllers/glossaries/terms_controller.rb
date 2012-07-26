class Glossaries::TermsController < ApplicationController

  before_filter :set_glossary

  # GET /glossaries
  # GET /glossaries.json
  def index
    @terms = @glossary.terms.search_by_name_and_type(params[:search_term], params[:type])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @terms }
    end
  end

  # GET /glossaries/1
  # GET /glossaries/1.json
  def show
    @term = @glossary.terms.find(params[:id]).prepare_for_display
    set_glossary_locale(params[:locale]) if params[:locale]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @term }
    end
  end


  # GET /glossaries/new
  # GET /glossaries/new.json
  def new
    @term = @glossary.terms.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @term }
    end
  end

  # GET /glossaries/1/edit
  def edit
    @term = @glossary.terms.find(params[:id]).prepare_for_display
  end

  # POST /glossaries
  # POST /glossaries.json
  def create
    @term = @glossary.create_term(params[:glossaries_term])

    respond_to do |format|
      if @term.save
        format.html { redirect_to glossary_term_path(@glossary, @term), notice: 'Term was successfully created.' }
        format.json { render json: @term, status: :created, location: @term }
      else
        format.html { render action: "new" }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end


private

  def set_glossary
    @glossary = Glossary.find(params[:glossary_id])
  end
end
