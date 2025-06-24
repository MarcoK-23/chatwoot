import { FEATURE_FLAGS } from 'dashboard/featureFlags';
import { INSTALLATION_TYPES } from 'dashboard/constants/installationTypes';
import { frontendURL } from '../../../helper/URLHelper';
import AssistantIndex from './assistants/Index.vue';
import AssistantEdit from './assistants/Edit.vue';
import AssistantInboxesIndex from './assistants/inboxes/Index.vue';
import DocumentsIndex from './documents/Index.vue';
import ResponsesIndex from './responses/Index.vue';

export const routes = [
  {
    path: frontendURL('accounts/:accountId/navigator/assistants'),
    component: AssistantIndex,
    name: 'navigator_assistants_index',
    meta: {
      permissions: ['administrator', 'agent'],
      featureFlag: FEATURE_FLAGS.NAVIGATOR,
      installationTypes: [
        INSTALLATION_TYPES.CLOUD,
        INSTALLATION_TYPES.SELF_HOSTED,
      ],
    },
  },
  {
    path: frontendURL('accounts/:accountId/navigator/assistants/:assistantId'),
    component: AssistantEdit,
    name: 'navigator_assistants_edit',
    meta: {
      permissions: ['administrator', 'agent'],
      featureFlag: FEATURE_FLAGS.NAVIGATOR,
      installationTypes: [
        INSTALLATION_TYPES.CLOUD,
        INSTALLATION_TYPES.SELF_HOSTED,
      ],
    },
  },
  {
    path: frontendURL(
      'accounts/:accountId/navigator/assistants/:assistantId/inboxes'
    ),
    component: AssistantInboxesIndex,
    name: 'navigator_assistants_inboxes_index',
    meta: {
      permissions: ['administrator', 'agent'],
      featureFlag: FEATURE_FLAGS.NAVIGATOR,
      installationTypes: [
        INSTALLATION_TYPES.CLOUD,
        INSTALLATION_TYPES.SELF_HOSTED,
      ],
    },
  },
  {
    path: frontendURL('accounts/:accountId/navigator/documents'),
    component: DocumentsIndex,
    name: 'navigator_documents_index',
    meta: {
      permissions: ['administrator', 'agent'],
      featureFlag: FEATURE_FLAGS.NAVIGATOR,
      installationTypes: [
        INSTALLATION_TYPES.CLOUD,
        INSTALLATION_TYPES.SELF_HOSTED,
      ],
    },
  },
  {
    path: frontendURL('accounts/:accountId/navigator/responses'),
    component: ResponsesIndex,
    name: 'navigator_responses_index',
    meta: {
      permissions: ['administrator', 'agent'],
      featureFlag: FEATURE_FLAGS.NAVIGATOR,
      installationTypes: [
        INSTALLATION_TYPES.CLOUD,
        INSTALLATION_TYPES.SELF_HOSTED,
      ],
    },
  },
]; 