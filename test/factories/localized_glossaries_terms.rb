# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :localized_glossaries_term, :class => 'Localized::Glossaries::Term' do
    locale "MyString"
    name "MyString"
    abbreviation "MyString"
    description "MyString"
  end
end
