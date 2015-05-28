
module Searchable extend ActiveSupport::Concern

  module ClassMethods
    # sort by column. We axcept only likes hates and date as input from parameters
    def sort_by(column, direction)
      case column
        when 'likes'
          order(:cached_votes_up => direction)
        when 'hates'
          order(:cached_votes_down => direction)
        when 'date'
          order(:created_at => direction)
        else
          order(:cached_votes_up => direction)
      end
    end

    # need to reorder for search results from pg_search
    def sort_search_results(column, direction)
      case column
        when 'likes'
          reorder(:cached_votes_up => direction)
        when 'hates'
          reorder(:cached_votes_down => direction)
        when 'date'
          reorder(:created_at => direction)
        else
          reorder(:cached_votes_up => direction)
      end
    end
  end
end
