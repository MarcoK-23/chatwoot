import NavigatorDocumentAPI from 'dashboard/api/navigator/document';
import { createStore } from '../captain/storeFactory';

export default createStore({
  name: 'NavigatorDocument',
  API: NavigatorDocumentAPI,
}); 