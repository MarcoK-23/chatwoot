import NavigatorResponseAPI from 'dashboard/api/navigator/response';
import { createStore } from '../captain/storeFactory';

export default createStore({
  name: 'NavigatorResponse',
  API: NavigatorResponseAPI,
}); 