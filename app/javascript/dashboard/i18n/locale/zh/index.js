import signup from './signup.json';
import webhooks from './webhooks.json';
import labelsMgmt from './labelsMgmt.json';
import login from './login.json';
import report from './report.json';
import resetPassword from './resetPassword.json';
import setNewPassword from './setNewPassword.json';
import settings from './settings.json';
import integrations from './integrations.json';
import inboxMgmt from './inboxMgmt.json';
import generalSettings from './generalSettings.json';
import conversation from './conversation.json';
import contact from './contact.json';
import cannedMgmt from './cannedMgmt.json';
import chatlist from './chatlist.json';
import agentMgmt from './agentMgmt.json';

export default {
  ...signup,
  ...webhooks,
  ...labelsMgmt,
  ...login,
  ...report,
  ...resetPassword,
  ...setNewPassword,
  ...settings,
  ...integrations,
  ...inboxMgmt,
  ...generalSettings,
  ...conversation,
  ...contact,
  ...cannedMgmt,
  ...chatlist,
  ...agentMgmt,
};
