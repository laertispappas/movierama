module MoviesHelper

  # return a link to sort. Helper for biderectional sorting
  def sortable(column, title)
    direction = (column == params[:sort] && params[:direction] == "desc") ? "asc" : "desc"
    link_to title, {:sort => column, :direction => direction}, class: 'sort-action'
  end

  def sortable_arrow
    if params[:direction] == 'asc'
      "<i class='fi-arrow-up'></i>".html_safe
    elsif params[:direction] == 'desc'
      "<i class='fi-arrow-down'></i>".html_safe
    end
  end
end

