class QuoteTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition
  
  belongs_to :quote
  
  ## Get quote statistic 
  scope :count_status, ->(account_id) { 
    joins(:quote)
    .where(quotes: { account_id: account_id }) 
    .group(:quote_id, :to_state)
    .count
  }

  def self.quote_stat(account_id)
    quote_stat = QuoteTransition.count_status(account_id)
    statistics = { draft: 0, sent: 0, declined: 0, accepted: 0, viewed: 0 }

    # Count each quote transition
    quote_stat.each do |k, v|
      statistics[k[1].to_sym] = statistics[k[1].to_sym] + 1
    end

    statistics
  end
end
