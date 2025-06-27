import NavigatorDocumentAPI from 'dashboard/api/navigator/document';
import { createStore } from '../navigator/storeFactory';

export default createStore({
  name: 'NavigatorDocument',
  API: NavigatorDocumentAPI,
}); 