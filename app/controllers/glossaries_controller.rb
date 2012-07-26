class GlossariesController < ApplicationController
  # GET /glossaries
  # GET /glossaries.json
  def index
    glossary_search_locale = params[:search_g_locale]
    @glossaries            = Glossary.search_by(params[:term], glossary_search_locale).all

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        render json: Glossary.glossary_to_json(@glossaries, glossary_search_locale)
      }
    end
  end

  # GET /glossaries/1
  # GET /glossaries/1.json
  def show
    set_glossary_locale(params[:locale]) if params[:locale]

    respond_to do |format|
      format.html {
        redirect_to glossary_terms_path(params[:id])
      }
      format.json {
        @glossary = Glossary.find(params[:id]).prepare_for_display
        render json: @glossary
      }
    end
  end

  # GET /glossaries/new
  # GET /glossaries/new.json
  def new
    @glossary = Glossary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @glossary }
    end
  end

  # GET /glossaries/1/edit
  def edit
    @glossary = Glossary.find(params[:id]).prepare_for_display
  end

  # POST /glossaries
  # POST /glossaries.json
  def create
    @glossary = Glossary.create_glossary(params[:glossary])

    respond_to do |format|
      if @glossary.save
        format.html { redirect_to @glossary, notice: 'Glossary was successfully created.' }
        format.json { render json: @glossary, status: :created, location: @glossary }
      else
        format.html { render action: "new" }
        format.json { render json: @glossary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /glossaries/1
  # PUT /glossaries/1.json
  def update
    @glossary = Glossary.find(params[:id])
    saved = @glossary.update_glossary(params[:glossary])

    respond_to do |format|
      if saved
        format.html { redirect_to @glossary, notice: 'Glossary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @glossary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /glossaries/1
  # DELETE /glossaries/1.json
  def destroy
    @glossary = Glossary.find(params[:id])
    @glossary.destroy

    respond_to do |format|
      format.html { redirect_to glossaries_url }
      format.json { head :no_content }
    end
  end

  def locale
    set_glossary_locale(params[:locale])
    render nothing: true
  end


end
