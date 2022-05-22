# frozen_string_literal: true

class BandsIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      description: {
        tokenizer: 'keyword',
        filter: ['lowercase']
      }
    }
  }

  index_scope Band
  field :name
  field :description, analyzer: 'description'
  field :phone_number
  field :social_links
  field :contact_name
  field :tags do
    field :name
  end
end
