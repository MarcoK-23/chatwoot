import NavigatorInboxes from 'dashboard/api/navigator/inboxes';
import { createStore } from '../captain/storeFactory';
import { throwErrorMessage } from 'dashboard/store/utils/api';

export default createStore({
  name: 'NavigatorInbox',
  API: NavigatorInboxes,
  actions: mutations => ({
    delete: async function remove({ commit }, { inboxId, assistantId }) {
      commit(mutations.SET_UI_FLAG, { deletingItem: true });
      try {
        await NavigatorInboxes.delete({ inboxId, assistantId });
        commit(mutations.DELETE, inboxId);
        commit(mutations.SET_UI_FLAG, { deletingItem: false });
        return inboxId;
      } catch (error) {
        commit(mutations.SET_UI_FLAG, { deletingItem: false });
        return throwErrorMessage(error);
      }
    },
  }),
}); 