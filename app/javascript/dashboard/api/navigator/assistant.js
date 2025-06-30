/* global axios */
import ApiClient from '../ApiClient';

class NavigatorAssistant extends ApiClient {
  constructor() {
    super('navigator/assistants', { accountScoped: true });
  }

  get({ page = 1, searchKey } = {}) {
    return axios.get(this.url, {
      params: {
        page,
        searchKey,
      },
    });
  }

  create(params = {}) {
    return axios.post(this.url, params);
  }

  update({ id, ...params } = {}) {
    return axios.put(`${this.url}/${id}`, params);
  }

  delete({ id } = {}) {
    return axios.delete(`${this.url}/${id}`);
  }

  playground({ assistantId, messageContent, messageHistory }) {
    return axios.post(`${this.url}/${assistantId}/playground`, {
      message_content: messageContent,
      message_history: messageHistory,
    });
  }
}

export default new NavigatorAssistant(); 