FactoryGirl.define do
  factory :movie do
    title "Game of thrones"
    description "Game of thrones season1 winter is coming"
    user nil
  end

  factory :second_movie do
    title 'Gotham'
    description 'The story of officer gordon series'
    user nil
  end

end
