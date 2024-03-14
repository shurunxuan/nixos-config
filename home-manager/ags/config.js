import { Bar } from "./bar/bar.js"
import { NotificationPopups } from "./notification/notification.js"
import { applauncher } from "./launcher/launcher.js"

App.config({
    style: "./bar/style.css",
    windows: [Bar()]
})

App.config({
    style: "./notification/style.css",
    windows: [NotificationPopups()]
})

App.config({
    windows: [applauncher],
})