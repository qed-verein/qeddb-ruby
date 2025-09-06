# frozen_string_literal: true

module FinanceReviewHelper
  def payment_reasons
    [
      [t('.reasons.membership'), :membership],
      *@events.map { |ev| [ev.title, ev.id] }
    ]
  end

  def finance_review_link
    return unless policy(:finance_review).view?

    link_to t('actions.finance_review.view'), finance_review_path
  end
end
