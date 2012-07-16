# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :loalized_glossary, :class => 'Loalized::Glossary' do
    glossary_id 1
    locale "MyString"
    name "MyString"
    abbreviation "MyString"
    description "MyText"
  end
end
