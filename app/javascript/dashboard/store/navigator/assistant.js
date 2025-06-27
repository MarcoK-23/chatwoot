import NavigatorAssistantAPI from 'dashboard/api/navigator/assistant';
import { createStore } from '../captain/storeFactory';

export default createStore({
  name: 'NavigatorAssistant',
  API: NavigatorAssistantAPI,
}); 