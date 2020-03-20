import consumer from "./consumer"

consumer.subscriptions.create("ERoomChannel", {
    connected() {
        // Called when the subscription is ready for use on the server
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        console.log(data.message)
        $('#' + data.election_id).append('<div class="msg">' + data.message + '</div>')
            // Called when there's incoming data on the websocket for this channel
    }
});