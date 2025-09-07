module WrapSummaryHelper
  def wrap_summary(condition, summary, &block)
    if condition
      tag.details { tag.summary { summary } + capture(&block) }
    else
      capture(&block)
    end
  end
end
