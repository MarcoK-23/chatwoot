/* global axios */
import ApiClient from '../ApiClient';

class NavigatorDocument extends ApiClient {
  constructor() {
    super('navigator/documents', { accountScoped: true });
  }

  get({ page = 1, searchKey, assistantId } = {}) {
    return axios.get(this.url, {
      params: {
        page,
        searchKey,
        assistant_id: assistantId,
      },
    });
  }
}

export default new NavigatorDocument(); 