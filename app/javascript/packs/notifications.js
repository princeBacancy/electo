$(document).ready(function() {
    console.log("out");
    $('#mark_as_read').click(function() {
        console.log("delete")
        $.ajax({
            url: "/notifications/mark_as_read",
            type: "GET"
        });
        $("#refresh").load(window.location.href + " #refresh");
    });

});