import NavigatorResponseAPI from 'dashboard/api/navigator/response';
import { createStore } from '../navigator/storeFactory';

export default createStore({
  name: 'NavigatorResponse',
  API: NavigatorResponseAPI,
}); 