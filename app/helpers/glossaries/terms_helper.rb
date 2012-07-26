module Glossaries::TermsHelper

  def search_term_link(letter, glossary)
    if params[:type] == 'term_start' && letter == params[:search_term] then
      letter
    else
      link_to(letter, glossary_terms_path(glossary.id, { search_term: letter, type: 'term_start'}))
    end
  end

end
