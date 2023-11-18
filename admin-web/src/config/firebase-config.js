import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: 'AIzaSyCCSMs1Pcf-lNV-pkgPq_Lh61hDFfWn_T0',
  authDomain: 'epargnecollective-83f97.firebaseapp.com',
  projectId: 'epargnecollective-83f97',
  storageBucket: 'epargnecollective-83f97.appspot.com',
  messagingSenderId: '604316467070',
  appId: '1:604316467070:web:0081bf333aa57ecbeefd2f',
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const database = getFirestore(app);
