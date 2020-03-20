// document.addEventListener("turbolinks:load", () => {
//     alert("alert");
// })


//alert('<%= j DateTime.now %>');

$(document).ready(function() {
    $('#start_time').change(function() {
        if ($('#deadline').val() >= $('#start_time').val()) {
            $('#error').text("start time must be greater than deadline for registration");
            $('#submit').prop('disabled', true);
        } else {
            $('#error').text("");
            $('#submit').prop('disabled', false);
        }
    });

    $('#end_time').change(function() {
        if ($('#start_time').val() >= $('#end_time').val()) {
            $('#error').text("end time must be greater than start time");
            $('#submit').prop('disabled', true);
        } else {
            $('#error').text("");
            $('#submit').prop('disabled', false);
        }
    });
});