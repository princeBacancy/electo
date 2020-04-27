import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
    connected() {
        // Called when the subscription is ready for use on the server
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        if ($("#refresh").data("id") === data.notification.recipient_id) {
            $("#refresh").load(window.location.href + " #refresh");
            if (Notification.permission === "granted") {
                var title = "e-medico"
                var body = data.notification.notification
                var options = {
                    body: body
                }
                new Notification(title, options);
            }
        }
    }
});