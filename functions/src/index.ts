import functions = require("firebase-functions");
import admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

const firestore = admin.firestore();
const settings = {timestampsInSnapshots: true};
firestore.settings(settings);


exports.processSignUp = functions.auth.user().onCreate(async (user) => {
  return admin
    .auth()
    .setCustomUserClaims(user.uid, {
      "https://hasura.io/jwt/claims": {
        "x-hasura-default-role": "user",
        "x-hasura-allowed-roles": ["user","superadmin","doctor"],
        "x-hasura-user-id": user.uid,
      },
    })
    .then(async () => {
      await firestore.collection("users").doc(user.uid).set({
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    })
    .catch((error) => {
      console.log(error);
    });
});
