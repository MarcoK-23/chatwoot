import ApiClient from '../ApiClient';

class NavigatorBulkActionsAPI extends ApiClient {
  constructor() {
    super('navigator/bulk_actions', { accountScoped: true });
  }
}

export default new NavigatorBulkActionsAPI();
