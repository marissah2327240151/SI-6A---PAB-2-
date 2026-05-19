importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

// Gunakan konfigurasi web dari firebase_options.dart Anda
firebase.initializeApp({
  apiKey: "AIzaSyC4F_drrXwW4ElYiw9Fd_AP_bEFkiy4XbU",
  authDomain: "notes-f0a92.firebaseapp.com",
  projectId: "notes-f0a92",
  storageBucket: "notes-f0a92.firebasestorage.app",
  messagingSenderId: "191611950738",
  appId: "1:191611950738:web:ff1e7799a5e85b4e0fb84b",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/favicon.png",
  };
  return self.registration.showNotification(notificationTitle, notificationOptions);
});
 