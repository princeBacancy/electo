import consumer from "./consumer"

consumer.subscriptions.create("ERoomChannel", {
    connected() {
        console.log("yay")
            // Called when the subscription is ready for use on the server
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        console.log(data.content)
        $('#messages').append('<div class="msg">' + data.content + '</div>')
            // Called when there's incoming data on the websocket for this channel
    }
});

var submit_messages;
$(document).on('turbolinks:load', function() {
    console.log("function")
    $('commit').on('keydown', function() {
        debugger
        console.log("submit");
        if (event.keyCode === 13) {
            $('input').click()
            event.target.value = ''
            event.preventDefault()
        }
    });
});

submit_messages = function() {

}