module MoviesHelper

  # return a link to sort. Helper for biderectional sorting
  def sortable(column, title)
    direction = (column == params[:sort] && params[:direction] == "desc") ? "asc" : "desc"
    link_to title, {:sort => column, :direction => direction, query: params[:query]}, class: 'sort-action'
  end

  def sortable_arrow
    if params[:direction] == 'asc'
      "<i class='fi-arrow-up'></i>".html_safe
    elsif params[:direction] == 'desc'
      "<i class='fi-arrow-down'></i>".html_safe
    end
  end

  def edit_movie_link(movie)
    if user_signed_in? and current_user == movie.user
      link_to '[Edit]', edit_movie_path(movie)
    end
  end

  def posted_by_link(movie)
      if user_signed_in? and movie.user == current_user
        link_to 'You', user_movies_path(movie.user.id)
      else
        link_to movie.user.fullname, user_movies_path(movie.user.id)
      end
  end
end

