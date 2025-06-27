import CopilotThreadsAPI from 'dashboard/api/navigator/copilotThreads';
import { createStore } from './storeFactory';

export default createStore({
  name: 'CopilotThreads',
  API: CopilotThreadsAPI,
});
