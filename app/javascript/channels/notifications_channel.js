import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $("#notifications-counter").text(data.counter)
    $("#notifications-container").prepend(data.layout)
    toastr["info"](I18n.t("shared.new_notification"))
  }
});
