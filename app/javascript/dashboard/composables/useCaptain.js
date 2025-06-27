import { computed } from 'vue';
import { useStore } from 'dashboard/composables/store.js';
import { useAccount } from 'dashboard/composables/useAccount';
import { useCamelCase } from 'dashboard/composables/useTransformKeys';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';

export function useNavigator() {
  const store = useStore();
  const { isCloudFeatureEnabled, currentAccount } = useAccount();

  const navigatorEnabled = computed(() => {
    return isCloudFeatureEnabled(FEATURE_FLAGS.NAVIGATOR);
  });

  const navigatorLimits = computed(() => {
    return currentAccount.value?.limits?.navigator;
  });

  const documentLimits = computed(() => {
    if (navigatorLimits.value?.documents) {
      return useCamelCase(navigatorLimits.value.documents);
    }

    return null;
  });

  const responseLimits = computed(() => {
    if (navigatorLimits.value?.responses) {
      return useCamelCase(navigatorLimits.value.responses);
    }

    return null;
  });

  const fetchLimits = () => {
    store.dispatch('accounts/limits');
  };

  return {
    navigatorEnabled,
    navigatorLimits,
    documentLimits,
    responseLimits,
    fetchLimits,
  };
}
