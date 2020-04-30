import consumer from "./consumer"

consumer.subscriptions.create("ERoomChannel", {
    connected() {
        // Called when the subscription is ready for use on the server
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        $('.chat-box').load(window.location.href + ' .chat-box');
    }
});