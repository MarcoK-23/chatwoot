import NavigatorDocumentAPI from 'dashboard/api/navigator/document';
import { createStore } from './storeFactory';

export default createStore({
  name: 'NavigatorDocument',
  API: NavigatorDocumentAPI,
});
