
$(document).on('submit','form#form-moviesdb',function(){
    $("span.label").removeClass("success");
    $("span.label").addClass("alert");
    $("span.label").text("Searching");
    $("#movie_title").val();
    $("#movie_description").val();

    $("input").prop('disabled', true);

});

$(document).on("click", "#searched-movie a", function(){
    var movie_id = $(this).parent().data("id");
    $("#searched-movie").empty();
    $("span.label").removeClass("success");
    $("span.label").addClass("alert");
    $("span.label").text("Getting movie details");
    $("input").prop('disabled', true);

    $.ajax({url: "/search/"+movie_id, success: function(result){
        $("input").prop('disabled', false);
        $("span.label").addClass("success");
        $("span.label").text("Not Searching");
        $("#searched-movie").empty();
        $("#movie_title").val(result.title);
        $("#movie_description").val(result.overview)

    }});
});
