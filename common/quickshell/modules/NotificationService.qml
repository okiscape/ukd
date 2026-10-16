pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    component NotifWrapper: QtObject {
        required property int nid
        property Notification notification
        property bool popup: false
        property string appName:  notification?.appName  ?? ""
        property string appIcon:  notification?.appIcon  ?? ""
        property string summary:  notification?.summary  ?? ""
        property string body:     notification?.body     ?? ""
        property string image:    notification?.image    ?? ""
        property string urgency:  notification?.urgency.toString() ?? "normal"
        property double time

        onNotificationChanged: {
            if (notification === null)
                root.remove(nid)
        }
    }

    component PopupTimer: Timer {
        required property int nid
        interval: 5000
        running: true
        onTriggered: {
            root.hidePopup(nid)
            destroy()
        }
    }

    property list<NotifWrapper> list: []
    property var popupList: list.filter(n => n.popup)

    signal notificationAdded(wrapper: var)

    Component { id: wrapperComp;  NotifWrapper {} }
    Component { id: timerComp;    PopupTimer   {} }

    NotificationServer {
        id: server
        keepOnReload: false
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true

        onNotification: (notif) => {
            console.log("notification recieved")
            notif.tracked = true

            const w = wrapperComp.createObject(root, {
                "nid":          notif.id,
                "notification": notif,
                "time":         Date.now(),
                "popup":        true,
            })

            root.list = [...root.list, w]

            if (notif.expireTimeout !== 0) {
                timerComp.createObject(root, {
                    "nid":      w.nid,
                    "interval": notif.expireTimeout > 0 ? notif.expireTimeout : 5000,
                })
            }

            root.notificationAdded(w)
        }
    }

    function remove(nid) {
        const idx = list.findIndex(n => n.nid === nid)
        if (idx === -1) return
        const w = list[idx]
        if (w.notification !== null) w.notification.dismiss()
        list.splice(idx, 1)
        list = list.slice(0)
    }

    function hidePopup(nid) {
        const w = list.find(n => n.nid === nid)
        if (w) w.popup = false
        popupList = list.filter(n => n.popup)
    }

    function dismissAll() {
        list.forEach(w => { if (w.notification) w.notification.dismiss() })
        list = []
    }
}
