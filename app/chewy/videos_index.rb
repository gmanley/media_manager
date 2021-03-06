class VideosIndex < Chewy::Index
  settings analysis: {
    tokenizer: {
      my_tokenizer: {
        type: 'standard'
      }
    },
    analyzer: {
      video_file_name: {
        tokenizer: 'my_tokenizer',
        filter: [
          'square_bracket_remover',
          'parentheses_remover',
          'date_normalizer',
          'ngram',
          'lowercase',
          'porter_stem'
        ]
      }
    },
    filter: {
      square_bracket_remover: {
        type: 'pattern_replace',
        pattern: '\[(.+?)\]',
        replacement: '$1 '
      },
      parentheses_remover: {
        type: 'pattern_replace',
        pattern: '\((.+?)\)',
        replacement: '$1 '
      },
      date_normalizer: {
        type: 'pattern_replace',
        pattern: '([0-9]{2,4})[-/\.]([0-9]{2})[-/\.]([0-9]{2,4})',
        replacement: '$1 $2 $3'
      },
      ngram: {
        type: 'edge_ngram',
        min_gram: 3,
        max_gram: 15
      }
    }
  }

  define_type Video do
    field :name, type: 'text', analyzer: 'video_file_name'
    field :name_sortable, type: 'keyword', value: ->(v) { v.name }
    field :formated_air_date, type: 'keyword', value: ->(v) { v.formated_air_date }
    field :file_hash, type: 'keyword'
    field :external_id, type: 'keyword'
    field :air_date, type: 'date'
  end
end
