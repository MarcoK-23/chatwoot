import NavigatorAssistantAPI from 'dashboard/api/navigator/assistant';
import { createStore } from '../navigator/storeFactory';

export default createStore({
  name: 'NavigatorAssistant',
  API: NavigatorAssistantAPI,
}); 