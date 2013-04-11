module Nesta
  class App
    helpers do
      def search_index
        $search_index ||= Nesta::Plugin::Search::Index.new(:find_all, Nesta::Config.search_index_timeout).index
      end

      def article_index
        $article_index ||= Nesta::Plugin::Search::Index.new(:find_articles, Nesta::Config.search_index_timeout).index
      end

      def search_results index, term
        Nesta::Plugin::Search.results( index, term ) || []
      end
    end
  end

  class Config
    @settings += %w[ search_index_timeout search_ignore_list ]

    def self.search_index_timeout
      from_yaml("search_index_timeout")||false
    end

    def self.search_ignore_list
      (from_yaml("search_ignore_list")||["/"]) + %w[ /search ]
    end
  end

  module Plugin
    module Search

      def self.results index, term
        results = []
        index.search_each(term) do |key, score|
          results.push Nesta::Page.find_by_path(index[key][:href])# rescue nil
        end
        results
      end

      class Index
        attr_accessor :index_method

        # Currently imethod is expected to be:
        # - :find_all
        # - :find_articles
        #
        # Initializing with a timeout = false will
        # cause index to not expire without a server
        # restart.
        def initialize(imethod, timeout=false) # 12 hours default
          @index_method = imethod.to_sym
          if timeout
            @timeout = timeout
            @expire_at = Time.now+timeout
          end
        end

        def index
          # index and return if index doesn't exist or is empty
          return @index = reindex unless @index && @index.size > 0

          # return existing index if current index isn't expired or expired_at isn't set
          return @index if @expire_at && @expire_at > Time.now

          # if all else fails, index and return
          return @index = reindex
        end

        def reindex
          @index = Ferret::Index::Index.new

          Nesta::Page.send(@index_method).each do |item|
            unless Nesta::Config.search_ignore_list.include?(item.abspath)
              @index << {:heading => item.heading, :href => item.abspath, :summary => item.summary, :body => item.body}
            end
          end
          @index
        end
      end
    end
  end
end
