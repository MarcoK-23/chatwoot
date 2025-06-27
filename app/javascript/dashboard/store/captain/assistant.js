import NavigatorAssistantAPI from 'dashboard/api/navigator/assistant';
import { createStore } from './storeFactory';

export default createStore({
  name: 'NavigatorAssistant',
  API: NavigatorAssistantAPI,
});
