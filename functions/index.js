const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Function to reset requests every 6 hours (GET FARE)
exports.resetRequests = functions.pubsub.schedule("every 6 hours")
    .onRun(async (context) => {
      const firestore = admin.firestore();
      const collectionRef = firestore.collection("customers_location_name");

      try {
        const snapshot = await collectionRef.get();
        const batch = firestore.batch();

        snapshot.forEach((doc) => {
          batch.delete(doc.ref);
        });

        await batch.commit();
        console.log("Requests reset successfully");
      } catch (error) {
        console.error("Error resetting requests:", error);
      }

      return null;
    });

// Function to reset rides every 6 hours
exports.resetRides = functions.pubsub.schedule("every 6 hours")
    .onRun(async (context) => {
      const firestore = admin.firestore();
      const ridesRef = firestore.collection("rides");

      try {
        const snapshot = await ridesRef.get();
        const batch = firestore.batch();

        snapshot.forEach((doc) => {
          batch.delete(doc.ref);
        });

        await batch.commit();
        console.log("Successfully deleted all rides");
      } catch (error) {
        console.error("Error deleting rides:", error);
      }

      return null;
    });

// Function to send notification on new request (Get Fare)
exports.sendNewRequestNotificationFare = functions.firestore
    .document("customers_location_name/{docId}")
    .onCreate((snapshot, context) => {
      const data = snapshot.data();
      const payload = {
        notification: {
          title: "New Request",
          body: `Driver ${data.driver_name} has a new request.`,
        },
      };

      return admin.messaging().sendToTopic("allUsers", payload);
    });

// Function to send notification on new classified ad
exports.sendNewClassifiedAdNotification = functions.firestore
    .document("Classified_Ads/{docId}")
    .onCreate((snapshot, context) => {
      const data = snapshot.data();
      const payload = {
        notification: {
          title: "Classified Ad",
          body: `${data.driver_name} listed a new ad.`,
        },
      };

      return admin.messaging().sendToTopic("allUsers", payload);
    });

// Function to send notification on new ride
exports.sendNewRideNotification = functions.firestore
    .document("rides/{docId}")
    .onCreate((snapshot, context) => {
      const data = snapshot.data();
      const payload = {
        notification: {
          title: "New Ride",
          body: `${data.driver_name} added a new ride.`,
        },
      };

      return admin.messaging().sendToTopic("allUsers", payload);
    });
