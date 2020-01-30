class VideosIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      title: {
        tokenizer: 'keyword',
        filter: ['lowercase']
      }
    }
  }

  define_type Video do

  end
end



      # <analyzer type="index">
      #   <filter class="solr.PatternReplaceFilterFactory" pattern="\[(.+?)\]" replacement="$1 "/>
      #   <filter class="solr.PatternReplaceFilterFactory" pattern="\((.+?)\)" replacement="$1 "/>
      #   <filter class="solr.PatternReplaceFilterFactory" pattern="([0-9]{2,4})[-/\.]([0-9]{2})[-/\.]([0-9]{2,4})" replacement="$1 $2 $3"/>
      #   <!-- <charFilter class="solr.PatternReplaceCharFilterFactory" pattern="[-/\.]" replacement=" "/> -->
      #   <tokenizer class="solr.StandardTokenizerFactory"/>
      #   <filter class="solr.LowerCaseFilterFactory"/>
      #   <filter class="solr.PorterStemFilterFactory"/>
      #   <filter class="solr.NGramFilterFactory" minGramSize="3" maxGramSize="15"/>
      # </analyzer>
      # <analyzer type="query">
      #   <filter class="solr.PatternReplaceFilterFactory" pattern="\[(.+?)\]" replacement="$1 "/>
      #   <filter class="solr.PatternReplaceFilterFactory" pattern="\((.+?)\)" replacement="$1 "/>
      #   <filter class="solr.PatternReplaceFilterFactory" pattern="([0-9]{2,4})[-/\.]([0-9]{2})[-/\.]([0-9]{2,4})" replacement="$1 $2 $3"/>
      #   <!-- <charFilter class="solr.PatternReplaceCharFilterFactory" pattern="[-/\.]" replacement=" "/> -->
      #   <tokenizer class="solr.StandardTokenizerFactory"/>
      #   <filter class="solr.LowerCaseFilterFactory"/>
      #   <filter class="solr.PorterStemFilterFactory"/>
      # </analyzer>


  #   field :name, type: 'text', analyzer:
  #   string :name_sortable
  #   string :file_hash
  #   string :csv_number
  #   date :air_date


  #     Chewy.analyzer :name, filter: %w[lowercase icu_folding names_nysiis]
  #     Chewy.analyzer :phone, tokenizer: 'ngram', char_filter: ['phone']
  #     Chewy.tokenizer :ngram, type: 'nGram', min_gram: 3, max_gram: 26
  #     Chewy.char_filter :phone, type: 'pattern_replace', pattern: '[^\d]', replacement: ''
  #     Chewy.filter :names_nysiis, type: 'phonetic', encoder: 'nysiis', replace: false


  #     expect(documents.settings_hash).to eq(settings: {analysis: {
  #       analyzer: {name: {filter: %w[lowercase icu_folding names_nysiis]},
  #                  phone: {tokenizer: 'ngram', char_filter: ['phone']},
  #                  sorted: {option: :baz}},
  #       tokenizer: {ngram: {type: 'nGram', min_gram: 3, max_gram: 3}},
  #       char_filter: {phone: {type: 'pattern_replace', pattern: '[^\d]', replacement: ''}},
  #       filter: {names_nysiis: {type: 'phonetic', encoder: 'nysiis', replace: false}}
  #     }})



  # field :first_name, :last_name # multiple fields without additional options
  #   field :email, analyzer: 'email' # Elasticsearch-related options
  #   field :country, value: ->(user) { user.country.name } # custom value proc
  #   field :badges, value: ->(user) { user.badges.map(&:name) } # passing array values to index
  #   field :projects do # the same block syntax for multi_field, if `:type` is specified
  #     field :title
  #     field :description # default data type is `string`
  #     # additional top-level objects passed to value proc:
  #     field :categories, value: ->(project, user) { project.categories.map(&:name) if user.active? }
  #   end
  #   field :rating, type: 'integer' # custom data type
  #   field :created, type: 'date', include_in_all: false,
